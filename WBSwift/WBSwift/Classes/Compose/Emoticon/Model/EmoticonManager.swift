//
//  EmoticonManager.swift
//  Keyboard
//
//  Created by Kevin on 2016/12/5.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class EmoticonManager {
    var emoticonPackages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        emoticonPackages.append(EmoticonPackage(id: ""))
        emoticonPackages.append(EmoticonPackage(id: "com.sina.default"))
        emoticonPackages.append(EmoticonPackage(id: "com.apple.emoji"))
        emoticonPackages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}
