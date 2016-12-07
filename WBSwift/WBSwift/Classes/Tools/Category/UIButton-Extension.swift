//
//  UIButton-Extension.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

extension UIButton {
    // convenience:使用此关键词修饰的函数为便利构造函数
    /*
     便利构造函数特点：
        1. 便利构造函数通常写在extension里面
        2. 便利构造函数前面需要加convenience
        3. 便利构造函数中需要明确调用self.init()
     */
    convenience init(imageName : String, bgImageName : String) {
        self.init()
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor: UIColor, fontSize : CGFloat, title : String) {
        self.init()
        setTitle(title, forState: .Normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
}