//
//  HomeViewCell.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SDWebImage
import HYLabel

private let edgeMargin : CGFloat = 15

private let itemMargin : CGFloat = 10

class HomeViewCell: BaseTableViewCell {
    // MARK: - 控件属性
    /// 用户头像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 用户昵称
    @IBOutlet weak var userName: UILabel!
    
    /// 会员等级图标
    @IBOutlet weak var mbrankImageView: UIImageView!
    
    /// 发布时间
    @IBOutlet weak var createdAtLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 正文
    @IBOutlet weak var contentLabel: HYLabel!
    /// 微博配图
    @IBOutlet weak var picView: PicCollectionView!
    /// 转发内容
    @IBOutlet weak var retweetedContentLabel: HYLabel!
    /// 底部工具条
    @IBOutlet weak var bottomToolView: UIView!
    // 转发微博背景图
    @IBOutlet weak var retweetedBgView: UIView!
    
    
    // MARK: - 约束属性
    @IBOutlet weak var contentLabelWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var pivViewTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    
    // MARK: - 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            avatarImageView.sd_setImageWithURL(viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            verifiedImageView.image = viewModel.verifiedImage
            
            userName.text = viewModel.status?.user?.screen_name
            userName.textColor = viewModel.rankImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
            
            mbrankImageView.image = viewModel.rankImage
            
            createdAtLabel.text = viewModel.createdAtText
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 " + sourceText
            } else {
                sourceLabel.text = nil
            }
            
            contentLabel.attributedText = FindEmoticon.shareInstance.findEmoticonAttrString(viewModel.status?.text, font: contentLabel.font)
            
            let picViewSize = calculatePicViewSize(viewModel.picURLs.count)
            picViewWidthCons.constant = picViewSize.width
            picViewHeightCons.constant = picViewSize.height
            
            picView.picURLs = viewModel.picURLs
            // 设置转发正文
            if viewModel.status?.retweeted_status != nil {
                if let retweetedContent = viewModel.status?.retweeted_status?.text,
                    let retweetedScreenName = viewModel.status?.retweeted_status?.user?.screen_name {
                    let retweetedStatus = "@" + "\(retweetedScreenName)" + ": " + retweetedContent
                    retweetedContentLabel.attributedText = FindEmoticon.shareInstance.findEmoticonAttrString(retweetedStatus, font: retweetedContentLabel.font)
                }
                retweetedBgView.hidden = false
                
                retweetedContentLabelTopCons.constant = 15
            } else {
                retweetedContentLabel.text = nil
                
                retweetedBgView.hidden = true
                
                retweetedContentLabelTopCons.constant = 0
            }
            // 设置cell高度
            if viewModel.cellHeight == 0 {
                layoutIfNeeded()
                
                viewModel.cellHeight = CGRectGetMaxY(bottomToolView.frame)
            }
        }
    }
    
    // MARK: - 系统方法
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabelWidthCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        
        // 监听@谁谁谁的点击
        contentLabel.userTapHandler = { (label, user, range) in
            print(label)
            print(user)
            print(range)
        }
        
        // 监听链接的点击
        contentLabel.linkTapHandler = { (label, link, range) in
            print(label)
            print(link)
            print(range)
        }
        
        // 监听话题的点击
        contentLabel.topicTapHandler = { (label, topic, range) in
            print(label)
            print(topic)
            print(range)
        }
        
        // 监听@谁谁谁的点击
        retweetedContentLabel.userTapHandler = { (label, user, range) in
            print(label)
            print(user)
            print(range)
        }
        
        // 监听链接的点击
        retweetedContentLabel.linkTapHandler = { (label, link, range) in
            print(label)
            print(link)
            print(range)
        }
        
        // 监听话题的点击
        retweetedContentLabel.topicTapHandler = { (label, topic, range) in
            print(label)
            print(topic)
            print(range)
        }
    }
}
// MARK: - 计算方法
extension HomeViewCell {
    private func calculatePicViewSize(count : Int) -> CGSize {
        if count == 0 {
            pivViewTopCons.constant = 0
            return CGSizeZero
        }
        
        pivViewTopCons.constant = 10
        
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        // 设置单张图片
        if count == 1 {
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(viewModel?.picURLs.first?.absoluteString)
            layout.itemSize = CGSizeMake(image.size.width * 2, image.size.height * 2)
            return CGSizeMake(image.size.width * 2, image.size.height * 2)
        }
        
        // 计算单个imageViewWH大小
        let imageViewWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSizeMake(imageViewWH, imageViewWH)
        
        if count == 4 {
            let picViewWH =  2 * imageViewWH + itemMargin + 1
            return CGSizeMake(picViewWH, picViewWH)
        }
        
        let rows = CGFloat((count - 1) / 3 + 1)
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        let picViewW = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        return CGSizeMake(picViewW, picViewH)
    }
}
