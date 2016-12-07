//
//  PhotoBrwoserViewController.swift
//  WBSwift
//
//  Created by Kevin on 2016/12/7.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SnapKit

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
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn)
            make.size.equalTo(closeBtn)
        }
        
        closeBtn.addTarget(self, action: #selector(PhotoBrwoserViewController.closeBtnClick), forControlEvents: .TouchUpInside)
    }
}

extension PhotoBrwoserViewController {
    @objc private func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
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
