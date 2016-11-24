//
//  LYPresentationController.swift
//  WBSwift
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class LYPresentationController: UIPresentationController {
    lazy var coverView : UIView = UIView()
    var presentedFrame : CGRect = CGRectZero
    override func containerViewWillLayoutSubviews() {
        presentedView()?.frame = presentedFrame
        setupCoverView()
    }
}

// MARK: - 设置UI界面
extension LYPresentationController {
    private func setupCoverView() {
        containerView?.insertSubview(coverView, atIndex: 0)
        coverView.frame = containerView!.bounds
        
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        
        // 添加点击手势移除视图
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(LYPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}
// MARK: - 事件监听
extension LYPresentationController {
    @objc private func coverViewClick() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}