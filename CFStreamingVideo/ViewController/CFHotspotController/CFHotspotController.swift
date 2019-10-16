//
//  CFHotspotController.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/21.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class CFHotspotController: CFBaseController {

    var pageView: CFPageScrollView!
    var pageData: Array<PageDataModel>!
    var searchTitles: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let dicArray: Array<Dictionary> = getHotspotDataSource()
        
        pageData = ModelTool.arrayToJSONModel(PageDataModel.self, withKeyValuesArray: dicArray)
        
        //CFPageScrollView()是个viewcontroller，每个页面是childController，便于解耦
        pageView = CFPageScrollView()
        pageView.dataSource = self
        addChild(pageView)
        pageView.didMove(toParent: self)
        pageView.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.addSubview(pageView.view)
        
    }
    
    @objc func displaySearchController() {
        
        let searchVC = SearchController()
        
        present(searchVC, animated: true) {
            
        }
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

// MARK: - PageScrollviewViewDataSource
extension CFHotspotController: PageScrollViewDataSource {
    
    func getScrollViewData() -> Array<Any> {
        return pageData
    }
    
    func getNavHeaderThemeColorWith(_ index: Int) -> Dictionary<String, UIColor> {

        return [backgroundColorKey: ThemeBlackColor,
                norTextColorKey: ThemeGrayWhiteColor,
                selTextColorKey: ThemeBlueColor]
  
    }
    
    func getSearchViewWith(_ index: Int) -> BaseSearchView {
        
        let view: BaseSearchView = pageView.reuseSearchViewWith(classString: "HotspotSearchView", identifier: "view") as! BaseSearchView
        view.searchButton.setTitle(pageData[index].title, for: .normal)
        view.searchButton.addTarget(self, action: #selector(displaySearchController), for: .touchUpInside)
        return view
    }
    
}
