//
//  EmoticonController.swift
//  Keyboard
//
//  Created by Kevin on 2016/12/5.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

private let kEmoticonCellID = "emoticonCellID"

class EmoticonController: UIViewController {
    // MARK: - 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonCollectionViewLayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    // MARK: - 属性
    private let toolBarTitles : [String] = ["最近", "默认", "emoji", "浪小花"]
    var emoticonManger : EmoticonManager = EmoticonManager()
    var emoticonCallBack : (emoticon:Emoticon) -> ()
    
    // MARK: - 自定义构造函数
    init(emoticonCallBack:(emoticon : Emoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - 设置UI
extension EmoticonController {
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["collectionView":collectionView, "toolBar":toolBar]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
    
        prepareForCollectionView()
        
        prepareForToolBar(toolBarTitles)
    }
    
    private func prepareForCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: kEmoticonCellID)
    }
    
    private func prepareForToolBar(titles : [String]) {
        var items = [UIBarButtonItem]()
        for (index ,title) in titles.enumerate() {
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(EmoticonController.toolBarBtnClick(_:)))
            item.tag = index
            
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
        toolBar.tintColor = UIColor.orangeColor()
    }
}

extension EmoticonController {
    @objc private func toolBarBtnClick(btn:UIBarButtonItem) {
        let tag = btn.tag
        let indexPath = NSIndexPath(forItem: 0, inSection: tag)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
}

// MARK: - collection view delegate and data source
extension EmoticonController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emoticonManger.emoticonPackages.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoticonManger.emoticonPackages[section].emoticons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kEmoticonCellID, forIndexPath: indexPath) as! EmoticonCell
        cell.emotion = emoticonManger.emoticonPackages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let emoticon = emoticonManger.emoticonPackages[indexPath.section].emoticons[indexPath.item]
        insertRecentlyEmoticon(emoticon)
        emoticonCallBack(emoticon: emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon: Emoticon) {
        if emoticon.isEmpty || emoticon.isRemove {
            return
        }
        let recentlyEmotions = emoticonManger.emoticonPackages.first!.emoticons
        if recentlyEmotions.contains(emoticon) {
            let index = recentlyEmotions.indexOf(emoticon)
            emoticonManger.emoticonPackages.first?.emoticons.removeAtIndex(index!)
        } else {
            emoticonManger.emoticonPackages.first?.emoticons.removeAtIndex(19)
        }
        
        emoticonManger.emoticonPackages.first?.emoticons.insert(emoticon, atIndex: 0)
    }
}

// MARK: - collection view flow layout
private class EmoticonCollectionViewLayout : UICollectionViewFlowLayout {
    private override func prepareLayout() {
        super.prepareLayout()
        
        let itemWH = UIScreen.mainScreen().bounds.width / 7
        itemSize = CGSizeMake(itemWH, itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        // 也可以不设置，没太大影响
        let edgeMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsetsMake(edgeMargin, 0, edgeMargin, 0)
    }
}
