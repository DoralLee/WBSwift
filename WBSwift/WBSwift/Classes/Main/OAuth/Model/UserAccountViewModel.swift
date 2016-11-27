//
//  UserAccountViewModel.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    // MARK: - 单例
    static let shareInstance : UserAccountViewModel = UserAccountViewModel()
    // MARK: - 计算属性
    var accountPath : String {
        // 1. 获取沙盒路径
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        print(accountPath)
        return (accountPath as NSString).stringByAppendingPathComponent("account.plist")
    }
    
    var isLogin : Bool {
        guard account != nil else{
            return false
        }
        guard let expriresDate = account?.expires_date else {
            return false
        }
        return expriresDate.compare(NSDate()) == .OrderedDescending
    }
    
    // MARK: - 定义属性
    var account : UserAccount?
    // MARK: - 重写init方法
    init() {
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
}
