//
//  ComposeTitleView.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/30.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SnapKit
class ComposeTitleView: UIView {
     // MARK: - 属性
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var screenName : UILabel = UILabel()
    
    // MARK: - 系统方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

// MARK: - 设置UI
extension ComposeTitleView {
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(screenName)
        
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        screenName.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
            make.centerX.equalTo(titleLabel)
        }
        
        titleLabel.font = UIFont.systemFontOfSize(16)
        titleLabel.textAlignment = .Center
        screenName.font = UIFont.systemFontOfSize(14)
        screenName.textColor = UIColor.lightGrayColor()
        screenName.textAlignment = .Center
        
        titleLabel.text = "发微博"
        screenName.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
}