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
    
    var CLIENTURL = ""
    var ACCESSTOKENURL = ""
    
    let webView = UIWebView()
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let env = ProcessInfo.processInfo.environment
        if let value = env["CLIENTURL"] {
            CLIENTURL = value
        }
        if let value = env["ACCESSTOKENURL"] {
            ACCESSTOKENURL = value
        }
        
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
        let url = URL(string: CLIENTURL)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    func requestAPI(accessToken: String) {
        logoutButton()
        
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
    func logoutButton() {
        let button = UIButton()
        button.frame = CGRect(x: 300, y: 300, width: 100, height: 15)
        button.backgroundColor = UIColor.black
        view.addSubview(button)
        button.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
    }
    func addLogoutProcess() {
    }
    func tapButton(sender: UIButton) {
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! as [HTTPCookie] {
            print(cookie)
            if cookie.domain == "www.instagram.com" || cookie.domain == "api.instagram.com" {
                cookieJar.deleteCookie(cookie)
                ud.removeObject(forKey: "accessToken")
            }
        }
        displayWebVeiw()
    }
}

extension ViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType.rawValue == 1 {
            let urlArray = request.url?.absoluteString.components(separatedBy: ACCESSTOKENURL)
            if urlArray!.count > 1 {
                let access_token = urlArray?.last
                saveUserDefault(accessToken: access_token!)
                self.requestAPI(accessToken: access_token!)
            }
        }
        return true
    }
    func saveUserDefault(accessToken: String) {
        ud.set(accessToken, forKey: "accessToken")
        ud.synchronize()
    }
}
