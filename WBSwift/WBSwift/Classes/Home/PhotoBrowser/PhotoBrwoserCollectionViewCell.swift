//
//  PhotoBrwoserCollectionViewCell.swift
//  WBSwift
//
//  Created by Kevin on 2016/12/7.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrwoserCollectionViewCell: UICollectionViewCell {
    var picUrl : NSURL? {
        didSet {
            guard let picUrl = picUrl else {
                return
            }
            setupContent(picUrl)
        }
    }
    var image :UIImage?
    var imageFrame:CGRect = CGRectZero
    
    
    var tapCallBack : (() -> ())?
    
    private var scrollView : UIScrollView = UIScrollView()
    private var imageView : UIImageView = UIImageView()
    private var progressView : ProgressView = ProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrwoserCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)

        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        
        progressView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = contentView.center
        progressView.backgroundColor = UIColor.clearColor()
        progressView.hidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoBrwoserCollectionViewCell.imageViewTapClick))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupContent(picUrl : NSURL) {
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(picUrl.absoluteString)
        let imageViewW = UIScreen.mainScreen().bounds.width
        let imageViewH = imageViewW / image.size.width * image.size.height
        var imageViewY : CGFloat = 0
        
        if imageViewH > UIScreen.mainScreen().bounds.height {
            imageViewY = 0
        } else {
            imageViewY = (UIScreen.mainScreen().bounds.height - imageViewH) * 0.5
        }
        
        imageView.frame = CGRect(x: 0, y: imageViewY, width: imageViewW, height: imageViewH)
        progressView.hidden = false
        imageView.sd_setImageWithURL(getBigImageUrl(picUrl), placeholderImage: image, options: [], progress: { (current, total) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
            }) { (_, _, _, _) in
                self.progressView.hidden = true
        }
        self.image = imageView.image
        self.imageFrame = imageView.frame
        scrollView.contentSize = CGSize(width: 0, height: imageViewH)
    }
    
    private func getBigImageUrl(smallUrl : NSURL) -> NSURL {
        let smallURLString = smallUrl.absoluteString
        let bigURLString = smallURLString.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        return NSURL(string: bigURLString)!
    }
}

extension PhotoBrwoserCollectionViewCell {
    @objc private func imageViewTapClick() {
        if let tapCallBack = tapCallBack {
            tapCallBack()
        }
    }
}
