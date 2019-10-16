//
//  ADNoticeViewCell.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class ADNoticeViewCell: GYNoticeViewCell {

    var indicator: UIImageView!
    
    override init!(reuseIdentifier: String!) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        indicator = UIImageView.init(image: UIImage.init(named: "arrow_s_12x12_"))
        
        addSubview(indicator)
        
        
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicator.frame = CGRect(x: mj_w - 12, y: mj_h/2 - 6, width: 12, height: 12)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
