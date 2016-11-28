//
//  Status.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class Status: BaseModel {
    // MARK: - 属性
    /// 微博信息内容
    var text : String?
    /// 创建时间
    var created_at : String?
    /// 微博mid
    var mid : Int = 0
    /// 来源
    var source : String?
    /// 转发数
    var reposts_count : Int = 0
    /// 评论数
    var comments_count : Int = 0
    /// 微博对应的用户信息
    var user : User?
    /// 微博的配图
    var pic_urls : [[String : String]]?

    // MARK: - 自定义构造函数
    init(statusDict:[String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(statusDict)
        
        if let userDict = statusDict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
    }
    
}
