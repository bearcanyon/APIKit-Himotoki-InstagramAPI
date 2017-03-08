//
//  Image.swift
//  APIKit+Himotoki+InstagramAPI
//
//  Created by KumagaiNaoki on 2017/03/06.
//  Copyright © 2017年 KumagaiNaoki. All rights reserved.
//

import Foundation
import SDWebImage


class Image {
    
    func imageURLToImageView(urlString: String) -> UIImageView {
        let url = URL(string: urlString)
        let imageVeiw = UIImageView()
        imageVeiw.sd_setImage(with: url)
        return imageVeiw
    }
    
    func dateFormatter(dateString: String) -> UILabel {
        let dateInt = Int(dateString)
        let dateUnix = TimeInterval(dateInt!)
        let currentDate = Date(timeIntervalSince1970: dateUnix)
        //currentDateで比較すれば任意の日付のものだけ取得できる
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: currentDate)
        let label = UILabel()
        label.text = dateString
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }
}
