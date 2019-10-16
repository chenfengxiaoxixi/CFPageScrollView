//
//  HotspotSearchView.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/10/8.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class HotspotSearchView: BaseSearchView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: 15, y: 5, width: SCREEN_WIDTH - 30, height: 50 - 16)
        searchButton.backgroundColor = RGB(r: 44.0, g: 47.0, b: 55.0, a: 1.0)
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 17
        addSubview(searchButton)
        
        searchImage = UIImageView.init(frame: CGRect(x: searchButton.mj_w - 40, y: 2, width: 30, height: 30))
        searchImage.image = UIImage.init(named: "home_icon_search_white_30x30_")
        searchButton.addSubview(searchImage)
        
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
