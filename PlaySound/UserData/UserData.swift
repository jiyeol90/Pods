//
//  UserData.swift
//  PlaySound
//
//  Created by james on 2021/09/10.
//

import UIKit

public class UserData {
    
    //객체를 하나만 생성하여 공용으로 사용하기 위한 Singleton pattern
    static let shared = UserData()

    var userIdx: Int?
    
    //회원가입시 필요한 프로필 사진을 담는다.
    var userProfileImage: UIImage?
    //로그인시 받아올 이미지 소스 주소
    var userProfileImageSrc: String?
    
    var userNickname: String?
    var userBio: String?
    var userPhoneNumber: String?
    var userCreatedTime: String?
    var userDeletedTime: String?
    var userLastLoginTime: String?
    
    var userConfDarkMode: Bool?
    var userConfNotiAll: Bool?
    var userConfNotiChat: Bool?
    var userConfNotiInvite: Bool?
    var userConfNotiFollow: Bool?
    //userConfNormalFiltering
    //userConfGameFiltering
    var userFCMToken: String?
    var userEmail: String?
    var userAccessToken: String?
    //block
    var userFollower: String?
    var userFollowing: String?
    var userBlockList: String?
    
    //init함수를 호출해 Instance를 또 생성하는 것을 방지하기 위해 private으로 지정한다.
    private init() {}
}
