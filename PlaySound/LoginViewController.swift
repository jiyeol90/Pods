//
//  ViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/01.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import AuthenticationServices

class LoginViewController: UIViewController {

    @IBOutlet weak var appleLoginView: UIStackView!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    //@IBOutlet weak var appleLoginButton: UIView!
    
    var loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //appleLoginButton.layer.cornerRadius = 5
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(appleLoginBtnTapped))
        
        //appleLoginButton.addGestureRecognizer(tapGestureRecognizer)
        
        loginManager.delegate = self
        
        setupProviderLoginView()
        
        
//        //토큰값 가지고 있나 확인
//        if (AuthApi.hasToken()) {
//            UserApi.shared.accessTokenInfo { (_, error) in
//                if let error = error {
//                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
//                        //로그인 필요
//                    }
//                    else {
//                        //기타 에러
//                    }
//                }
//                else {
//                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
//                    print("토큰값 가지고 있음")
//
//                    UserApi.shared.me() {(user, error) in
//                        if let error = error {
//                            print(error)
//                        }
//                        else {
//                            print("me() success.")
//
//                            //do something
//                            let email = user?.kakaoAccount?.email
//                            let nickName = user?.kakaoAccount?.profile?.nickname
//                            let legalName = user?.kakaoAccount?.legalName
//                            print("사용자 이메일 : \(email!)")
//                            print("사용자 닉네임: \(String(describing: nickName))")
//                            print("사용자 실명: \(String(describing: legalName))")
//                        }
//                    }
//                }
//            }
//        }
//        else {
//            print("토큰값이 없으므로 로그인이 필요합니다.")
//        }
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
           print("\(key) = \(value) \n")
         }
    }
    
    //애플에서 제공하는 버튼을 생성하고 TargetAction을 설정한다.
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.appleLoginView.addArrangedSubview(authorizationButton)
    }
   
//
//
//    //애플로그인
//    @objc func appleLoginBtnTapped(sender: UITapGestureRecognizer) {
//
//
//
//
//       moveToSignUpScene()
//    }
    
    @IBAction func kakaoLoginTapped(_ sender: Any) {
        
        //[카카오톡으로 로그인]
        //카카오톡 설치여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                   // _ = oauthToken
                    //access token
                    let accessToken = oauthToken?.accessToken
                    print("accessToken : \(accessToken!)")
                }
            }
        } else {
            //카카오가 설치되어 있지 않을경우
            //[카카오계정으로 로그인]
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        //_ = oauthToken
                        let accessToken = oauthToken?.accessToken
                        print("accessToken : \(accessToken!)")
                        
                        //accessToken은 매번 달라진다.
                        //Cf9VoyXmsWLcAo93J7XzcUhQ-A2dqdWmq_2CMQo9c-wAAAF7vrtS8A
                        //7ltz8OJsHOO2N1559iwoastfOFfB9-aMnr6F1wopb7gAAAF7vrvR-A
                        //ZmqIULCFlqqP7OYkgJI9IPzgXO2aiASj95uaOwo9cpgAAAF7vrwq3w
                        
                        //토큰을 받고 유저의 해당 이메일 정보를 얻어온다.
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
                                //이메일을 통해 사용자 여부 판단
                                //1. 회원이면 로그인처리를 해준다.
                                //2. 비회원이면 회원가입 절차를 진행한다.
                                
                            }
                        }
                

                        //self.moveToSignUpScene()
                    }
                }
        }
        
        
    }
    
    //회원가입 페이지로 이동
    func moveToSignUpScene() {
        guard let signUpProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpProfileViewController") else {
            return
        }
        signUpProfileVC.modalPresentationStyle = .fullScreen
        self.present(signUpProfileVC, animated: true, completion: nil)
    }
    
    //UUID 고유값 테스트
    func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    //sign with apple 컨테츠를 보여주기 위한 modal sheet 을 위치한다.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}


extension LoginViewController: ASAuthorizationControllerDelegate {
    
    //애플로그인 인증절차를 위한 함수
    /// - Tag: perform_appleid_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    //인증이 성공하면 호출된다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = credential.user
            let fullName = credential.fullName
            let appleEmail = credential.email
            
            print(#function)
            print(userIdentifier, fullName, appleEmail, separator: "\n")
            
            UserDefaults.standard.set(userIdentifier, forKey: "userIdentifier")
            
            //첫 인증시에만 이메일이 반환된다. 두번째부터는 이메일을 받지 못한다.
            //그러므로 이메일을 반환받을 때 UserDefault에 저장해 둔다.
            if appleEmail != nil {
                UserDefaults.standard.set(appleEmail, forKey: "appleEmail")
            }
            
            
            //인증이 성공하면 회원가입 여부를 email 주소로 확인
            //1. 회원인 경우 유저의 정보를 받고 메인화면으로 이동
            let user_email = UserDefaults.standard.string(forKey: "appleEmail")
            UserData.shared.userEmail = user_email
            let user_fcm_token = UserDefaults.standard.string(forKey: "fcmToken")!
            
            print("loginManager 호출")
            self.loginManager.loginUser(userEmail: user_email!, userFCMToken: user_fcm_token)
           
        }
    }
}

extension LoginViewController: LoginManagerDelegate {
    func didUpdateVerifyLogin() {
        
        print("회원가입후 로그인")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func didNotUpdateVerifyLogin() {
        print("로그인 실패 -> 회원가입 페이지로 이동한다.")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpProfileViewController") as? SignUpProfileViewController else { return }
        
        signupVC.modalPresentationStyle = .fullScreen
        self.present(signupVC, animated: true, completion: nil)
    }
    
    
}
