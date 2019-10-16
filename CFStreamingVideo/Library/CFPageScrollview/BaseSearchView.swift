//
//  BaseSearchView.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/5.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class BaseSearchView: UIView {

    var identifier: String!
    var searchButton: UIButton!
    var searchImage: UIImageView!
    
    //searchview切换时的伸缩动画
    func searchButtonTransitionAnimation(preWidth: CGFloat) {
        
        let oWidth = searchButton.mj_w
        searchButton.mj_w = preWidth
        searchImage.mj_x = searchButton.mj_w - 40
        UIView.animate(withDuration: 0.25) {
            self.searchButton.mj_w = oWidth
            self.searchImage.mj_x = self.searchButton.mj_w - 40
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
