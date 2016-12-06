//
//  ComposeViewController.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/30.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    // MARK: - 控件属性
    @IBOutlet weak var composeTextVIew: ComposeTextView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    // MARK: - 自定义属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    private lazy var images : [UIImage] = [UIImage]()
    private var isSelectedImage : Bool = false
    private lazy var emoticonVC :EmoticonController = EmoticonController {[weak self] (emoticon) in
        self?.composeTextVIew.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.composeTextVIew)
    }
    
    // MARK: - 约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var picPickerViewHeightCons: NSLayoutConstraint!
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNotifaction()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard !isSelectedImage else {
            return
        }
        composeTextVIew.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        composeTextVIew.resignFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - 设置UI
extension ComposeViewController {
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(ComposeViewController.leftBarButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .Plain, target: self, action: #selector(ComposeViewController.composeButtonClick))
        navigationItem.rightBarButtonItem?.enabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 44)
        navigationItem.titleView = titleView
    }
    private func setupNotifaction() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.addPicNotification), name: PicPickerCellAddPicKey, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.removePicNotification(_:)), name: PicPickerCellRemovePicKey, object: nil)

    }
}

// MARK: - 事件监听
extension ComposeViewController {
    @objc private func leftBarButtonClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func composeButtonClick() {
        print("composeButtonClick")
    }
    
    @objc private func keyboardWillChangeFrame(noti : NSNotification) {
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let endFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = endFrame.origin.y
        let bottomConstant = UIScreen.mainScreen().bounds.height - y
        
        self.toolBarBottomCons.constant = bottomConstant
        UIView.animateWithDuration(duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick() {
        composeTextVIew.resignFirstResponder()
        picPickerViewHeightCons.constant = UIScreen.mainScreen().bounds.height * 0.65
        UIView.animateWithDuration(0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func emoticonBtnClick() {
        // 1. 先取消第一响应
        composeTextVIew.resignFirstResponder()
        // 2. 切换键盘
        composeTextVIew.inputView = composeTextVIew.inputView != nil ? nil : emoticonVC.view
        // 3. 成为第一响应
        composeTextVIew.becomeFirstResponder()
    }
    
    @objc private func addPicNotification() {
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        let ipc = UIImagePickerController()
        ipc.delegate = self
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    @objc private func removePicNotification(noti:NSNotification) {
        guard let image = noti.object as? UIImage else {
            return
        }
        guard let index = images.indexOf(image) else {
            return
        }
        images.removeAtIndex(index)
        picPickerCollectionView.images = images
    }
}

// MARK: - text view delegate
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        composeTextVIew.isHiddenPlaceholder = composeTextVIew.hasText()
        navigationItem.rightBarButtonItem?.enabled = composeTextVIew.hasText()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        composeTextVIew.resignFirstResponder()
    }
}

// MARK: - image picker delegate 
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        images.append(image)
        picPickerCollectionView.images = images
        isSelectedImage = true
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        isSelectedImage = false
    }
}