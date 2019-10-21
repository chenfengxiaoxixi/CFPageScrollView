//
//  extension+String.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/28.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import Foundation

extension String {
    
    func sizeWithText(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
}
