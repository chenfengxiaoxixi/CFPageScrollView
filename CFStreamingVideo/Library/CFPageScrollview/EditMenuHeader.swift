//
//  EditMenuHeader.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/19.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class EditMenuHeader: UICollectionReusableView {
    
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = UILabel.init(frame: CGRect(x: 15, y: 0, width: mj_w, height: 20))
        title.textColor = .darkText
        title.font = UIFont.systemFont(ofSize: 16)
        addSubview(title)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
