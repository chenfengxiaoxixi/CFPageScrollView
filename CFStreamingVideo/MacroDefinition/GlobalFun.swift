//
//  GlobalFun.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/3.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import Foundation

func RGB(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
}

func swiftClassFromString(className: String) -> AnyClass! {
 
    if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {

        let classStringName = appName + "." + className
        return NSClassFromString(classStringName)
    }
    return nil;
}
