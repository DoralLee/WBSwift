//
//  HomeViewController.swift
//  WBSwift
//
//  Created by mac on 16/11/23.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

private let kTipStartY :CGFloat = 10
private let kTipDisplayY : CGFloat = 44
private let kTipAnimationDuration : NSTimeInterval = 1.0

class HomeViewController: BaseTableViewController {

    // MARK: - 懒加载属性
    lazy var titleViewButton : TitleViewButton = TitleViewButton()
    
    lazy var viewModels : [StatusViewModel] = [StatusViewModel]()

    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) in
        self?.titleViewButton.selected = presented
    }
    lazy var tipLabel : UILabel = UILabel()
    private lazy var photoBrowserAnimation = PhotoBrowserAnimation()
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        vistorView.addRotationAnimation()
        if !isLogin {
            return
        }
        setupNavigationItem()
        // 不再使用系统的自动计算高度，所以舍弃该方法
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        setupHeaderRefresh()
        setupFooterRefresh()
        
        setupTipLabel()

        setupNotification()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        let title = UserAccountViewModel.shareInstance.account?.screen_name ?? ""
        titleViewButton.setTitle(title, forState: .Normal)
        titleViewButton.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleViewButton
    }
    
    /// 设置下拉刷新
    private func setupHeaderRefresh() {
        let header = MJRefreshNormalHeader {[weak self] in
            self?.loadStatus(true)
        }
        header.setTitle("下拉刷新", forState: .Idle)
        header.setTitle("松手更新", forState: .Pulling)
        header.setTitle("正在刷新。。。", forState: .Refreshing)
        
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    /// 设置上提加载
    private func setupFooterRefresh() {
        tableView.mj_footer = MJRefreshAutoFooter { [weak self]  in
            self?.loadStatus(false)
        }
    }
    
    private func setupTipLabel() {
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        tipLabel.frame = CGRectMake(0, kTipStartY, UIScreen.mainScreen().bounds.width, 32)
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textAlignment = .Center
        tipLabel.hidden = true
    }
    
    private func setupNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.tapPicCollectionCellNoti(_:)), name: PhotoBrowserDidSelectedCellKey, object: nil)
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
    
    @objc private func tapPicCollectionCellNoti(noti:NSNotification) {
        guard let indexPath = noti.userInfo![PhotoBrowserIndexPathkey] as? NSIndexPath else {
            return
        }
        guard let picUrls = noti.userInfo![PhotoBrowserPicUrlsKey] as? [NSURL] else {
            return
        }
        let picCollectionView = noti.object as! PicCollectionView
        
        let photoBrowserVC = PhotoBrwoserViewController(indexPath: indexPath, picUrls: picUrls)
        photoBrowserVC.modalPresentationStyle = .Custom
        photoBrowserVC.transitioningDelegate = photoBrowserAnimation
        photoBrowserAnimation.presentedDelegate = picCollectionView
        photoBrowserAnimation.dismissDelegate = photoBrowserVC
        photoBrowserAnimation.indexPath = indexPath
        presentViewController(photoBrowserVC, animated: true, completion: nil)
    }
}

// MARK: - 数据请求
extension HomeViewController {
    private func loadStatus(isRefresh:Bool) {
        var sinceId = 0
        var maxId = 0
        if isRefresh {
            sinceId = viewModels.first?.status?.mid ?? 0
        } else {
            maxId = viewModels.last?.status?.mid ?? 0
            maxId = maxId == 0 ? 0 : maxId - 1
        }
        
        NetworkTools.shareInstance.requestStatues(sinceId, max_id: maxId) { (result, error) in
            if error != nil {
                print(error)
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
            guard let resultArray = result else {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
            var tempViewModels = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(statusDict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModels.append(viewModel)
            }
            if isRefresh {
                self.viewModels = tempViewModels + self.viewModels
            } else {
                self.viewModels += tempViewModels
            }
            // 微博未提供图片尺寸，我们只能通过先缓存图片
            self.cacheImage(tempViewModels, isRefresh: isRefresh)
        }

    }
    
    private func cacheImage(viewModels:[StatusViewModel], isRefresh:Bool) {
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
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if isRefresh {
                self.animationDisplayTipLabel(viewModels.count)
            }
        }
    }
    
    private func animationDisplayTipLabel(count : Int) {
        tipLabel.text = count == 0 ? "没有最新微博" : "\(count)条新微博"
        UIView.animateWithDuration(kTipAnimationDuration, animations: { 
            self.tipLabel.hidden = false
            self.tipLabel.frame.origin.y = kTipDisplayY
            }) { (_) in
                UIView.animateWithDuration(kTipAnimationDuration, delay: kTipAnimationDuration, options: [], animations: { 
                    self.tipLabel.frame.origin.y = kTipStartY
                    }, completion: { (_) in
                        self.tipLabel.hidden = true
                })
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
