//
//  ChildCircleHeader1.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/6.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class ChildCircleHeader1: UICollectionReusableView {
    
    var bgImageView: UIImageView!
    var gradientLayer: CAGradientLayer!
    var bottomColors: Array<UIColor>!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let bottomColor1 = RGB(r: 219.0, g: 71.0, b: 28.0, a: 1)
        let bottomColor2 = RGB(r: 89.0, g: 158.0, b: 32.0, a: 1)
        let bottomColor3 = RGB(r: 29.0, g: 75.0, b: 117.0, a: 1)
        
        bottomColors = [bottomColor1,bottomColor2,bottomColor3]

        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]

        //创建CAGradientLayer对象并设置参数
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ThemeBlackColor.cgColor, bottomColor1.cgColor]
        gradientLayer.locations = gradientLocations

        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        
        let array = ["ad1","ad2","ad3"];
        
        let cycleScrollView = SDCycleScrollView(frame: CGRect(x: 15, y: 0, width: mj_w - 30, height: mj_h), imageNamesGroup: array)
        
        cycleScrollView?.backgroundColor = UIColor.white;
        cycleScrollView?.autoScrollTimeInterval = 3;
        cycleScrollView?.bannerImageViewContentMode = .scaleAspectFill;
        cycleScrollView?.currentPageDotColor = .white;
        cycleScrollView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        cycleScrollView?.delegate = self
        self.addSubview(cycleScrollView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChildCircleHeader1: SDCycleScrollViewDelegate {

    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {

        let bottomColor: UIColor = bottomColors[index]
        
        let array = [ThemeBlackColor.cgColor, bottomColor.cgColor]
        
        gradientLayer.colors = array
    }

}
