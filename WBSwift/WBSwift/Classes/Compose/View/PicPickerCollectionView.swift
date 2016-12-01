//
//  PicPickerCollectionView.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/30.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

private let kPickerCellID = "kPickerCellID"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {
    
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        dataSource = self
        registerNib(UINib.init(nibName: "PicPickerCell", bundle: nil), forCellWithReuseIdentifier: kPickerCellID)
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.mainScreen().bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSizeMake(itemWH, itemWH)
    }
}

extension PicPickerCollectionView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPickerCellID, forIndexPath: indexPath) as! PicPickerCell
        cell.image = indexPath.item <= (images.count - 1) ? images[indexPath.item] : nil
        return cell
    }
}
