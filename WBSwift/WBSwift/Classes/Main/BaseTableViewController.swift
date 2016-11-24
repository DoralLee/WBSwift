//
//  BaseTableViewController.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    /// 懒加载访客模式视图
    lazy var vistorView : VistorView = VistorView.vistorView()
    
    var isLogin : Bool = true
    
    override func loadView() {
        isLogin ? super.loadView() : setupVistorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
}
// MARK: - 设置UI
extension BaseTableViewController  {
    private func setupVistorView() {
        view = vistorView
        vistorView.registerBtn.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick), forControlEvents: .TouchUpInside)
        vistorView.loginBtn.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick), forControlEvents: .TouchUpInside)
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(BaseTableViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(BaseTableViewController.loginBtnClick))
    }
}

// MARK: - 事件监听
extension BaseTableViewController {
    @objc private func registerBtnClick() {
        print("registerBtnClick")
    }
    
    @objc private func loginBtnClick() {
        print("loginBtnClick")
    }
}
