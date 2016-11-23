//
//  MessageViewController.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class MessageViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVistorView()
    }
}
// MARK: - 设置UI
extension MessageViewController {
    // 设置访客模式视图
    private func setupVistorView() {
        vistorView.setupVistorViewInfo("visitordiscover_image_message", tip: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }
}