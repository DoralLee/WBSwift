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
        
        let popover = PopoverViewController()
        popover.modalPresentationStyle = .Custom
        self.presentViewController(popover, animated: true, completion: nil)
        
    }
}