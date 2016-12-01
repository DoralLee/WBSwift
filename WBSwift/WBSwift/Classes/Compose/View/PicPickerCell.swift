//
//  PicPickerCell.swift
//  WBSwift
//
//  Created by Kevin on 2016/11/30.
//  Copyright © 2016年 kevin. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {
    // MARK: - 控件属性
    @IBOutlet weak var composePicAdd: UIButton!
    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    // MARK: - 自定义属性
    var image : UIImage? {
        didSet {
            if image != nil {
                displayImageView.image = image
                deleteBtn.hidden = false
                composePicAdd.userInteractionEnabled = false
            } else {
                displayImageView.image = nil
                deleteBtn.hidden = true
                composePicAdd.userInteractionEnabled = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func composePicAddBtnClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerCellAddPicKey, object: nil)
    }


    @IBAction func deleteBtnClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerCellRemovePicKey, object: image)
    }
}
