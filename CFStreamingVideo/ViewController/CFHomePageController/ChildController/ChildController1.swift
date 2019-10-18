//
//  ChildController1.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/28.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class ChildController1: CFBaseController {

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setUI()
        
    }
    
    func setUI() {
        
        let layout = UICollectionViewFlowLayout.init()
        
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: view.mj_w, height: view.mj_h - TABBAR_HEIGHT - navItemViewHeight - searchViewHeight - (STATUS_AND_NAV_BAR_HEIGHT - 40)), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChildCell1.classForCoder(), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.register(ChildCircleHeader1.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(ChildNoticeHeader1.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header2")
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        //去掉顶部偏移
        if #available(iOS 11.0, *){
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        
        view.bringSubviewToFront(self.headFillView)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UICollectionViewDataSource
extension ChildController1: UICollectionViewDataSource {
    
    // MARK: - UICollectionView Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCellIden = "CollectionCell";

        let cell: ChildCell1! = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIden, for: indexPath) as? ChildCell1
        
        cell.backgroundColor = ThemeBlueColor
        
        cell.titleStr.text = "测试";
        
        let imageName = String(format: "%@%d","commodity_",indexPath.row + 1)
        
        cell.imageView.image = UIImage(named: imageName);
        
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview : UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 0 {
            
            let headerView: ChildCircleHeader1! = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? ChildCircleHeader1
            reusableview = headerView;
        }
        else if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1{
            
            let headerView: ChildNoticeHeader1! = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header2", for: indexPath) as? ChildNoticeHeader1
            
            reusableview = headerView;
        }
        
        return reusableview;
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension ChildController1: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let vc = DetailController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ChildController1: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: collectionView.mj_w, height: collectionView.mj_w/16*7)
        }
        
        return CGSize(width: collectionView.mj_w, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count:CGFloat = 2
        return CGSize(width: (collectionView.mj_w - 40)/count, height: (collectionView.mj_w - 40)/count - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        
        return UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15);
    }
    
}

