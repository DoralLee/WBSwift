//
//  PhotoBrwoserViewController.swift
//  WBSwift
//
//  Created by Kevin on 2016/12/7.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

let kPhotoBrowserCollectionCellID = "kPhotoBrowserCollectionCellID"

class PhotoBrwoserViewController: BaseViewController {

    var indexPath : NSIndexPath
    var picUrls : [NSURL]
    
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PhotoBrowserFlowLayout())
    private lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "关 闭")
    private lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGrayColor(), fontSize: 14, title: "保 存")
    
    init(indexPath: NSIndexPath, picUrls : [NSURL]) {
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }

}
// MARK: - 设置UI
extension PhotoBrwoserViewController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.registerClass(PhotoBrwoserCollectionViewCell.self, forCellWithReuseIdentifier: kPhotoBrowserCollectionCellID)
        
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSizeMake(90, 32))
        }
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn)
            make.size.equalTo(closeBtn)
        }
        
        closeBtn.addTarget(self, action: #selector(PhotoBrwoserViewController.closeBtnClick), forControlEvents: .TouchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrwoserViewController.saveBtnClick), forControlEvents: .TouchUpInside)
    }
}
// MARK: - 事件监听
extension PhotoBrwoserViewController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func saveBtnClick() {
        let cell = collectionView.visibleCells().first as! PhotoBrwoserCollectionViewCell
        guard let image = cell.image else {
            return
        }
        //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrwoserViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:AnyObject) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfoWithStatus(showInfo)
    }
}
// MARK: - collection view delegate and data source
extension PhotoBrwoserViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPhotoBrowserCollectionCellID, forIndexPath: indexPath) as! PhotoBrwoserCollectionViewCell
        cell.picUrl = picUrls[indexPath.item]
        cell.tapCallBack = {[weak self] in
            self?.closeBtnClick()
        }
        
        return cell
    }
}

extension PhotoBrwoserViewController : PhotoBrowserAnimationDismissDelegate {
    func dismissViewOfIndexPath() -> NSIndexPath {
        let cell = collectionView.visibleCells().first!
        return collectionView.indexPathForCell(cell)!
    }
    func dismissViewOfImageView() -> UIImageView {
        let cell = collectionView.visibleCells().first as! PhotoBrwoserCollectionViewCell
        let image = cell.image
        
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.image = image
        imageView.frame = cell.imageFrame
        
        return imageView
    }
}

private class PhotoBrowserFlowLayout : UICollectionViewFlowLayout {
    private override func prepareLayout() {
        super.prepareLayout()
        
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
