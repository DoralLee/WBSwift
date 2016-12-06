//
//  FindEmoticon.swift
//  正则表达式
//
//  Created by Kevin on 2016/12/6.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    static let shareInstance : FindEmoticon = FindEmoticon()
    
    private lazy var emoticonManager : EmoticonManager = EmoticonManager()
    
    func findEmoticonAttrString(statusText:String?, font : UIFont) -> NSMutableAttributedString? {
        guard let statusText = statusText else {
            return nil
        }
        // 1.创建规则
        let pattern2 = "\\[.*?\\]"
        // 2. 创建正则表达式对象
        guard let regex2 = try? NSRegularExpression(pattern: pattern2, options: []) else {
            return nil
        }
        // 3. 匹配字符串
        let results2 = regex2.matchesInString(statusText, options: [], range: NSMakeRange(0, statusText.characters.count))
        let attrMStr = NSMutableAttributedString(string: statusText)
        for result in results2.reverse() {
            let chs = (statusText as NSString).substringWithRange(result.range)
            
            guard let pngPath = findPngPath(chs) else {
                continue
            }
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            attrMStr.replaceCharactersInRange(result.range, withAttributedString: attrImageStr)
        }
        return attrMStr
    }
    
    private func findPngPath(chs:String) -> String? {
        for package in emoticonManager.emoticonPackages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
