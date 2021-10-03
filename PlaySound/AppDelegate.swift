//
//  AppDelegate.swift
//  PlaySound
//
//  Created by james on 2021/09/01.
//

import UIKit
import KakaoSDKCommon
import AuthenticationServices
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var loginManager = LoginManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //kakao iOS SDK 초기화 : iOS앱에서 iOS SDK를 사용하려면 임포트 후 초기화 하는 과정이 필요하다.
        KakaoSDKCommon.initSDK(appKey: KEY.kakaoAppKey)
        
        
        
        //FCM 초기화 코드
        FirebaseApp.configure()
        //메시지 대리자 설정
        Messaging.messaging().delegate = self
        self.loginManager.delegate = self
        
        //원격 알림에 앱을 등록
        //퍼미션 설정 다이얼로그를 보여준다. 적절한 시점에 보여주고 싶으면 이 코드를 옮겨주면 된다.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        // [END register_for_notifications]
        
        if let notification = launchOptions?[.remoteNotification] as? [String:AnyObject]{
            print(notification)
            print("푸시를 클릭하고 들어왔지만, 앱이 꺼져있는.. 완전히 종료된 상태에서 푸시 메시지를 클릭했을 때 호출되는 함수")
            //로그를 찍을 수 없다.
       
        }
        
  
        //apple인증
//        if #available(iOS 13.0, *) {
//            print("application 함수를 들어와라좀")
//            guard let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") else { return true }
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    print("apple 인증 성공")
//                    guard let userEmail = UserDefaults.standard.string(forKey: "appleEmail"), let userFCMToken = UserDefaults.standard.string(forKey: "fcmToken") else { return }
//                    print("apple email : " + userEmail)
//                    print("fcmToken : " + userFCMToken)
//                    self.loginManager.loginUser(userEmail: userEmail, userFCMToken: userFCMToken)
//                    break
//                case .revoked:
//                    print("apple 인증 만료")
//                    break
//                default:
//                    print("apple 이외 상태")
//                    break
//                }
//            }
//            
//        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let nickNameVC = storyboard.instantiateViewController(withIdentifier: "SignUpNickNameViewController") as? SignUpNickNameViewController else { return true}
//        self.window?.rootViewController = nickNameVC
//
        return true
    }
    
    //APN토큰과 등록 토큰 매핑
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        print("deviceToken 값 : \(deviceToken)")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

//    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("applicationDidBecomeActive")
//
//        if #available(iOS 13.0, *) {
//
//            let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier")!
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    print("인증 성공")
//                    break
//                case .revoked:
//                    print("인증 만료")
//                    break
//                default:
//                    print("이외 상태")
//                    break
//                }
//            }
//
//        }
//    }

}

//FCM 메시지 전송 토큰을 받는다.
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("파이어베이스 토큰: \(String(describing: fcmToken))")
        
        //fcm토큰값을 저장한다.
        print("fcm토큰 저장")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        UserData.shared.userFCMToken = fcmToken
        }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("앱이 켜져 있는 상태(foreground)에서 푸시를 받았을 때 호출 되는 함수")
        let userInfo = notification.request.content.userInfo
        print("수신알림메시지 : \(userInfo)")
        
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("두 번째 함수는 앱이 켜져 있지는 않지만 백그라운드로 돌고 있는 상태에서 푸시를 클릭하고 들어왔을 때 혹은 알림이 dismiss될 때 호출되는 함수")
        completionHandler()
    }
}

//애플 로그인은 해당 유저의 UserIdentifier 값의 유효성을
//ApplDelegate 에서 확인한다
extension AppDelegate: LoginManagerDelegate {
    
    
    func didUpdateVerifyLogin() {
        
        print("애플 자동 로그인")
        DispatchQueue.main.async {
            
            print("애플 자동 로그인 후 화면이동")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
            self.window?.rootViewController = mainVC
            mainVC.modalPresentationStyle = .fullScreen
            
            //self.window?.rootViewController?.present(mainVC, animated: true, completion: nil)
            
            print("애플 자동 로그인 후 화면이동 후")
        }
        
    }
    
    func didNotUpdateVerifyLogin() {
        print("로그인 실패시")
    }
    
    
}
