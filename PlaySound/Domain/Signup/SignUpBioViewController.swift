//
//  SignUpBioViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/02.
//

import UIKit

class SignUpBioViewController: UIViewController {
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textCount: UILabel!
    
    var signupManager = SignupManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        signupManager.delegate = self
        bioTextView.delegate = self
        placeholderSetting()
        
        confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        setRadius()
        
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        
        bioTextView.layer.borderColor = UIColor.orange.cgColor
        bioTextView.layer.borderWidth = 2
        bioTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        //이곳에 둘 경우 계속 플레이스홀더가 갱신이 된다. 꼭 공부할 것.
        //placeholderSetting()
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func setRadius() {
        
        confirmBtn.layer.cornerRadius = 25
        textCount.clipsToBounds = true
        textCount.layer.cornerRadius = 20
        bioTextView.layer.cornerRadius = 15
    }
    
    //키보드 바깥영역을 터치하면 키보드가 내려간다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("중복체크")
    }
    
    @objc func confirmBtnTapped() {
        
        let bioText = bioTextView.text ?? ""
        UserData.shared.userBio = bioText
        
        let nickname = UserData.shared.userNickname ?? ""
        let email = UserData.shared.userEmail ?? ""
        let bio = UserData.shared.userBio ?? ""
        let photo = UserData.shared.userProfileImage!
        let fcmToken = UserData.shared.userFCMToken ?? ""
        
        print("================")
        print(nickname)
        print(email)
        print(bio)
        print(photo)
        print(fcmToken)
        print("================")
        
        signupManager.signupUser(userProfile: photo, userNickname: nickname, userBio: bio, userEmail: email, userFCMToken: fcmToken)
        //    func signupUser(userProfile: UIImage, userNickname: String, userBio: String, userEmail: String, userFCMToken: String ) {
        
       
        
    }
}

extension SignUpBioViewController : UITextViewDelegate {
    
    //placeholder를 주기위한 함수
    func placeholderSetting() {
        bioTextView.text = "자기 소개를 입력해 주세요."
        bioTextView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "자기 소개를 입력해 주세요."
            textView.textColor = UIColor.lightGray
            
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCount.text = "\(changedText.count) / 100"
        return changedText.count <= 100
    }
}

extension SignUpBioViewController: SignupManagerDelegate {
    //회원가입 성공시
    func didSignupUser() {
        print("회원가입 성공후 화면이동!!!!!!")
        guard let congratsVC = self.storyboard?.instantiateViewController(withIdentifier: "CongratsViewController") else { return }
        congratsVC.modalPresentationStyle = .fullScreen
        self.present(congratsVC, animated: true, completion: nil)
    }
    
    //회원가입 실패시
    func didNotSignupUser() {
        print("회원가입 실패 문구를 띄어준다.")
    }
}
