//
//  WelcomeViewController.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/28.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: BaseViewController {
    // MARK: - 属性
    @IBOutlet weak var avatarImageBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        let avatarString = UserAccountViewModel.shareInstance.account?.avatar_large
        avatarImageView.sd_setImageWithURL(NSURL(string: avatarString ?? ""), placeholderImage: UIImage(named: "avatar_default_big"))
        
        avatarImageBottomCons.constant = UIScreen.mainScreen().bounds.size.height - 220
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: [], animations: {
                self.view.layoutIfNeeded()
            }) { (isFinish) in
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

}
