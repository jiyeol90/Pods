//
//  SignupManager.swift
//  PlaySound
//
//  Created by james on 2021/09/10.
//

import Foundation
import Alamofire
import SwiftyJSON

@objc protocol SignupManagerDelegate {
    @objc optional func didUpdateValidateNickname()
    @objc optional func didNotUpdateValidateNickname()
    @objc optional func didSignupUser()
    @objc optional func didNotSignupUser()
}

struct SignupManager {
    
    var delegate: SignupManagerDelegate?
    
    func verifyNickname(nickname: String) {
        
        let queryParam = ["user_nickname": nickname]
        
        let url = API.BASE_URL + "/user/nickname/check/\(nickname)"
        
        AF.request(url,
                   method: .get,
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
                        let result = responseData["type"]
                        
                    
                        switch result {
                        case "success" :
                            self.delegate?.didUpdateValidateNickname!()
                            print("사용가능을 띄어준다")
                        case "fail" :
                            self.delegate?.didNotUpdateValidateNickname!()
                            print("사용불가를 띄어준다")
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
    
    func signupUser(userProfile: UIImage, userNickname: String, userBio: String, userEmail: String, userFCMToken: String ) {
        
        
        let parameters = ["user_nickname" : userNickname,
                          "user_intro" : userBio,
                          "user_email" : userEmail,
                          "user_fcm_token" : userFCMToken]
        
        print("parameters : \(parameters)")
        
        let fileName = "userProfile.jpeg"
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!,  withName: key, mimeType: "text/plain")
                }
                
                
                let imageData = userProfile.jpegData(compressionQuality: 1.0)
                multipartFormData.append(imageData!, withName: "user_profile", fileName: fileName, mimeType: "image/jpeg")
            },
            to: API.BASE_URL + "/user/" ,method: .post)
            .responseJSON{ response in
                debugPrint(response)
                
                switch response.result {
                case .success:
                    print("서버와 통신 성공")
                    
                    if let jsonResponse = response.data {
                        do{
                            
                            let responseData = try JSON(data: jsonResponse)
                            let message = responseData["message"]
                            let result = responseData["type"]
                            print("debugprint가 아닌 내가 직접 찍은 로그")
                            print("message : ")
                            print(message)
                            
                            print("result : ")
                            print(result)
                            
                            switch result {
                            case "success":
                                print("회원가입 성공")
                                print(message)
                                
                                let userInfo = JSON(message)
                                UserData.shared.userConfDarkMode =  userInfo[0]["user_conf_darkmode"].rawValue as? Bool
                                UserData.shared.userConfNotiAll = userInfo[0]["user_conf_noti_all"].rawValue as? Bool
                                UserData.shared.userConfNotiChat = userInfo[0]["user_conf_noti_chat"].rawValue as? Bool
                                UserData.shared.userConfNotiInvite = userInfo[0]["user_conf_noti_invite"].rawValue as? Bool
                                UserData.shared.userConfNotiFollow = userInfo[0]["user_conf_noti_follow"].rawValue as? Bool
                                UserData.shared.userIdx = userInfo[0]["user_idx"].rawValue as? Int
                                UserData.shared.userProfileImageSrc = userInfo[0]["user_profile"].rawValue as? String
                              
                                self.delegate?.didSignupUser!()
                                
                            case "fail":
                                print("회원가입 실패")
                                print(message)
                                self.delegate?.didNotSignupUser!()
                            default:
                                print("회원가입 통신에러")
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
