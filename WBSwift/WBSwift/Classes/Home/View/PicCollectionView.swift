//
//  PicViewCell.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/29.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {
    
    var picURLs : [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    // MARK: - 系统方法
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
}


// MARK: - collectionview data source and delegate
extension PicCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picViewCellID", forIndexPath: indexPath) as! PicViewCell
        cell.picURL = picURLs[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let info = [PhotoBrowserIndexPathkey:indexPath, PhotoBrowserPicUrlsKey:picURLs]
        NSNotificationCenter.defaultCenter().postNotificationName(PhotoBrowserDidSelectedCellKey, object: nil, userInfo: info)
    }
}

// MARK: - 自定义cell
class PicViewCell : UICollectionViewCell {
    // MARK: - 属性
    var picURL : NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            picImageView.sd_setImageWithURL(picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    @IBOutlet weak var picImageView: UIImageView!
}