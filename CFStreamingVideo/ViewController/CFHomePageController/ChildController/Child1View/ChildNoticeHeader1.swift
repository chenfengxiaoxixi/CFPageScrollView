//
//  ChildNoticeHeader1.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/6.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class ChildNoticeHeader1: UICollectionReusableView {
    
    var arr1: Array<Any>!
    var noticeView : GYRollingNoticeView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel.init(frame: CGRect(x: 15, y: 0, width: 70, height: 50))
        label.textColor = RGB(r: 250.0, g: 48.0, b: 115.0, a: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "酷头条"
        addSubview(label)
        
        noticeView = GYRollingNoticeView.init(frame: CGRect(x: label.frame.maxX, y: 0, width: mj_w - 30 - 70, height: 50))
        noticeView.dataSource = self
        noticeView.delegate = self
        addSubview(noticeView)
        
        arr1 = ["怎样练出8块腹肌？",
                "怎样在赛季末打上王者？",
                "为什么30了还是单身？"
        ];
        
        noticeView.register(ADNoticeViewCell.classForCoder(), forCellReuseIdentifier: "ADNoticeViewCell")
        
        noticeView.reloadDataAndStartRoll()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChildNoticeHeader1: GYRollingNoticeViewDataSource {
    
    func numberOfRows(for rollingView: GYRollingNoticeView!) -> Int {
        return arr1.count
    }
    
    func rollingNoticeView(_ rollingView: GYRollingNoticeView!, cellAt index: UInt) -> GYNoticeViewCell! {
        // 普通用法，只有一行label滚动显示文字
        // normal use, only one line label rolling
        
        let cell = rollingView.dequeueReusableCell(withIdentifier: "ADNoticeViewCell")
        cell?.textLabel.text = String(format: "%@%@","",arr1?[Int(index)] as! CVarArg)
        cell?.textLabel.font = UIFont.systemFont(ofSize: 16)
        cell?.textLabel.textColor = UIColor.darkText
        cell?.contentView.backgroundColor = UIColor.white
            
        return cell;

    }
    
}

extension ChildNoticeHeader1: GYRollingNoticeViewDelegate {
    
    func didClick(_ rollingView: GYRollingNoticeView!, for index: UInt) {
        
        print("点击的index: \(index)")
        
    }
    
}
