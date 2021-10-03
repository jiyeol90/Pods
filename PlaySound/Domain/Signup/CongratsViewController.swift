//
//  CongratsViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/10.
//

import UIKit

//회원가입 완료후 로그인을 진행하고 성공할 경우 메인화면으로 넘어간다.

class CongratsViewController: UIViewController {

    @IBOutlet weak var congrats: UILabel!
    
    var loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginManager.delegate = self
        // Do any additional setup after loading the view.
        congrats.layer.cornerRadius = 20
        
        printUserData()
        moveToMainPage()
    }
    
//    override func viewDidLayoutSubviews() {
//        moveToMainPage()
//    }

    func moveToMainPage() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            guard let userEmail = UserData.shared.userEmail, let userFCMToken = UserData.shared.userFCMToken else { return }
            
            self.loginManager.loginUser(userEmail: userEmail, userFCMToken: userFCMToken)
            
          
        }
    }
    
    func printUserData() {
        
        let nickname = UserData.shared.userNickname
        let email = UserData.shared.userEmail
        let bio = UserData.shared.userBio
        let photo = UserData.shared.userProfileImage
        let fcmToken = UserData.shared.userFCMToken
      
        
        
//        print("========================")
//        print("nickname: \(nickname!)")
//        print("email: \(email!)")
//        print("bio: \(bio!)")
//        print("photo: \(photo!)")
//        print("fcmToken: \(fcmToken!)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CongratsViewController: LoginManagerDelegate {
    func didUpdateVerifyLogin() {
        
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
  
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }
    
    func didNotUpdateVerifyLogin() {
        print("로그인 오류 Alert창 띄어주기")
    }
    
    
}
