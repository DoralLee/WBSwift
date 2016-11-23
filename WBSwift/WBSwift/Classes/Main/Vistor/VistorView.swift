//
//  VistorView.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class VistorView: UIView {
    @IBOutlet weak var rotationView: UIImageView!
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    class func vistorView() -> VistorView {
        return NSBundle.mainBundle().loadNibNamed("VistorView", owner: nil, options: nil).first as! VistorView
    }
    /**
     设置访客模式视图内容
     */
    func setupVistorViewInfo(iconName : String, tip : String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = tip
        rotationView.hidden = true
    }
    
    func addRotationAnimation() {

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.removedOnCompletion = false
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = 7
        
        rotationView.layer.addAnimation(rotationAnimation, forKey: nil)
    }
}
