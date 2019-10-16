//
//  EditMenuController.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/12.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class EditMenuController: UIViewController {

    var cancelButton: UIButton!
    var editButton: UIButton!
    var backgroundView: UIView!
    var groupDataArray: Array<Array<PageDataModel>>!//分组数据
    var sectionTitleArray: Array<String>!//分组title
    
    let ratio: CGFloat = 0.85
    
    var collectionView: UICollectionView!
    
    var isEnterEditing: Bool!
    
    var finishEditingWithData: ((Array<PageDataModel>) ->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .clear

        isEnterEditing = false
        
        cancelButton = UIButton(type: .custom);
        cancelButton.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        cancelButton.addTarget(self, action: #selector(hiddenMenu), for: .touchUpInside)
        cancelButton.backgroundColor = .black
        cancelButton.alpha = 0
        cancelButton.setTitleColor(.white, for: .normal)
        view.addSubview(cancelButton)
        
        backgroundView = UIView.init(frame: CGRect(x: -SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH * ratio, height: SCREEN_HEIGHT))
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
        
        let navHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH * ratio, height: STATUS_AND_NAV_BAR_HEIGHT + 10))
        navHeaderView.backgroundColor = .white
        backgroundView.addSubview(navHeaderView)
        
        let label = UILabel.init(frame: CGRect(x: navHeaderView.mj_w/2 - 20, y: STATUSBAR_HEIGHT + 10, width: 40, height: 20))
        label.text = "频道"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .darkText
        navHeaderView.addSubview(label)
        
        editButton = UIButton(type: .custom);
        editButton.frame = CGRect(x: navHeaderView.mj_w - 60, y: STATUSBAR_HEIGHT + 10, width: 40, height: 30)
        editButton.setTitle("管理", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        editButton.setTitleColor(.black, for: .normal)
        editButton.addTarget(self, action: #selector(enterEditing), for: .touchUpInside)
        navHeaderView.addSubview(editButton)
        
        let layout = UICollectionViewFlowLayout.init()
        
        collectionView = UICollectionView.init(frame: CGRect(x: 0, y: navHeaderView.frame.maxY, width: SCREEN_WIDTH * ratio, height: SCREEN_HEIGHT - navHeaderView.mj_h), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        backgroundView.addSubview(collectionView)
        
        collectionView.register(EditMenuCell.classForCoder(), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.register(EditMenuHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        //去掉顶部偏移
        if #available(iOS 11.0, *){
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    
    }
    
    @objc func enterEditing() {
        
        isEnterEditing = !isEnterEditing
        
        editButton.setTitle(isEnterEditing ? "完成" : "管理", for: .normal)
        
        collectionView.reloadData()
        
        if !isEnterEditing {
            //第一组数据始终为编辑完成数据
            finishEditingWithData(groupDataArray[0])
        }
    }
    
    @objc func deleteOrAdd(sender: MenuButton) {
        
        var model = groupDataArray[sender.indexPath.section][sender.indexPath.row]
        
        //删除可编辑栏目
        if sender.indexPath.section == 0 {

            //添加标签，判断执行后，直接结束循环
            loopA: for i in 1..<groupDataArray.count {
                let array = groupDataArray[i]
                for j in 0..<array.count {
                    let item = array[j]
                    if item.title == model.title {
                        groupDataArray[i][j].isNeedToDisplay = false
                        
                        break loopA
                    }
                }
                print("das")
            }
            
            collectionView.performBatchUpdates({

                groupDataArray[sender.indexPath.section].remove(at: sender.indexPath.row)
                collectionView.deleteItems(at: [sender.indexPath])

            }) { (bool) in
                
                self.collectionView.reloadData()
            }

        }
        //增加可编辑栏目
        else
        {
            model.isNeedToDisplay = true
            groupDataArray[sender.indexPath.section][sender.indexPath.row].isNeedToDisplay = true
            
            collectionView.performBatchUpdates({
                
                groupDataArray[0].append(model)
                collectionView.insertItems(at: [IndexPath.init(row: groupDataArray[0].count - 1, section: 0)])
                
            }) { (bool) in
                
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func hiddenMenu() {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.cancelButton.alpha = 0
            self.backgroundView.mj_x = -SCREEN_WIDTH
            
        }) { (comple) in
            self.view.isHidden = true
        }
    }
    
    func displayMenu() {
       
        self.view.isHidden = false
        
        UIView.animate(withDuration: 0.25) {
            self.cancelButton.alpha = 0.5
            self.backgroundView.mj_x = 0
        }
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
extension EditMenuController: UICollectionViewDataSource {
    
    // MARK: - UICollectionView Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return groupDataArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCellIden = "CollectionCell";
        
        let cell: EditMenuCell! = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIden, for: indexPath) as? EditMenuCell
        
        cell.backgroundColor = ThemeBlueColor
        
        cell.editButton.isHidden = true
        cell.editButton.setTitle("", for: .normal)
        cell.editButton.indexPath = indexPath
        let model = groupDataArray[indexPath.section][indexPath.row]
        
        if model.isAllowedEditing ?? false && isEnterEditing {
            
            cell.editButton.isHidden = false
            cell.editButton.addTarget(self, action: #selector(deleteOrAdd(sender: )), for: .touchUpInside)
            
            if model.isNeedToDisplay ?? false {
                
                cell.editButton.setTitleColor(.red, for: .normal)
                cell.editButton.isUserInteractionEnabled = true
                cell.editButton.setTitle("-", for: .normal)
                
                if indexPath.section > 0 {
                    cell.editButton.isUserInteractionEnabled = false
                    cell.editButton.setTitle("+", for: .normal)
                    cell.editButton.setTitleColor(.lightGray, for: .normal)
                }
                
            }
            else
            {
                cell.editButton.isUserInteractionEnabled = true
                cell.editButton.setTitleColor(.red, for: .normal)
                cell.editButton.setTitle("+", for: .normal)
            }
        }
        
        cell.titleStr.text = model.title;
        
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview : UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView: EditMenuHeader! = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as? EditMenuHeader
            reusableview = headerView;
            
            headerView.title.text = sectionTitleArray[indexPath.section]
        }
        
        return reusableview;
    }
    
}

// MARK: - UICollectionViewDataSource
extension EditMenuController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension EditMenuController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.mj_w, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count:CGFloat = 3
        return CGSize(width: (collectionView.mj_w - 50)/count, height: (collectionView.mj_w - 50)/count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == groupDataArray.count - 1 {
            return UIEdgeInsets(top: 10, left: 15, bottom: TABBAR_HEIGHT, right: 15);
            
        }
        
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15);
    }
    
}
