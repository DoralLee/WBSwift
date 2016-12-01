//
//  COmposeTextView.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/30.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {
    // MARK: - 属性
    private lazy var placeholderLabel : UILabel = UILabel()
    var isHiddenPlaceholder : Bool = false {
        didSet {
            placeholderLabel.hidden = isHiddenPlaceholder
        }
    }
    
    // MARK: - 系统方法
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

extension ComposeTextView {
    private func setupUI() {
        addSubview(placeholderLabel)
        
        placeholderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(8)
        }
        
        placeholderLabel.font = font
        placeholderLabel.textColor = UIColor.lightGrayColor()
        placeholderLabel.text = "分享新鲜事..."
        
        textContainerInset = UIEdgeInsetsMake(8, 5, 0, 5)
    }
}