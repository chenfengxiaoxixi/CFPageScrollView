//
//  ProtocolAction.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/27.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import Foundation

protocol ZoomAction { }

extension ZoomAction where Self: UIView {
    
    func enlarge() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = NSNumber(value: 1)
        animation.toValue = NSNumber(value: 1.3)
        animation.duration = 0.25
        animation.isRemovedOnCompletion = false;
        animation.fillMode = .forwards
        self.layer.add(animation, forKey: "enlargeLayer")
    }
    
    func recovery() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = NSNumber(value: 1.3)
        animation.toValue = NSNumber(value: 1)
        animation.duration = 0.25
        animation.isRemovedOnCompletion = false;
        animation.fillMode = .forwards
        self.layer.add(animation, forKey: "recoveryLayer")
    }
    
}
