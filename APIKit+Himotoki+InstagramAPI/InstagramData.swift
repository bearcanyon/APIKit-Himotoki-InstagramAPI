//
//  Response.swift
//  APIKit+Himotoki+InstagramAPI
//
//  Created by KumagaiNaoki on 2017/03/03.
//  Copyright © 2017年 KumagaiNaoki. All rights reserved.
//

import Foundation
import Himotoki//APIと一緒に使うHimotokiの使い方がわからない

struct InstagramData: Decodable {
    let imageURL: [String]
    let createdDate: [String]
    
    static func decode(_ e: Extractor) throws -> InstagramData {
        let g: [Extractor] = try! e <|| "data"
        var imageURLArray = [String]()
        var createdDateArray = [String]()
        for i in g {
            imageURLArray.append(try i <| ["images","standard_resolution","url"])
            createdDateArray.append(try i <| ["created_time"])
        }
        return InstagramData(imageURL: imageURLArray, createdDate: createdDateArray)
    }
    
    init(imageURL: [String], createdDate: [String]) {
        self.imageURL = imageURL
        self.createdDate = createdDate
    }

}
