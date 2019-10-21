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
    
    var textColor: UIColor! = .white//字体颜色
    var imageColor: UIColor! = .white//图片颜色
    var bgColor: UIColor! = RGB(r: 44.0, g: 47.0, b: 55.0, a: 1.0)//默认按钮背景颜色
    
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
    
    func updateThemeColor() {

        searchButton.backgroundColor = bgColor
        searchButton.setTitleColor(textColor, for: .normal)
        
        searchImage.tintColor = imageColor
        
        for view in subviews {

            if view.isKind(of: UIButton.self) {
                    
                (view as! UIButton).tintColor = imageColor
            }
            
            if view.isKind(of: UIView.self) {
                    
                view.backgroundColor = bgColor
                
                for sView in view.subviews {
                    
                    if sView.isKind(of: UIButton.self) {
                            
                        (sView as! UIButton).tintColor = imageColor
                        (sView as! UIButton).setTitleColor(textColor, for: .normal)
                    }
                }
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
