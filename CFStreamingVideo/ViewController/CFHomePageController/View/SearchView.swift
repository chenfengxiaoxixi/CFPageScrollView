//
//  SearchView.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class SearchView: BaseSearchView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: 15, y: 5, width: SCREEN_WIDTH - 30 - 80, height: 50 - 16)

        searchButton.backgroundColor = RGB(r: 44.0, g: 47.0, b: 55.0, a: 1.0)
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 17;
        searchButton.setTitle("画江湖之袁天罡", for: .normal)
        addSubview(searchButton)
        
        searchImage = UIImageView.init(frame: CGRect(x: searchButton.mj_w - 40, y: 2, width: 30, height: 30))
        searchImage.image = UIImage.init(named: "home_icon_search_white_30x30_")
        searchButton.addSubview(searchImage)
        
        let downloadBtn = UIButton(type: .custom)
        downloadBtn.frame = CGRect(x: searchButton.frame.maxX + 8, y: 6, width: 34, height: 34)
        downloadBtn.setImage(UIImage.init(named: "home_topbar_icon_download_24x24_"), for: .normal)
        addSubview(downloadBtn)
        
        let historyBtn = UIButton(type: .custom);
        historyBtn.frame = CGRect(x: downloadBtn.frame.maxX + 8, y: 6, width: 34, height: 34)
        historyBtn.setImage(UIImage.init(named: "home_topbar_icon_history_light_24x24_"), for: .normal)
        addSubview(historyBtn)
        
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
