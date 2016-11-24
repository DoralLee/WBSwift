//
//  TitleViewButton.swift
//  WBSwift
//
//  Created by mac on 16/11/24.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class TitleViewButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupTitleView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }
}

extension TitleViewButton {
    private func setupTitleView() {
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        sizeToFit()
    }
}
