//
//  MySignupManager.swift
//  PlaySound
//
//  Created by james on 2021/09/13.
//

import Foundation
import Alamofire

final class MySignupManager {
    
    // 싱글턴 적용
    static let shared = MySignupManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                        [
                            BaseInterceptor()
                        ])
    
    //로거 성정
    //let monitors =
    
    //세션 설정
    var session : Session
    
    private init() {
        session = Session(interceptor: interceptors)
    }
}
