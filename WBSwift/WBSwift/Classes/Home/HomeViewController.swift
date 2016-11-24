//
//  HomeViewController.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class HomeViewController: BaseTableViewController {

    lazy var titleViewButton : TitleViewButton = TitleViewButton()

    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) in
        self?.titleViewButton.selected = presented
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vistorView.addRotationAnimation()
        if !isLogin {
            return
        }
        setupNavigationItem()
        
    }

}
// MARK: - 设置UI界面
extension HomeViewController {
    /**
     设置导航条内容
     */
    private func setupNavigationItem() {
        // 设置nav左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")

        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 设置titleview
        titleViewButton.setTitle("Kevin", forState: .Normal)
        titleViewButton.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleViewButton
    }
}
// MARK: - 事件监听
extension HomeViewController {
    @objc private func titleBtnClick(titleBtn : TitleViewButton) {
        titleBtn.selected = !titleBtn.selected
        
        let popoverVC = PopoverViewController()
        popoverVC.transitioningDelegate = popoverAnimator
        let containerX = UIScreen.mainScreen().bounds.size.width * 0.25
        let containerW = UIScreen.mainScreen().bounds.size.width * 0.5
        popoverAnimator.presentedFrame = CGRectMake(containerX, 55, containerW, 250)
        
        popoverVC.modalPresentationStyle = .Custom
        
        self.presentViewController(popoverVC, animated: true, completion: nil)
        
    }
}
