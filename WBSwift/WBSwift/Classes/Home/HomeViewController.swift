//
//  HomeViewController.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: BaseTableViewController {

    // MARK: - 懒加载属性
    lazy var titleViewButton : TitleViewButton = TitleViewButton()
    
    lazy var viewModels : [StatusViewModel] = [StatusViewModel]()

    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) in
        self?.titleViewButton.selected = presented
    }
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        vistorView.addRotationAnimation()
        if !isLogin {
            return
        }
        setupNavigationItem()
        
        loadStatus()
        // 不再使用系统的自动计算高度，所以舍弃该方法
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
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

// MARK: - 数据请求
extension HomeViewController {
    private func loadStatus() {
        NetworkTools.shareInstance.requestStatues { (result, error) in
            if error != nil {
                print(error)
                return
            }
            guard let resultArray = result else {
                return
            }
            
            for statusDict in resultArray {
                let status = Status(statusDict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
            }
            
            // 微博未提供图片尺寸，我们只能通过先缓存图片
            self.cacheImage(self.viewModels)
        }
    }
    
    private func cacheImage(viewModels:[StatusViewModel]) {
        let group = dispatch_group_create()
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    dispatch_group_leave(group)
                })
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.tableView.reloadData()
        }
    }
}

// MARK: - table view delegate
extension HomeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "homeCellID"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID) as! HomeViewCell
        let viewModel = viewModels[indexPath.row]
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight
    }
}
