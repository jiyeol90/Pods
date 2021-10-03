//
//  ProfileViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/03.
//

import UIKit
import Kingfisher


class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var bioTextFiled: UITextView!
    @IBOutlet weak var userFollowing: UIStackView!
    
    let profileImgSrc: String = API.IMAGE_URL + UserData.shared.userProfileImageSrc!
    let following = UserData.shared.userFollowing
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bioTextFiled.layer.borderColor = UIColor.orange.cgColor
        bioTextFiled.layer.borderWidth = 2
        bioTextFiled.layer.cornerRadius = 15
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.borderColor = UIColor.orange.cgColor
        profileImage.layer.borderWidth = 5
        
        
        guard let url = URL(string: self.profileImgSrc) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
        
        
        let profileTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))

        profileImage.addGestureRecognizer(profileTapGesture)
        profileImage.isUserInteractionEnabled = true
        userNickname.text = UserData.shared.userNickname
        bioTextFiled.text = UserData.shared.userBio
        
        //following stackview 영역에 탭 제스처를 등록
        let followingTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followingTapped(_:)))
        
        userFollowing.addGestureRecognizer(followingTapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateProfileNotification(_:)), name: NSNotification.Name("UpdateProfileImage"), object: nil)
        
        print(following ?? "NoOne")
    }
    
    @IBAction func profileImageTapped(_ sender: Any) {
        
        print("프로필 이미지 터치")
        guard let editprofileVC = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as? EditProfileViewController else { return }
        
        present(editprofileVC, animated: true)
    }
    
    
    @IBAction func followingTapped(_ sender: Any) {
        
        print("팔로잉 터치")
//        guard let followingVC = self.storyboard?.instantiateViewController(identifier: "FollowingViewController") as? FollowingViewController else { return }
//
//
//
//        followingVC.modalPresentationStyle = .fullScreen
//        present(followingVC, animated: true)
        
        performSegue(withIdentifier: "following", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //present Modally 로 다른 화면을 띄운 경우에는 해당 화면으로 돌아올때 viewWillAppear가 호출되지 않는다.
    //NotificationCenter를 활용해 업데이트 해준다.
    @objc func didUpdateProfileNotification(_ notification: Notification) {
        print("프로필 이미지 변경")
        
        let updatedProfileImgSrc: String = API.IMAGE_URL + UserData.shared.userProfileImageSrc!
        guard let url = URL(string: updatedProfileImgSrc) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
     }
}
