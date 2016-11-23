//
//  ProfileViewController.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class ProfileViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVistorView()
    }

}

// MARK: - 设置UI
extension ProfileViewController {
    // 设置访客模式视图
    private func setupVistorView() {
        vistorView.setupVistorViewInfo("visitordiscover_image_profile", tip: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }
}