//
//  UIBarButtonItem-Extension.swift
//  WBSwift
//
//  Created by mac on 16/11/24.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName : String) {
        let btn : UIButton = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        self.init(customView : btn)
    }
}
