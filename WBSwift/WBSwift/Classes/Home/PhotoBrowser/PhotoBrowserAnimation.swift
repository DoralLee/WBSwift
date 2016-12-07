//
//  PhotoBrowserAnimation.swift
//  WBSwift
//
//  Created by Kevin on 2016/12/7.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

protocol PhotoBrowserAnimationPresentDelegate: NSObjectProtocol {
    func startPresentedFrame(indexPath:NSIndexPath) -> CGRect
    func endPrestendFrame(indexPath:NSIndexPath) -> CGRect
    func imageViewPresented(indexPath:NSIndexPath) -> UIImageView
}

protocol PhotoBrowserAnimationDismissDelegate: NSObjectProtocol {
    func dismissViewOfIndexPath() -> NSIndexPath
    func dismissViewOfImageView() -> UIImageView
}

class PhotoBrowserAnimation: NSObject {
    private var isPresent : Bool = false
    var presentedDelegate : PhotoBrowserAnimationPresentDelegate?
    var dismissDelegate : PhotoBrowserAnimationDismissDelegate?
    var indexPath : NSIndexPath?
    
}

extension PhotoBrowserAnimation : UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension PhotoBrowserAnimation : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresent ? animationForPresent(transitionContext) : animationForDismiss(transitionContext)
    }
    
    func animationForPresent(transitionContext : UIViewControllerContextTransitioning)  {
        guard let presentedDelegate = presentedDelegate, indexPath = indexPath else {
            return
        }
        let presentView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        presentView.alpha = 0.0
        
        transitionContext.containerView()?.addSubview(presentView)
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        
        let startFrame = presentedDelegate.startPresentedFrame(indexPath)
        let endFrame = presentedDelegate.endPrestendFrame(indexPath)
        let imageView = presentedDelegate.imageViewPresented(indexPath)
        transitionContext.containerView()?.addSubview(imageView)
        imageView.frame = startFrame
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
            imageView.frame = endFrame
            }) { (_) in
                imageView.removeFromSuperview()
                presentView.alpha = 1.0
                transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                transitionContext.completeTransition(true)
        }
    }
    
    func animationForDismiss(transitionContext : UIViewControllerContextTransitioning) {
        guard let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            return
        }
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        
        dismissView.removeFromSuperview()
        
        let indexPath = dismissDelegate.dismissViewOfIndexPath()
        let imageView = dismissDelegate.dismissViewOfImageView()
        transitionContext.containerView()?.addSubview(imageView)
        let endFrame = presentedDelegate.startPresentedFrame(indexPath)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
            imageView.frame = endFrame
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }

}