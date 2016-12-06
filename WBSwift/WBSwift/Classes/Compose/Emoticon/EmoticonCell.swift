//
//  EmoticonCell.swift
//  Keyboard
//
//  Created by Kevin on 2016/12/5.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
    var emotion : Emoticon? {
        didSet {
            guard let emoticon = emotion else {
                return
            }
            emoticonBtn.setImage(UIImage.init(contentsOfFile: emoticon.pngPath ?? ""), forState: .Normal)
            emoticonBtn.setTitle(emoticon.codeEmoji, forState: .Normal)
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
            }
        }
    }
    
    private lazy var emoticonBtn : UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
}

extension EmoticonCell {
    private func setupUI() {
        addSubview(emoticonBtn)
        
        emoticonBtn.frame = contentView.bounds
        
        emoticonBtn.userInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
    }
}