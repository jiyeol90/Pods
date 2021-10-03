//
//  MainViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/02.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var makeRoomBtn: UIButton!
    //확인 버튼을 감싸고 있는 뷰에 투명도를 성정하기 위한 뷰
    @IBOutlet weak var OpaqueView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    //@IBOutlet var swipeRecognizer: UISwipeGestureRecognizer!
    let profileImgSrc: String = API.IMAGE_URL + UserData.shared.userProfileImageSrc!
    
    //dummy data
    let arr = ["심심하면 여기로!!", "영화 토론방", "헬쓰를 하고 싶다면 여기로", "그냥 저냥 소소한", "성대모사 잘하는 분들", "독서 토론방", "친하게 지내요~"]
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()

//        tableView.layer.borderWidth = 2
//        tableView.layer.borderColor = UIColor.orange.cgColor
        
        //tableView.addBorder(toSide: .right, color: .orange, borderWidth: 2.0)
        
        // Do any additional setup after loading the view.
        
        //Swipe Gesture Recognizer의 direction은 default가 right이다.
        //swipeRecognizer.direction = .left

        makeRoomBtn.layer.cornerRadius = 25
        
        OpaqueView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        let nibName = UINib(nibName: "VoiceChatRoomTableViewCell", bundle: nil)
        
        tableView.register(nibName, forCellReuseIdentifier: "chatRoomCell")
   
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.borderColor = UIColor.orange.cgColor
        profileImage.layer.borderWidth = 2
        
        
        guard let url = URL(string: self.profileImgSrc) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
        
        let profileTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(_:)))

        profileImage.addGestureRecognizer(profileTapGesture)
        profileImage.isUserInteractionEnabled = true
        
        //로그인시 회원 정보 전달 확인
        print("[로그인한 유저 정보]")
        print("userBid :" + UserData.shared.userBio!)
        print("userIdx : " + String(UserData.shared.userIdx!))
        print("userRefreshToken : " + UserData.shared.userAccessToken!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateProfileNotification(_:)), name: NSNotification.Name("UpdateProfileImage"), object: nil)
        
    }
    
//    @IBAction func swipeAction(_ sender: Any) {
//        if swipeRecognizer.direction == .left{
//            //animateToTab(toIndex: tabBarController?.selectedIndex+1)
//            tabBarController?.selectedIndex = 1
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func profileImageTapped(_ sender: Any) {
        
        print("프로필 이미지 터치")
        guard let ProfileVC = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else { return }
        
        present(ProfileVC, animated: true)
    }
    
    
    @objc func didUpdateProfileNotification(_ notification: Notification) {
        print("프로필 이미지 변경")
        
        let updatedProfileImgSrc: String = API.IMAGE_URL + UserData.shared.userProfileImageSrc!
        guard let url = URL(string: updatedProfileImgSrc) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
     }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatRoomCell", for: indexPath) as! VoiceChatRoomTableViewCell
        
        cell.roomTitle.text = arr[indexPath.row]
        
    
        return cell
    }
    
    
}
