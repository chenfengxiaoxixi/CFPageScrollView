//
//  CFHomePageController.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/21.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

struct PageDataModel: Codable, Equatable {
    
    var title: String!
    var controller: String!
    var isNeedToDisplay: Bool?
    var isAllowedEditing: Bool?
}

class CFHomePageController: CFBaseController {
    
    var pageView: CFPageScrollView!
    var preWidth: CGFloat!
    var dataSource: Array<PageDataModel>!
    var pageData: Array<PageDataModel>!
    var menuDataSource: Array<Array<PageDataModel>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        preWidth = 0
        
        menuDataSource = Array()
        pageData = Array()
        
        configData()
        
        //CFPageScrollView()是个viewcontroller，每个页面是childController，便于解耦
        pageView = CFPageScrollView()
        pageView.dataSource = self
        pageView.delegate = self
        addChild(pageView)
        pageView.didMove(toParent: self)
        pageView.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.addSubview(pageView.view)
        
        //可编辑菜单，用分组显示所有数据
        handleMenuData()
        
    }
    
    @objc func displaySearchController() {
        
        let searchVC = SearchController()
        
        present(searchVC, animated: true) {
            
        }
    }
    
    func configData() {

        let fetchRequest: NSFetchRequest = MenuData.fetchRequest()

        let result: Array<MenuData>? = try? CoreDataManager.viewContext.fetch(fetchRequest)
        
        //总数据
        dataSource = {
            
            var array: Array<PageDataModel>! = Array()
            
            for data in result! {
                
                var model: PageDataModel = PageDataModel()
                
                model.title = data.title
                model.controller = data.controller
                model.isAllowedEditing = data.isAllowedEditing
                model.isNeedToDisplay = data.isNeedToDisplay
                
                array.append(model)
            }
            return array
        }()
        
        let fetchRequest2: NSFetchRequest = DisplayData.fetchRequest()

        let result2: Array<DisplayData>? = try? CoreDataManager.viewContext.fetch(fetchRequest2)
        
        //显示的page数据
        pageData = {
            
            var array: Array<PageDataModel>! = Array()
            
            for data in result2! {
                
                var model: PageDataModel = PageDataModel()
                
                model.title = data.title
                model.controller = data.controller
                model.isAllowedEditing = data.isAllowedEditing
                model.isNeedToDisplay = data.isNeedToDisplay
                
                array.append(model)
            }
            return array
        }()
        
    }
    
    func handleMenuData() {
        var sectionTwoDataArray = Array<PageDataModel>()

        for model in dataSource {

            if model.isAllowedEditing ?? false
            {
                sectionTwoDataArray.append(model)
            }
        }
        
        menuDataSource.append(pageData)//menu里面的第一组数据
        menuDataSource.append(sectionTwoDataArray)//menu里面的第二组数据，可对该组数据进行分类出2，3，4，5组数据，
        //例如,内部逻辑已经处理好
        //menuDataSource.append(dataSource2)
        //menuDataSource.append(dataSource3)
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
extension CFHomePageController: PageScrollViewDelegate {

    func editFinishWith(_ completionData: Array<Any>) {
        
        if pageData == completionData as? Array<PageDataModel> {
            
            print("相等时不作操作")
        }
        else
        {
            
            let fetchRequest: NSFetchRequest = DisplayData.fetchRequest()
            
            let result: Array<DisplayData>? = try? CoreDataManager.viewContext.fetch(fetchRequest)
            
            for model in result! {

                CoreDataManager.viewContext.delete(model)
            }
            
            CoreDataManager.saveContext()
            
            for dataModel in completionData {

                let model: DisplayData = CoreDataManager.getEntityAndInsertNewObjectWith(entityName: "DisplayData") as! DisplayData

                model.title = (dataModel as! PageDataModel).title
                model.controller = (dataModel as! PageDataModel).controller
                model.isNeedToDisplay = (dataModel as! PageDataModel).isNeedToDisplay!
                model.isAllowedEditing = (dataModel as! PageDataModel).isAllowedEditing!

                CoreDataManager.saveContext()
            }
            
            var newArray: Array<String> = Array()
            var newPredicateCondition: String = ""
            
            for newModel in completionData {
                var isAdd: Bool = true
                for pageModel in pageData {
                    
                    if (newModel as! PageDataModel).title == pageModel.title  {
                        isAdd = false
                    }
                }
                
                if isAdd {
                    newArray.append((newModel as! PageDataModel).title)
                    
                    if newPredicateCondition.count == 0 {
                        newPredicateCondition = "title == %@"
                    }
                    else
                    {
                       newPredicateCondition = newPredicateCondition + " || title == %@"
                    }
                }
            }
            
            if newArray.count > 0 {
                
                let fetchRequest2: NSFetchRequest = MenuData.fetchRequest()
                fetchRequest2.predicate = NSPredicate(format: newPredicateCondition, argumentArray: newArray)

                let result2: Array<MenuData>? = try? CoreDataManager.viewContext.fetch(fetchRequest2)

                for data in result2! {
                    
                    data.isNeedToDisplay = true
                }
                
                CoreDataManager.saveContext()
            }
            
            var deleteArray: Array<String> = Array()
            var deletePredicateCondition: String = ""
            for pageModel in pageData {
                var isDelete: Bool = true
                for newModel in completionData {
                    
                    if pageModel.title == (newModel as! PageDataModel).title {
                        isDelete = false
                    }
                }
                
                if isDelete {
                    deleteArray.append(pageModel.title)
                    
                    if deletePredicateCondition.count == 0 {
                        deletePredicateCondition = "title == %@"
                    }
                    else
                    {
                       deletePredicateCondition = deletePredicateCondition + " || title == %@"
                    }
                }
            }
            
            if deleteArray.count > 0 {
                let fetchRequest3: NSFetchRequest = MenuData.fetchRequest()
                fetchRequest3.predicate = NSPredicate(format: deletePredicateCondition, argumentArray: deleteArray)
             
                let result3: Array<MenuData>? = try? CoreDataManager.viewContext.fetch(fetchRequest3)
                
                for data in result3! {
                    
                    data.isNeedToDisplay = false
                }
                
                CoreDataManager.saveContext()
            }
            
            print("不相等时，需要跟新数据")
            
            pageData = completionData as? Array<PageDataModel>
            
            pageView.reloadData()
            
        }
    }

}

// MARK: - PageScrollviewViewDataSource
extension CFHomePageController: PageScrollViewDataSource {
    
    func isDisplayMenu() -> Bool {
        return true
    }
    
    func getMenuData() -> Array<Any> {
        return menuDataSource
    }
    
    func getMenuSectionTitle() -> Array<String> {
        return ["显示频道","未显示频道"]
    }
    
    func getScrollViewData() -> Array<Any> {
        return pageData
    }
    
    func getNavHeaderThemeColorWith(_ index: Int) -> Dictionary<String, UIColor> {

        if index == 0 {

            return [backgroundColorKey: ThemeBlackColor,
                    norTextColorKey: ThemeGrayWhiteColor,
                    selTextColorKey: ThemeBlueColor]
        }
        else if index == 1 {

            return [backgroundColorKey: RGB(r: 195.0, g: 26.0, b: 28.0, a: 1.0),
                    norTextColorKey: RGB(r: 240.0, g: 195.0, b: 152.0, a: 1.0),
                    selTextColorKey: RGB(r: 255.0, g: 253.0, b: 199.0, a: 1.0)]
        }
        else {

            return [backgroundColorKey: RGB(r: 230.0, g: 230.0, b: 235.0, a: 1.0),
                    norTextColorKey: RGB(r: 62.0, g: 86.0, b: 127.0, a: 1.0),
                    selTextColorKey: RGB(r: 33.0, g: 62.0, b: 107.0, a: 1.0)]

        }
    }
    
    func getSearchViewWith(_ index: Int) -> BaseSearchView {
        
        if index == 0 {
            let view: BaseSearchView = pageView.reuseSearchViewWith(classString: "SearchView", identifier: "view1") as! BaseSearchView
            view.searchButtonTransitionAnimation(preWidth: preWidth)
            view.searchButton.addTarget(self, action: #selector(displaySearchController), for: .touchUpInside)
            preWidth = view.searchButton.mj_w
            return view
        }
        else if index == 1 {
            let view: BaseSearchView = pageView.reuseSearchViewWith(classString: "SearchView2", identifier: "view2") as! BaseSearchView
            view.searchButtonTransitionAnimation(preWidth: preWidth)
            view.searchButton.addTarget(self, action: #selector(displaySearchController), for: .touchUpInside)
            preWidth = view.searchButton.mj_w
            return view
        }
        else
        {
            let view: BaseSearchView = pageView.reuseSearchViewWith(classString: "SearchView3", identifier: "view3") as! BaseSearchView
            view.searchButtonTransitionAnimation(preWidth: preWidth)
            view.searchButton.addTarget(self, action: #selector(displaySearchController), for: .touchUpInside)
            preWidth = view.searchButton.mj_w
            return view
        }
        
    }
    
}
