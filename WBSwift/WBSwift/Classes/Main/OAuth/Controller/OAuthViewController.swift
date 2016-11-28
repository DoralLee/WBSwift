//
//  OAuthViewController.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/27.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: BaseViewController {
    // MARK: - 属性
    @IBOutlet weak var oAuthWebView: UIWebView!
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        
        loadLoginPage()
    }

}
// MARK: - 设置UI界面
extension OAuthViewController {
    /// 设置导航条内容
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.dismissItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        title = "登录界面"
    }
    
    /// 加载登陆页面
    private func loadLoginPage() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_url)"
        
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        let request = NSURLRequest(URL: url)
        
        oAuthWebView.loadRequest(request)
    }
}

// MARK: - 事件监听
extension OAuthViewController {
    @objc private func dismissItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        let userId = ""
        let passwd = ""
        let jsCode = "document.getElementById('userId').value='\(userId)';document.getElementById('passwd').value='\(passwd)'"
        oAuthWebView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK: - webview delegate 
extension OAuthViewController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.URL else {
            return true
        }
        let urlString = url.absoluteString
        guard urlString.containsString("code=") else {
            return true
        }
        
        let code = urlString.componentsSeparatedByString("code=").last!
        
        loadAccessToken(code)
        
        return false
    }
}

// MARK: - 请求数据
extension OAuthViewController {
    /// 获取授权数据
    private func loadAccessToken(code : String) {
        NetworkTools.shareInstance.requestAccessToken(code) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            if let result = result {
                let account = UserAccount.init(infoDict: result)
                self.loadAccountInfo(account)
            }
        }
    }
    /// 获取用户信息
    private func loadAccountInfo(account: UserAccount) {
        guard let accessToken = account.access_token else {
            return
        }
        guard let uid = account.uid else {
            return
        }
        
        NetworkTools.shareInstance.requestAccountInfo(accessToken, uid: uid) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            if let result = result {
                account.screen_name = result["screen_name"] as? String
                account.avatar_large = result["avatar_large"] as? String
                NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareInstance.accountPath)
                
                UserAccountViewModel.shareInstance.account = account
                
                self.dismissViewControllerAnimated(false, completion: { 
                    // 加载欢迎页面
                    UIApplication.sharedApplication().keyWindow?.rootViewController = WelcomeViewController()
                })
            }
        }
    }
}