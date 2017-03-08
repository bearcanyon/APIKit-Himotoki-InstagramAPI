//
//  ViewController.swift
//  APIKit+Himotoki+InstagramAPI
//
//  Created by KumagaiNaoki on 2017/03/02.
//  Copyright © 2017年 KumagaiNaoki. All rights reserved.
//

import UIKit
import APIKit


class ViewController: UIViewController {
    
    let webView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ud = UserDefaults.standard
        if (ud.object(forKey: "accessToken") != nil) {
            let accessToken = ud.string(forKey: "accessToken")
            requestAPI(accessToken: accessToken!)
        } else {
            displayWebVeiw()
        }
    }
    
    func displayWebVeiw() {
        webView.delegate = self
        webView.frame = view.frame
        view.addSubview(webView)
        let url = URL(string: "***********************************秘密********************************************")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    func requestAPI(accessToken: String) {
        let request = GetInstagramRequest(accessToken: accessToken)
        Session.send(request) { result in
            switch result {
            case .success(let instagramData):
                self.webView.removeFromSuperview()
                var count = 0
                for imageURL in instagramData.imageURL {
                    let imageModel = Image()
                    let imageView = imageModel.imageURLToImageView(urlString: imageURL)
                    imageView.frame = CGRect(x: 0, y: count * 100 + 20, width: 100, height: 100)
                    self.view.addSubview(imageView)
                    
                    let label = imageModel.dateFormatter(dateString: instagramData.createdDate[count])
                    label.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: 15)
                    imageView.addSubview(label)
                    
                    count += 1
                }
            case .failure(let error):
                print("error\(error)")
            }
        }

    }
}

extension ViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType.rawValue == 1 {
            let urlArray = request.url?.absoluteString.components(separatedBy: "********************秘密***********************")
            if urlArray!.count > 1 {
                let access_token = urlArray?.last
                print(access_token)//codeだけ綺麗に取れた
                saveUserDefault(accessToken: access_token!)
                self.requestAPI(accessToken: access_token!)
            }
        }
        return true
    }
    func saveUserDefault(accessToken: String) {
        let ud = UserDefaults.standard
        ud.set(accessToken, forKey: "accessToken")
        ud.synchronize()
    }
}
