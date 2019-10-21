//
//  CFTabBarController.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/19.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

class CFTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //禁用more导航
        moreNavigationController.isNavigationBarHidden = true
        
        addChildController(ChildController: CFHomePageController(), Title: "首页", DefaultImage: UIImage(named:"navbar_icon_home_normal_24x24_")!, SelectedImage: UIImage(named:"navbar_icon_home_selected_24x24_")!,index: 0)
        addChildController(ChildController: CFHotspotController(), Title: "热点", DefaultImage: UIImage(named:"navbar_icon_discovery_normal_24x24_")!, SelectedImage: UIImage(named:"navbar_icon_discovery_selected_24x24_")!,index: 1)
        addChildController(ChildController: CFVIPMemberController(), Title: "VIP会员", DefaultImage: UIImage(named:"navbar_icon_vip_normal_24x24_")!, SelectedImage: UIImage(named:"navbar_icon_vip_selected_24x24_")!,index: 2)
        addChildController(ChildController: CFStarController(), Title: "星球", DefaultImage: UIImage(named:"navbar_icon_planet_normal_24x24_")!, SelectedImage: UIImage(named:"navbar_icon_planet_selected_24x24_")!,index: 3)
        addChildController(ChildController: CFMyInfoController(), Title: "我的", DefaultImage: UIImage(named:"navbar_icon_user_normal_24x24_")!, SelectedImage: UIImage(named:"navbar_icon_user_selected_24x24_")!,index: 4)
        
        self.delegate = self
    }
    
    
    func addChildController(ChildController child:UIViewController, Title title:String, DefaultImage defaultImage:UIImage, SelectedImage selectedImage:UIImage, index:Int){
        
        child.tabBarItem = UITabBarItem(title: title, image: defaultImage.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage.withRenderingMode(.alwaysOriginal))
   
        if index == 2 {
       child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:ThemeYellowColor], for: .selected)
        }
        else
        {
       child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:ThemeBlueColor], for: .selected)
        }

    child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
        
        let nav = UINavigationController(rootViewController: child)
        nav.setNavigationBarHidden(true, animated: true)
        self.addChild(nav)
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
