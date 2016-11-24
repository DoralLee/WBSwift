//
//  PopoverAnimator.swift
//  WBSwift
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    var isPresented : Bool = false
    var presentedFrame : CGRect = CGRectZero
    var callBack : ((presented : Bool) -> ())?
    
    override init() {
        
    }
    
    init(callBack:(presented:Bool) -> ()) {
        self.callBack = callBack
    }
}
// MARK：- 转场动画代理
extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(presented:isPresented)
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(presented:isPresented)
        return self
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentController = LYPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentController.presentedFrame = presentedFrame
        return presentController
    }
}

extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // UITransitionContextFromViewKey, and UITransitionContextToViewKey
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    // 自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        //1. 获取弹出的view
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        // 2. 将弹出的view添加到containerView中
        transitionContext.containerView()?.addSubview(presentedView)
        
        // 3. 执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0.0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            presentedView.transform = CGAffineTransformIdentity
        }) { (isFinshed) in
            transitionContext.completeTransition(true)
        }
    }
    
    // 自定义消失动画
    private func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
        }) { (_) in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
}