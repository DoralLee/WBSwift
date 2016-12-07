//
//  PicViewCell.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/29.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SDWebImage

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

extension PicCollectionView : PhotoBrowserAnimationPresentDelegate {
    func startPresentedFrame(indexPath: NSIndexPath) -> CGRect {
        let cell = cellForItemAtIndexPath(indexPath) as! PicViewCell
        let frame = convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        return frame
    }
    func endPrestendFrame(indexPath: NSIndexPath) -> CGRect {
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        let w = UIScreen.mainScreen().bounds.width
        let h = w / image.size.width * image.size.height
        var y :CGFloat = 0
        if h > UIScreen.mainScreen().bounds.height {
            y = 0
        } else {
            y = (UIScreen.mainScreen().bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    func imageViewPresented(indexPath: NSIndexPath) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picURL.absoluteString)
        imageView.image = image
        
        return imageView
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
        NSNotificationCenter.defaultCenter().postNotificationName(PhotoBrowserDidSelectedCellKey, object: self, userInfo: info)
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