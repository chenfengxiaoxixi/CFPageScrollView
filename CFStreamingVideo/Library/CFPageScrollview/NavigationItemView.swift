//
//  NavigationItemView.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/21.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

@objc protocol NavigationItemViewDataSource {
    
    func getNavigationItemTitles() -> Array<Any>
}

@objc protocol NavigationItemViewDelegate {
    
    func itemView(_ itemView: NavigationItemView, didSelectAt Index: Int)
}

class NavigationItemView: UICollectionView {

    var titles: Array<Any>!
    var titleWidths: Array<CGFloat>!
    var titleCentersX: Array<CGFloat>!
    var bottomPoint: UIView!
    var selectIndex: Int!//当前选中对象
    var deselectIndex: Int!//上一选中对象
    
    var norTextColor: UIColor!
    var selTextColor: UIColor!
    
    weak open var itemViewDelegate: NavigationItemViewDelegate?

    weak open var itemViewDataSource: NavigationItemViewDataSource? {
        //外部设置完之后调用这个方法
        didSet { self.setDataSource() }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        //底部移动点
        bottomPoint = UIView.init(frame: CGRect(x: 0, y: 50, width: 5, height: 5))
        bottomPoint.layer.cornerRadius = 2.5
        bottomPoint.isHidden = true
        addSubview(bottomPoint)
        
        selectIndex = 0;
        deselectIndex = -1;
        titleCentersX = Array()
        
        backgroundColor = UIColor.clear
        delegate = self
        dataSource = self
        register(NavigationItemViewCell.classForCoder(), forCellWithReuseIdentifier: "CollectionCell")
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadNavItemData() {
        
        selectIndex = 0;
        deselectIndex = -1;
        
        titles = itemViewDataSource?.getNavigationItemTitles()
        
        if titles == nil || titles.count == 0 {
            return
        }
        
        let width: CGFloat = titleWidths[0]
        
        bottomPoint.backgroundColor = selTextColor
        bottomPoint.mj_x = width/2 - 4
        bottomPoint.isHidden = false
        
        reloadData()
        
        setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func setDataSource() {
        
        titles = itemViewDataSource?.getNavigationItemTitles()
        
        if titles == nil || titles.count == 0 {
            return
        }
        
        let width: CGFloat = titleWidths[0]
        
        bottomPoint.backgroundColor = selTextColor
        bottomPoint.mj_x = width/2 - 4
        bottomPoint.isHidden = false
    }
    
    func selectItemWith(index: Int) {
        
        if selectIndex == index {
            return
        }
        
        deselectIndex = selectIndex
        selectIndex = index
        
        reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.scrollToMidScreen(index: index)
        }
    }
    
    func scrollToMidScreen(index: Int) {
        
        if contentSize.width <= mj_w {
            return
        }
        
        //cell的中点坐标
        var cellCenterX = titleCentersX[index]
        // 计算出cell相对于view的坐标，用于滚动到中心
        cellCenterX = cellCenterX - mj_offsetX
//        print("x=\(rect.origin.x)")
        let offset = SCREEN_WIDTH/2 - cellCenterX
        //点击的cell在左边时,用中心点判断
        if cellCenterX < SCREEN_WIDTH/2 {
            if mj_offsetX > offset
            {
                self.setContentOffset(CGPoint(x: mj_offsetX - offset, y: 0), animated: true)
            }
            else
            {   //超出范围时，偏移到左边底部
                self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            
        }
        else
        {
            if mj_offsetX + abs(offset) < mj_contentW - mj_w
            {
                self.setContentOffset(CGPoint(x: mj_offsetX + abs(offset), y: 0), animated: true)
            }
            else
            {   //超出范围时，偏移到右边底部
                self.setContentOffset(CGPoint(x: mj_contentW - mj_w, y: 0), animated: true)
            }
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// MARK: - UICollectionViewDelegate
extension NavigationItemView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectIndex == indexPath.row {
            return
        }
        
        deselectIndex = selectIndex
        selectIndex = indexPath.row
        
        itemViewDelegate?.itemView(self, didSelectAt: indexPath.row)
        
        UIView.animate(withDuration: 0.25) {
            self.bottomPoint.center.x = self.titleCentersX[indexPath.row]
        }
        
        reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollToMidScreen(index: indexPath.row)
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension NavigationItemView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCellIden = "CollectionCell";
        
        let cell: NavigationItemViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIden, for: indexPath) as? NavigationItemViewCell
        
        cell.titleStr.text = titles[indexPath.row] as? String;
        cell.titleStr.mj_w = cell.mj_w
        cell.titleStr.textColor = norTextColor
        
        if selectIndex == indexPath.row {
            cell.titleStr.textColor = selTextColor
            cell.titleStr.enlarge()
        }
        else if deselectIndex == indexPath.row
        {
            cell.titleStr.textColor = norTextColor
            cell.titleStr.recovery()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension NavigationItemView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: titleWidths[indexPath.row], height: mj_h)
    }
}


