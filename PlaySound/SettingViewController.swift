//
//  SettingViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/03.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class SettingViewController: UIViewController {

  
    @IBOutlet weak var logoutBtn: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutBtnTapped))
        logoutBtn.isUserInteractionEnabled = true
        logoutBtn.addGestureRecognizer(tapGesture)
        
    }
    

    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func logoutBtnTapped(sender: UITapGestureRecognizer) {
        //로그인 타입에 따라(카카오 로그인, 애플로그인) 구분해서 로그아웃을 해줘야 하지만
        //지금은 모두다 로그아웃 처리를 하는 방향으로 해두었다.
        //향후 수정할것
        
        //로그아웃을 클릭할 시 alert 창을 띄어준다.
        let logoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        //취소를 클릭할 경우
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //로그아웃을 클릭할 경우
        let logoutAction = UIAlertAction(title: "OK", style: .destructive, handler: { UIAlertAction in
            
            print("로그아웃 구현")
            UserApi.shared.unlink {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("unlink() success.")
                    
                    guard let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
                    
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true, completion: nil)
    //                self.dismiss(animated: true, completion: nil)
                }
            }
            
            //애플 로그인시 로그아웃 할 경우
            //UserDefaults.standard.removeObject(forKey: "userIdentifier")
            UserDefaults.standard.set("",  forKey: "userIdentifier")
            guard let loginVC = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
            
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
            
        })
        
        logoutAlert.addAction(cancelAction)
        logoutAlert.addAction(logoutAction)

        present(logoutAlert, animated: true, completion: nil)
        
       
        
    }
    
}
