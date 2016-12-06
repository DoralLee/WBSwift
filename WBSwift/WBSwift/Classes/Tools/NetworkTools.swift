//
//  NetworkTools.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/27.
//  Copyright © 2016年 kevin. All rights reserved.
//

import AFNetworking

enum RequestType:String {
    case Get = "GET"
    case Post = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools(baseURL: NSURL(string: WBBaseURL))
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

// MARK: - 封装请求方法
extension NetworkTools {
    // GET或POST请求数据
    func request(method : RequestType,URLString: String, parameters : AnyObject?, finishedCallBack:((result:AnyObject?, error:NSError?)->())?) {
        
        let successBack = { (task:NSURLSessionDataTask, result:AnyObject?) in
            if let callBack = finishedCallBack {
                callBack(result: result, error: nil)
            }
        }
        let failureBack = { (task:NSURLSessionDataTask?, error:NSError) in
            if let callBack = finishedCallBack {
                callBack(result: nil, error: error)
            }
        }
        
        if method == .Get {
            GET(URLString, parameters: parameters, progress: nil, success: successBack, failure: failureBack)
        } else {
            POST(URLString, parameters: parameters, progress: nil, success: successBack, failure: failureBack)
        }
        
    }
}

// MARK: - 进一步封装具体请求
extension NetworkTools {
    /// 获取accessToken
    func requestAccessToken(code:String, finishedCallBack:((result:[String:AnyObject]?, error: NSError?) -> ())?) {
        let urlString = "oauth2/access_token"
        let parameter = ["client_id":app_key, "client_secret":app_secret, "grant_type":"authorization_code", "code":code, "redirect_uri":redirect_url]
        
        request(.Post, URLString: urlString, parameters: parameter) { (result, error) in
            if let callBack = finishedCallBack {
                callBack(result: result as? [String:AnyObject], error: error)
            }
        }
    }
    ///获取用户信息
    func requestAccountInfo(accessToken : String, uid : String, finishCallBack:((result:[String: AnyObject]?, error:NSError?) -> ())?) {
        let urlString = "2/users/show.json"
        let parameter = ["access_token":accessToken, "uid":uid]
        request(.Get, URLString: urlString, parameters: parameter) { (result, error) in
            if let callBack = finishCallBack {
                callBack(result: result as? [String : AnyObject], error: error)
            }
        }
    }
    
    ///获取首页数据
    func requestStatues(since_id:Int, max_id:Int, finishCallBack:((result: [[String:AnyObject]]?, error:NSError?) -> ())?) {
        let urlString = "2/statuses/home_timeline.json"
        
        let parameter = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!, "since_id" : since_id, "max_id":max_id]
        request(.Get, URLString: urlString, parameters: parameter) { (result, error) in
            guard let resultDict = result as? [String : AnyObject] else {
                if let callBack = finishCallBack {
                    callBack(result: nil, error: error)
                }
                return
            }
            
            if let callBack = finishCallBack {
                callBack(result: resultDict["statuses"] as? [[String : AnyObject]], error: error)
            }
        }
    }
    
    /// 发送微博
    func postStatus(status:String, isSuccess:((isSuccess:Bool) -> ())?) {
        let urlString = "2/statuses/update.json"
        let parameter = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!, "status":status]
        request(.Post, URLString: urlString, parameters: parameter) { (result, error) in
            print(error)
            guard let success = isSuccess else {
                return
            }
            if result != nil {
                success(isSuccess: true)
            } else {
                success(isSuccess: false)
            }
        }
    }
    
    /// 发送带一张图片的微博
    func postStatus(status:String, image : UIImage, isSuccess:((isSuccess:Bool) -> ())?) {
        let urlString = "2/statuses/upload.json"
        let parameter = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token)!, "status":status]
        POST(urlString, parameters: parameter, constructingBodyWithBlock: { (formData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPartWithFileData(imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
            }, progress: nil, success: { (_, _) in
                if let success = isSuccess {
                    success(isSuccess: true)
                }
            }) { (_, error) in
                print(error)
                if let success = isSuccess {
                    success(isSuccess: false)
                }
        }
    }
}
