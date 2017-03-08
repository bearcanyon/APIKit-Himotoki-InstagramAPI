//
//  InstagramRequest.swift
//  APIKit+Himotoki+InstagramAPI
//
//  Created by KumagaiNaoki on 2017/03/02.
//  Copyright © 2017年 KumagaiNaoki. All rights reserved.
//

import Foundation
import APIKit

protocol InstagramRequestType: Request { }
extension InstagramRequestType {
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return object
    }
}

struct GetInstagramRequest: InstagramRequestType {
    let accessToken: String
    typealias Response = InstagramData
    
    var baseURL: URL {
        return URL(string: "https://api.instagram.com/v1/users/self/media/recent?access_token="+accessToken)!
    }
    
    var method: HTTPMethod {
        return .get
    }
    var path: String {
        return ""
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> InstagramData {
        return try InstagramData.decodeValue(object)
    }
    init (accessToken: String) {
        self.accessToken = accessToken
    }
}
