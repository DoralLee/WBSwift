//
//  UserAccount.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    // MARK: - 属性
    ///用户授权
    var access_token : String?
    ///授权过期时间（秒）
    var expires_in : NSTimeInterval = 0.0 {
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    ///用户的UID
    var uid:String?
    
    ///过期日期
    var expires_date : NSDate?
    ///用户头像
    var avatar_large : String?
    ///用户昵称
    var screen_name : String?
    // MARK: - 自定义构造函数
    init(infoDict:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(infoDict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK: - 解档&归档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
}

