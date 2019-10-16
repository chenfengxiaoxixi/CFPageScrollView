//
//  SearchView3.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/5.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class SearchView3: BaseSearchView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: 15, y: 5, width: SCREEN_WIDTH - 30 - 160, height: 50 - 16)
        //        searchButton.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        //searchButton.setImage(UIImage(named: "delete"), for: .normal)
        searchButton.backgroundColor = RGB(r: 216.0, g: 218.0, b: 226.0, a: 1.0)
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 17;
        searchButton.setTitle("天行九歌", for: .normal)
        searchButton.setTitleColor(RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0), for: .normal)
        addSubview(searchButton)
        
        var image = UIImage.init(named: "home_icon_search_white_30x30_")
        image = image?.withRenderingMode(.alwaysTemplate)
        
        searchImage = UIImageView.init(frame: CGRect(x: searchButton.mj_w - 40, y: 2, width: 30, height: 30))
        searchImage.image = image
        searchImage.tintColor = RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0)
        searchButton.addSubview(searchImage)
        
        let btnView = UIView.init(frame: CGRect(x: searchButton.frame.maxX + 10, y: 5, width: 150, height: 50 - 16))
        btnView.layer.masksToBounds = true
        btnView.layer.cornerRadius = 17;
        btnView.backgroundColor = RGB(r: 218.0, g: 219.0, b: 227.0, a: 1.0)
        addSubview(btnView)
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 15, y: 2, width: 30, height: 30)
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn1.setTitle("古装", for: .normal)
        btn1.setTitleColor(RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0), for: .normal)
        btnView.addSubview(btn1)

        let btn2 = UIButton(type: .custom)
        btn2.frame = CGRect(x: btn1.frame.maxX + 10, y: 2, width: 30, height: 30)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn2.setTitle("偶像", for: .normal)
        btn2.setTitleColor(RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0), for: .normal)
        btnView.addSubview(btn2)
        
        var image2 = UIImage.init(named: "home_topbar_icon_filter_light_11x11_")
        image2 = image2?.withRenderingMode(.alwaysTemplate)
        
        let btn3 = UIButton(type: .custom)
        btn3.frame = CGRect(x: btn2.frame.maxX + 10, y: 2, width: 45, height: 30)
        btn3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn3.setTitle("全部", for: .normal)
        btn3.setImage(image2, for: .normal)
        btn3.tintColor = RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0)
        btn3.setTitleColor(RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0), for: .normal)
        //btn3.imageView?.tintColor = RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0)
        btnView.addSubview(btn3)

        bringSubviewToFront(searchButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
