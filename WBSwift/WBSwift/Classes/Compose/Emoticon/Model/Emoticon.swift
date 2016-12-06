//
//  Emoticon.swift
//  Keyboard
//
//  Created by Kevin on 2016/12/5.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    // MARK: - 属性
    /// emoji的code
    var code : String? {
        didSet {
            guard let code = code else {
                return
            }
            // 1. 创建扫描器
            let scanner = NSScanner(string: code)
            // 2. 扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt(&value)
            // 3. 将value转成字符
            let c = Character(UnicodeScalar(value))
            // 4. 将字符转成字符串
            codeEmoji = String(c)
        }
    }
    /// 普通表情
    var png :String? {
        didSet {
            guard let png = png else {
                return
            }
            pngPath = NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png
        }
    }
    /// 普通表情对应的文字
    var chs : String?
    
    // MARK: - 数据处理
    var pngPath : String?
    var codeEmoji:String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    // MARK: - 自定义构造函数
    init(dict:[String:String]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    init(isRemove:Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override var description: String {
        return dictionaryWithValuesForKeys(["code", "pngPath", "chs"]).description
    }
}
