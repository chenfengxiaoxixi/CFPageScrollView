//
//  HotspotCell1.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/10/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class HotspotCell1: UITableViewCell {

    var imageVW: UIImageView!
    var titleStr: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageVW = UIImageView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 160))
        contentView.addSubview(imageVW)
        
        titleStr = UILabel.init(frame: CGRect(x: 15, y: imageVW.frame.maxY + 10, width: self.mj_w - 30, height: 20))
        titleStr.font = UIFont.systemFont(ofSize: 14)
        titleStr.textColor = UIColor.black
        contentView.addSubview(titleStr)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
