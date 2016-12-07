//
//  ProgressView.swift
//  WBSwift
//
//  Created by Kevin on 2016/12/7.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5  - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * progress + startAngle
        let bezierPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        bezierPath.addLineToPoint(center)
        bezierPath.closePath()
        
        UIColor(white: 1.0, alpha: 0.4).setFill()
        bezierPath.fill()
    }
}
