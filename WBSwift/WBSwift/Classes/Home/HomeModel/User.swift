//
//  User.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class User: BaseModel {
    // MARK: - 属性
    /// 用户昵称
    var screen_name : String?
    /// 用户头像地址
    var profile_image_url : String?
    /// 是否微博认证用户
    var verified_type : Int = -1
    /// 会员等级
    var mbrank : Int = 0
    
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
}
