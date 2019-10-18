//
//  HotspotChildController1.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/10/9.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class HotspotChildController1: CFBaseController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: view.mj_w, height: view.mj_h - TABBAR_HEIGHT - navItemViewHeight - searchViewHeight - (STATUS_AND_NAV_BAR_HEIGHT - 40)), style: .plain)
        tableView.backgroundColor = .white
        tableView.dataSource = self;
        tableView.delegate = self;
        view.addSubview(tableView)
        
        if #available(iOS 11.0, *)
        {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        self.headFillView.bringSubviewToFront(tableView)
        
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

extension HotspotChildController1: UITableViewDelegate {
    
    
}

extension HotspotChildController1: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: HotspotCell1? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as? HotspotCell1
        if cell == nil {
            cell = HotspotCell1.init(style: .default, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.imageVW.image = UIImage.init(named: "ad1");
        cell?.titleStr.text = "广告"
        return cell!
    }
}

