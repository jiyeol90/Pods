//
//  SingnUpProfileImageViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/01.
//

import UIKit

class SignUpProfileViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.제스처를 target-action으로 추가하는 방법
        //2.제스처를 delegate패턴으로 추가하는 방법
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        picker.delegate = self
        
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        //svg 이미지 색이 변하지 않는다.
        //profileImage.image = UIImage(named: "alarmBadgeBtn")
        
        //디폴트 이미지를 넣어준다.
        UserData.shared.userProfileImage = UIImage(named: "DefaultUserProfile")
        
    }
   
    

    // TODO: viewDidLayoutSubview()에 관해 정리할 것.
    /*
     if you do this in viewDidLoad, the transform has been reset by the time the view appears, so you should do this in viewDidLayoutSubviews…
     */
    override func viewDidLayoutSubviews() {
     
        //이미지뷰와 확인 버튼의 모서리를 세팅한다.
        confirmBtn.layer.cornerRadius = 25
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.borderColor = UIColor.orange.cgColor
        profileImage.layer.borderWidth = 5
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let alert =  UIAlertController()
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
            
            self.openLibrary()

        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in

            self.openCamera()

        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

        return true
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    

}

extension SignUpProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            
            print("이미지 출력 : \(image)")
            //UserData에 프로필을 저장한다.
            UserData.shared.userProfileImage = image
            print(info)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
