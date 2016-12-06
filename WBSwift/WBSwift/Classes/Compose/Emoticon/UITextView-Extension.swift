//
//  UITextView-Extension.swift
//  Keyboard
//
//  Created by Kevin on 2016/12/6.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

extension UITextView {
    ///  获取表情字符串
    func getEmoticonString() -> String {
        let attMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSMakeRange(0, attMStr.length)
        attMStr.enumerateAttributesInRange(range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attMStr.replaceCharactersInRange(range, withString: attachment.chs!)
            }
        }
        return attMStr.string
    }
    
    /// 给textview插入表情
    func insertEmoticon(emoticon:Emoticon) {
        if emoticon.isEmpty {
            return
        }
        
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        if let codeEmoji = emoticon.codeEmoji {
            let textRange = selectedTextRange!
            replaceRange(textRange, withText: codeEmoji)
            return
        }
        // 处理普通表情
        let attachment = EmoticonAttachment()
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        attachment.chs = emoticon.chs!
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attachImageStr = NSAttributedString(attachment: attachment)
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = selectedRange
        attrMStr.replaceCharactersInRange(range, withAttributedString: attachImageStr)
        
        attributedText = attrMStr
        
        // 重置字体解决之后的字体缩小问题
        self.font = font
        // 重置光标位置解决光标跳到最末尾的问题
        selectedRange = NSMakeRange(range.location + 1, 0)
    }
}
