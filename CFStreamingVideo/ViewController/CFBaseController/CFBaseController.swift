//
//  CFBaseController.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/21.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class CFBaseController: UIViewController {

    var headerColor: UIColor!//视图往下滑动时,头部的遮罩颜色
    var headFillView: UIView!//视图往下滑动时,头部的遮罩视图
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        
        //ScrollView类型的视图拉伸时头部填充视图
        headFillView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.mj_w, height: 0.01))
        headFillView.backgroundColor = headerColor
        view.addSubview(headFillView)
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UIScrollViewDelegate
extension ChildController1: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset;
        print(offset.y);
 
        if offset.y < 0 {
            headFillView.mj_h = abs(offset.y);
        }
    }
}
