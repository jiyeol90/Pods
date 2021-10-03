//
//  ProfileImgManager.swift
//  PlaySound
//
//  Created by james on 2021/09/17.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ProfileImgManagerDelegate {
    
    func didUpdateProfileImg()
    func didNotUpdateProfileImg()
    
}

struct ProfileImgManager {
    
    var delegate: ProfileImgManagerDelegate?

    func updateProfileImg(userProfile: UIImage) {
        
        
        let user_idx = String(UserData.shared.userIdx!)
        
        let parameters = [ "user_idx" : user_idx ]
        
        let url = API.BASE_URL + "/user/profile"
        
        let fileName = "userProfile.jpeg"
        
        print("parameters : \(parameters)")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!,  withName: key, mimeType: "text/plain")
                }
                
                
                let imageData = userProfile.jpegData(compressionQuality: 1.0)
                multipartFormData.append(imageData!, withName: "user_profile", fileName: fileName, mimeType: "image/jpeg")
            },
            to: url ,method: .patch)
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
                            
                            
                            switch result {
                            case "success":
                                print("프로필 업데이트 성공")
                                print(message)
                                
                                let userInfo = JSON(message)
                                let resultMsg = userInfo[0]["msg"].rawValue as? String
                                print(resultMsg!)
                                UserData.shared.userProfileImageSrc = userInfo[0]["value"].rawValue as? String
                               
                                self.delegate?.didUpdateProfileImg()
                                
                            case "fail":
                                print("프로필 업데이트 실패")
                                print(message)
                                self.delegate?.didNotUpdateProfileImg()
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
