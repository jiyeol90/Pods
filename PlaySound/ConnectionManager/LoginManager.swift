//
//  LoginManager.swift
//  PlaySound
//
//  Created by james on 2021/09/15.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol LoginManagerDelegate {
    
    func didUpdateVerifyLogin()
    func didNotUpdateVerifyLogin()
    
}

struct LoginManager {
    
    var delegate: LoginManagerDelegate?
    
    func loginUser(userEmail: String, userFCMToken: String) {
        
        
        let queryParam: [String : String] = [
            "user_email": userEmail,
            "user_fcm_token": userFCMToken
        ]
        
        let url = API.BASE_URL + "/user/login"
        
        AF.request(url,
                   method: .post,
                   parameters: queryParam,
                   encoder: URLEncodedFormParameterEncoder.default
        ).responseJSON { response in
            
            debugPrint(response)
            
            switch response.result {
            case .success:
                print("서버와 통신 성공")
                
                if let jsonResponse = response.data {
                    do{
                        
                        let responseData = try JSON(data: jsonResponse)
                        let message = responseData["message"]
                        let result = responseData["type"]
                        
                        switch result {
                        case "success" :
                            
                            let userInfo = JSON(message)
                            
                            UserData.shared.userIdx = userInfo[0]["user_idx"].rawValue as? Int
                            UserData.shared.userProfileImageSrc = userInfo[0]["user_profile"].rawValue as? String
                            UserData.shared.userNickname = userInfo[0]["user_nickname"].rawValue as? String
                            UserData.shared.userBio = userInfo[0]["user_intro"].rawValue as? String
                            //UserData.shared.userPhoneNumber
                            UserData.shared.userCreatedTime = userInfo[0]["user_created_time"].rawValue as? String
                            UserData.shared.userDeletedTime = userInfo[0]["user_deleted_time"].rawValue as? String
                            UserData.shared.userLastLoginTime = userInfo[0]["user_last_login_time"].rawValue as? String
                            
                            UserData.shared.userConfDarkMode =  userInfo[0]["user_conf_darkmode"].rawValue as? Bool
                            UserData.shared.userConfNotiAll = userInfo[0]["user_conf_noti_all"].rawValue as? Bool
                            UserData.shared.userConfNotiChat = userInfo[0]["user_conf_noti_chat"].rawValue as? Bool
                            UserData.shared.userConfNotiInvite = userInfo[0]["user_conf_noti_invite"].rawValue as? Bool
                            UserData.shared.userConfNotiFollow = userInfo[0]["user_conf_noti_follow"].rawValue as? Bool
                            //UserData.shared.userConfNormalFiltering
                            //UserData.shared.userConfGameFiltering
                            UserData.shared.userFCMToken = userInfo[0]["user_last_login_time"].rawValue as? String
                            UserData.shared.userEmail = userInfo[0]["user_email"].rawValue as? String
                            UserData.shared.userAccessToken = userInfo[0]["user_refresh_token"].rawValue as? String
                            UserData.shared.userFollower = userInfo[0]["follower"].rawValue as? String
                            UserData.shared.userFollowing = userInfo[0]["following"].rawValue as? String
                            UserData.shared.userBlockList = userInfo[0]["block"].rawValue as? String
                            /*
                                        "user_idx": 1,
                                        "user_profile": "111111.1631162624120.jpg",
                                        "user_nickname": "roveloperaas",
                                        "user_intro": "asdaasfw",
                             
                                        "user_phone_number": 1051917480,
                                        "user_created_time": "2021-09-01T15:00:00.000Z",
                                        "user_deleted_time": null,
                                        "user_last_login_time": "2021-09-09T07:55:45.000Z",
                                        "user_conf_darkmode": true,
                                        "user_conf_noti_all": true,
                                        "user_conf_noti_chat": true,
                                        "user_conf_noti_invite": true,
                                        "user_conf_noti_follow": true,
                                        "user_conf_normal_filtering": null,
                                        "user_conf_game_filtering": null,
                                        "user_fcm_token": null,
                                        "user_email": "qwe",
                                        "user_refresh_token": null,
                                        "block": null,
                                        "follower": "9,8,7",
                                        "following": "6,8,9,5,5"
                             */
                     //https://playsound.co.kr/profile_images/aaaaaad.1631519511075.jpg
                            
                            self.delegate?.didUpdateVerifyLogin()
                            print("로그인 성공")
                        case "fail" :
                            self.delegate?.didNotUpdateVerifyLogin()
                            print("로그인 실패")
                        default:
                            print("switch default")
                        }
                        
                        
                    }
                    catch{
                        print("JSON Error")
                        
                    }
                    
                }
            case .failure(let error):
                print("서버와 통신 실패 \(error)")
                print("서버의 응답 \(response)")
            }
        }
    }
}
