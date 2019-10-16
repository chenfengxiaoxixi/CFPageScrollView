//
//  ChildController4.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/28.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class ChildController4: CFBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let titleStr = UILabel.init(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        titleStr.font = UIFont.boldSystemFont(ofSize: 20)
        titleStr.textAlignment = .center
        titleStr.text = "热点"
        titleStr.textColor = UIColor.darkText
        view.addSubview(titleStr)
        
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
