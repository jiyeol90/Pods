//
//  SignUpNickNameViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/02.
//

import UIKit

class SignUpNickNameViewController: UIViewController {

    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
   
    @IBOutlet weak var validateIndicator: UIImageView!
    @IBOutlet weak var validateText: UILabel!
    
    var signupManager = SignupManager()
    var isChecked: Bool = false
    
    //내가 입력한 닉네임과 확인버튼을 누를때의 닉네임을 비교하는 과정을 위해
    var myNickname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        signupManager.delegate = self
        validateIndicator.isHidden = true
        validateText.isHidden = true
        
        //인디케이터의 이미지 색을 변경해주기위한 설정
        validateIndicator.image = validateIndicator.image!.withRenderingMode(.alwaysTemplate)
        confirmBtn.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        textField.layer.cornerRadius = 5
        confirmBtn.layer.cornerRadius = 25
        
        
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.layer.borderWidth = 2
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //키보드 바깥영역을 터치하면 키보드가 내려간다.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
            print("중복체크")
       }
    
    @objc func confirmBtnTapped() {
        if isChecked {
            
            if myNickname == textField.text && myNickname.isEmpty == false {
                
                UserData.shared.userNickname = myNickname
                
                print("다음 화면으로 이동")
                guard let signUpBioVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpBioViewController") else { return }
                signUpBioVC.modalPresentationStyle = .fullScreen
                self.present(signUpBioVC, animated: true, completion: nil)
                
            } else {
                print("아이디를 중복체크를 다시 해주세요")
                let alert = UIAlertController(title: "알림", message: "아이디를 중복체크를 다시 해주세요", preferredStyle: UIAlertController.Style.alert)
                let alertAction = UIAlertAction(title: "OK", style: .destructive)
                alert.addAction(alertAction)
                present(alert, animated: false, completion: nil)
            }
            
        } else {
            print("아이디를 제대로 입력해 주세요")
            let alert = UIAlertController(title: "알림", message: "아이디를 제대로 입력하세요", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: .destructive)
            alert.addAction(alertAction)
            present(alert, animated: false, completion: nil)
            
        }
    }
    
}

extension SignUpNickNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        print("리턴 버튼을 눌렀다.")
        
        guard let nickname = self.textField.text else {return true}
        
        myNickname = nickname
        //통신을 통해 중복인지 아닌지 확인한다.
        signupManager.verifyNickname(nickname: nickname)
        //manager.verifyNickname(nickname: nickname)
        
        return true
    }
    
    //텍스트필트
    func textFieldDidBeginEditing(_ textField: UITextField) {
        validateIndicator.isHidden = true
        validateText.isHidden = true
    }
    

}

extension SignUpNickNameViewController: SignupManagerDelegate {
    func didUpdateValidateNickname() {
        
        isChecked = true
        validateIndicator.image = UIImage(named: "validate")
        //validateIndicator.image = validateIndicator.image!.withRenderingMode(.alwaysTemplate)
        validateIndicator.tintColor = UIColor.systemGreen
        validateText.text = "사용 가능합니다."
        validateIndicator.isHidden = false
        validateText.isHidden = false

    }
    
    func didNotUpdateValidateNickname() {
      
        isChecked = false
        validateIndicator.image = UIImage(named: "invalidate")
        //validateIndicator.image = validateIndicator.image!.withRenderingMode(.alwaysTemplate)
        validateIndicator.tintColor = UIColor.systemRed
        validateText.text = "사용 불가합니다."
        validateIndicator.isHidden = false
        validateText.isHidden = false
    }
    
    
}
