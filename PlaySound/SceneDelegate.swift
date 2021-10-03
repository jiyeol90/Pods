//
//  SceneDelegate.swift
//  PlaySound
//
//  Created by james on 2021/09/01.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    var loginManager = LoginManager()
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        self.loginManager.delegate = self
        
        //앱 실행 시 사용자가 앞서 로그인을 통해 발급 받은 토큰이 있는지 확인하려면 AuthApi의 hasToken() API를 호출한다.
        //hasToken()의 결과가 true라도 현재 사용자가 로그인 상태임을 보장하지 않는다.
        print("AuthApi.hasToken : " + String(AuthApi.hasToken()))
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //액세스 토큰 및 리프레시 토큰이 유효하지 않아 사용자 로그인 필요
                        print("로그인 필요")
                    }
                    else {
                        //각 에러에 맞는 처리 필요, 레퍼런스 참고
                        print("기타 에러")
                      
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    print("토큰 유효성 체크 성공(필요 시 토큰 갱신됨)")
                    UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("accessTokenInfo() success.")

                            //do something
                            //사용자 정보 가져오기
                            UserApi.shared.me() {(user, error) in
                                if let error = error {
                                    print(error)
                                }
                                else {
                                    print("me() success.")

                                    //do something
                                    guard let user_email = user?.kakaoAccount?.email! else {return}
                                    UserData.shared.userEmail = user_email
                                    
                                    let user_fcm_token = UserDefaults.standard.string(forKey: "fcmToken")!
                                    self.loginManager.loginUser(userEmail: user_email, userFCMToken: user_fcm_token)
                                  
//                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    guard let nickNameVC = storyboard.instantiateViewController(withIdentifier: "SignUpNickNameViewController") as? SignUpNickNameViewController else { return }
//                                    self.window?.rootViewController?.show(nickNameVC, sender: self)
                                    
                                    //이메일을 통해 사용자 여부 판단
                                    //1. 회원이면 자동로그인
                                    //2. 비회원이면 로그인화면으로 넘긴다.
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            //로그인 필요
            print("로그인 필요")
        }
        
        
              //apple인증
              if #available(iOS 13.0, *) {
                  print("application 함수를 들어와라좀")
                  guard let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") else { return }
                  let appleIDProvider = ASAuthorizationAppleIDProvider()
                  appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                      switch credentialState {
                      case .authorized:
                          print("apple 인증 성공")
                          guard let userEmail = UserDefaults.standard.string(forKey: "appleEmail"), let userFCMToken = UserDefaults.standard.string(forKey: "fcmToken") else { return }
                          print("apple email : " + userEmail)
                          print("fcmToken : " + userFCMToken)
                          self.loginManager.loginUser(userEmail: userEmail, userFCMToken: userFCMToken)
                          break
                      case .revoked:
                          print("apple 인증 만료")
                          break
                      default:
                          print("apple 이외 상태")
                          break
                      }
                  }
                  
              }
    }
    
    /*
     [카카오 톡으로 로그인을 위한 설정]
     카카오톡에서 서비스 앱으로 돌아왔을 때 카카오 로그인 처리를 정상적으로 완료하기 위한과정
     */
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
            if let url = URLContexts.first?.url {
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
            }
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: LoginManagerDelegate {
    func didUpdateVerifyLogin() {
        
        //Main.storyboard 가져오기
        print("카카오 자동 로그인")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        window?.rootViewController = mainVC
        // 1초 후 실행될 부분
        
//        let tb = UITabBarController()
//            let vcName = self.storyboard?.instantiateViewController(withIdentifier: "TabBarControllerMain") as? UITabBarController
//            vcName?.modalPresentationStyle = .fullScreen
//        tb.modalPresentationStyle = .fullScreen
//        tb.setViewControllers([first], animated: true)
//            vcName?.setViewControllers([first], animated: true)

//        self.present(tb, animated: true, completion: nil)
    }
    
    func didNotUpdateVerifyLogin() {
        print("로그인 실패시")
    }
    
    
}
