//
//  StatusViewModel.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    // MARK: - 属性
    var status : Status?
    // MARK: - 数据处理属性
    /// 真正显示的来源
    var sourceText : String?
    /// 真正显示的创建时间
    var createdAtText : String?
    /// 微博认证图片显示
    var verifiedImage : UIImage?
    /// 微博会员等级图片显示
    var rankImage : UIImage?
    /// 用户头像地址
    var profileURL : NSURL?
    /// 微博配图处理
    var picURLs : [NSURL] = [NSURL]()
    
    // MARK: - 构造函数
    init(status : Status) {
        self.status = status
        // 对来源进行处理
        if let source = status.source where source != "" {
            let starIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - starIndex
            sourceText = (source as NSString).substringWithRange(NSRange(location: starIndex, length: length))
        }
        // 对时间进行处理
        if let createdAt = status.created_at {
            createdAtText = NSDate.createDateString(createdAt)
        }
        
        // 对认证进行处理
        let verifiedType = status.user?.verified_type ?? -1
        
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 对会员等级进行处理
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            rankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = NSURL(string: profileURLString)
        
        // 微博配图处理
        if let picDicts = status.pic_urls {
            for picDict in picDicts {
                guard let pictString = picDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(NSURL(string : pictString)!)
            }
        }
    }
}
