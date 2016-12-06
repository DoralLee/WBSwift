//
//  EmoticonPackage.swift
//  Keyboard
//
//  Created by Kevin on 2016/12/5.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class EmoticonPackage {
    var emoticons : [Emoticon] = [Emoticon]()
    
    init(id: String) {
        if id == "" {
            addEmptyEmoticon(true)
            return
        }
        let path = NSBundle.mainBundle().pathForResource("\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        let array = NSArray(contentsOfFile: path!) as! [[String:String]]
        var index : Int = 0
        for var emoticon in array {
            if let png = emoticon["png"] {
                emoticon["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict: emoticon))
            index += 1
            if index == 20 {
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        addEmptyEmoticon(false)
    }
    
    private func addEmptyEmoticon(isRecently:Bool) {
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        emoticons.append(Emoticon(isRemove: true))
    }
}
