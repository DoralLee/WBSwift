//
//  NSDate-Extension.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import Foundation

extension NSDate {
    /// 根据时间间隔返回相应的字符串
    class func createDateString(createAt:String) -> String {
        // Tue May 31 17:46:55 +0800 2011
        let fmt = NSDateFormatter()
        fmt.locale = NSLocale.currentLocale()
        fmt.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        guard let createDate = fmt.dateFromString(createAt) else {
            return ""
        }
        
        // 创建当前时间
        let currentDate = NSDate()
        // 计算当前时间与创建时间间隔
        let interval = Int(currentDate.timeIntervalSinceDate(createDate))
        
        // 1. 一分钟内
        if interval < 60 {
            return "刚刚"
        }
        
        // 2. 一小时内
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 3. 一天内
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        // 4.处理昨天数据：昨天 11:22
        let calendar = NSCalendar.currentCalendar()
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            return fmt.stringFromDate(createDate)
        }
        // 5. 处理一年内数据： 05-12 12:23
        let components = calendar.components(.Year, fromDate: createDate, toDate: currentDate, options: [])
        if components.year < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.stringFromDate(createDate)
        }
        // 6. 超过一年：2012-12-12 12:12
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        return fmt.stringFromDate(createDate)
    }
}