//
//  CFPageScrollview.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/8/21.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

@objc protocol PageScrollViewDelegate {
    
    @objc optional func editFinishWith(_ completionData: Array<Any>)
}

@objc protocol PageScrollViewDataSource {
    
    //获取searchview
    func getSearchViewWith(_ index: Int) -> BaseSearchView
    
    //获取ScrollView显示数据，数组里面要是PageDataModel
    func getScrollViewData() -> Array<Any>
    
    //获取头部主题颜色
    func getNavHeaderThemeColorWith(_ index: Int) -> Dictionary<String, UIColor>
    
    //是否显示菜单按钮，如果显示了菜单，那下面的数据代理也要实现
    @objc optional func isDisplayMenu() -> Bool
    
    //获取菜单显示数据，数组里面要是PageDataModel
    @objc optional func getMenuData() -> Array<Any>
    
    //获取菜单显示数据
    @objc optional func getMenuSectionTitle() -> Array<String>
    
}

let navItemViewHeight: CGFloat = 60
let searchViewHeight: CGFloat = 50

let backgroundColorKey: String = "backgroundColor"
let norTextColorKey: String = "norTextColor"
let selTextColorKey: String = "selTextColor"

class CFPageScrollView: UIViewController {
    
    var navHeaderView: UIView!
    
    var navItemView: NavigationItemView!
    var array: Array<PageDataModel>!
    var titles: Array<String>!
    
    var menuBtn: UIButton!
    var menuVC: EditMenuController!
    
    var childVC: Array<CFBaseController>!
    var titleWidths: Array<CGFloat>!
    var titleCentersX: Array<CGFloat>!
    var pageScrollView: UIScrollView!
    var lastContentOffset: CGFloat!
    var distance: CGFloat!
    var pageWidth: CGFloat!
    var centerX: CGFloat!
    var selectPageIndex: Int!
    var isScroll: Bool!
    var isFrontHalf: Bool!
    var targetContentOffsetX: CGFloat!
    
    var searchView: BaseSearchView!
    var searchViewDic: Dictionary<String, String>!
    var searchViewArray: Array<UIView>!
    
    var currentPage: Int!
    var refreshNavHeader: Bool!
    
    var colorDic: Dictionary<String, UIColor>!
    
    weak open var dataSource: PageScrollViewDataSource? {
        //外部设置完之后调用这个方法
        didSet { self.setDataSource() }
    }
    
    weak open var delegate: PageScrollViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // Do any additional setup after loading the view.
        
    }
    
    func setDataSource() {
        
        array = dataSource?.getScrollViewData() as? Array<PageDataModel>
        
        if array == nil || array.count == 0 {
            return
        }
        
        childVC = Array()
        searchViewDic = Dictionary()
        searchViewArray = Array()
        
        isScroll = false
        refreshNavHeader = false
        currentPage = 0
        selectPageIndex = 0
        
        titles = Array()
        titleWidths = Array()
        titleCentersX = Array()
        lastContentOffset = 0
        
        colorDic = dataSource?.getNavHeaderThemeColorWith(0)
        
        let isDisplayMenu: Bool = dataSource?.isDisplayMenu?() ?? false
        
        //顶部背景view
        navHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.mj_w, height: navItemViewHeight + searchViewHeight + (STATUS_AND_NAV_BAR_HEIGHT - 40)))
        navHeaderView.backgroundColor = colorDic?[backgroundColorKey] ?? ThemeBlackColor
        view.addSubview(navHeaderView)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        //顶部滑动itemview
        navItemView = NavigationItemView.init(frame: CGRect(x: 0, y: STATUS_AND_NAV_BAR_HEIGHT - 40, width: isDisplayMenu ? view.mj_w - 50 : view.mj_w, height: navItemViewHeight), collectionViewLayout: layout)
        navItemView.norTextColor = colorDic?[norTextColorKey] ?? ThemeGrayWhiteColor
        navItemView.selTextColor = colorDic?[selTextColorKey] ?? ThemeBlueColor
        navItemView.itemViewDelegate = self
        navItemView.itemViewDataSource = self
        navHeaderView.addSubview(navItemView)
        
        //菜单按钮
        if isDisplayMenu {
            
            var image = UIImage.init(named: "home_top_channel_menu_30x30_")
            image = image?.withRenderingMode(.alwaysTemplate)
            
            menuBtn = UIButton(type: .custom)
            menuBtn.frame = CGRect(x: view.mj_w - 50, y: STATUS_AND_NAV_BAR_HEIGHT - 30, width: 50, height: 40)
            menuBtn.setImage(image, for: .normal)
            menuBtn.tintColor = colorDic?[norTextColorKey] ?? UIColor.white
            navHeaderView.addSubview(menuBtn)
            
            menuBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        }
        
        //搜索栏
        searchView = dataSource?.getSearchViewWith(0)
        navHeaderView.addSubview(searchView)
        
        //pageview详情
        pageScrollView = UIScrollView.init(frame: CGRect(x: 0, y: navHeaderView.frame.maxY, width: view.mj_w, height: view.mj_h - navHeaderView.frame.maxY - TABBAR_HEIGHT))
        pageScrollView.delegate = self
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.contentSize = CGSize(width: CGFloat(array.count) * pageScrollView.mj_w, height: pageScrollView.mj_h)
        pageScrollView.isPagingEnabled = true
        //pageScrollView.bounces = false
        view.addSubview(pageScrollView)
        
        pageWidth = pageScrollView.mj_w
        
        for i in 0..<array.count {

            let clrDic = dataSource?.getNavHeaderThemeColorWith(i)
            
            let model: PageDataModel = array[i]
            
            let controller: String = model.controller
           
            //title宽度计算
            let title: String = model.title
                
            titles.append(title)
                
            let size: CGSize = title.sizeWithText(font: UIFont.boldSystemFont(ofSize: 20), size: CGSize(width: 0, height: view.mj_w))
                
            titleWidths.append(size.width + 20)
                
            //初始化Controller
            let anyobjecType: AnyObject.Type = swiftClassFromString(className: controller)
                
            let vc = (anyobjecType as! NSObject.Type).init()
                
            (vc as! CFBaseController).headerColor = clrDic?[backgroundColorKey] ?? ThemeBlackColor
            self.addChild((vc as! CFBaseController))
            (vc as! CFBaseController).didMove(toParent: self)
            (vc as! CFBaseController).view.frame = CGRect(x: CGFloat(i)*view.mj_w, y: 0, width: pageScrollView.mj_w, height: pageScrollView.mj_h)
            pageScrollView.addSubview((vc as! CFBaseController).view)
                
            childVC.append(vc as! CFBaseController)
            
            //array[i].isLoad = true
        }
        
        //let leftEdgeInset: CGFloat = 5
        
        //通过宽度算出每个cell的x中心坐标，用于bottomPoint执行位移动画
        for i in 0..<titleWidths.count {
            //左边第一个item起始偏移为5
            var x: CGFloat = 5
            for j in 0...i {
                
                if i != j {
                    x = titleWidths[j] + x
                }
                else
                {
                    x = titleWidths[j]/2 + x
                }
            }
            
            titleCentersX.append(x)
        }
        
        navItemView.titleWidths = titleWidths
        navItemView.titleCentersX = titleCentersX
        navItemView.reloadNavItemData()
    }
    
    //重载编辑后的滑动分类页面数据
    func reloadData() {
        
        let oldDataSource: Array<PageDataModel> = array
        
        let newDataSource: Array<PageDataModel> = dataSource?.getScrollViewData() as! Array<PageDataModel>
        
        if newDataSource.count == 0 {
            return
        }
        
        pageScrollView.contentSize = CGSize(width: pageScrollView.mj_w*CGFloat(newDataSource.count), height: pageScrollView.mj_h)
        
        titles.removeAll()
        titleWidths.removeAll()
        titleCentersX.removeAll()
        
        let preSelectedModel = oldDataSource[navItemView.selectIndex]
        
        var isDelete: Bool = true
        
        //更新上一次选中项的下标，如果被删除了，则设置为0
        for i in 0..<newDataSource.count {
            if preSelectedModel == newDataSource[i] {
                navItemView.selectIndex = i
                isDelete = false
            }
        }
        
        if isDelete {
            navItemView.selectIndex = 0
        }
        
        var newChildVC: Array<CFBaseController>! = Array()
        
        for i in 0..<newDataSource.count {
            
            let newModel = newDataSource[i]
            let oldModel = i>=oldDataSource.count ? nil : oldDataSource[i]
            
            titles.append(newModel.title)
            
            var isAdd: Bool = true
            //如果模型位置发生了改变，同时也要改变childvc的位置和view的frame
            if newModel != oldModel {
                
                for j in 0..<oldDataSource.count {
                    
                    let oldModel2 = oldDataSource[j]

                    if newModel == oldModel2 {
                        
                        isAdd = false
                        
                        let vc = childVC[j]
                    
                        vc.view.mj_x = CGFloat(i) * pageScrollView.mj_w
                        
                        newChildVC.append(childVC[j])
                    }
                }
                
                //原数据没有该模型就新增
                if isAdd == true {
                    
                    let clrDic = dataSource?.getNavHeaderThemeColorWith(i)
                    
                    let controller: String = newModel.controller

                    let anyobjecType: AnyObject.Type = swiftClassFromString(className: controller)
                    
                    let vc = (anyobjecType as! NSObject.Type).init()
                    
                    (vc as! CFBaseController).headerColor = clrDic?[backgroundColorKey] ?? ThemeBlackColor
                    self.addChild((vc as! CFBaseController))
                    (vc as! CFBaseController).didMove(toParent: self)
                    (vc as! CFBaseController).view.frame = CGRect(x: CGFloat(i)*pageScrollView.mj_w, y: 0, width: pageScrollView.mj_w, height: pageScrollView.mj_h)
                    pageScrollView.addSubview((vc as! CFBaseController).view)
                    
                    newChildVC.append(vc as! CFBaseController)
                    
                }
            }
            else
            {
                newChildVC.append(childVC[i])
            }
        }

        //移除未使用的childvc
        for vc in children {
            var isExist: Bool = false
            for vc2 in newChildVC {
                
                if vc == vc2 {
                    
                    isExist = true
                }
            }
            
            if !isExist {
                let childVC = vc
                childVC.view.removeFromSuperview()
                childVC.willMove(toParent: nil)
                childVC.removeFromParent()
            }
        }
        
        childVC = newChildVC

        //title宽度计算
        for i in 0..<titles.count {

            let title: String = titles[i]

            let size: CGSize = title.sizeWithText(font: UIFont.boldSystemFont(ofSize: 20), size: CGSize(width: 0, height: view.mj_w))

            titleWidths.append(size.width + 20)
        }

        //通过宽度算出每个cell的x中心坐标，用于bottomPoint执行位移动画
        for i in 0..<titleWidths.count {
            var x: CGFloat = 0
            for j in 0...i {

                if i != j {
                    x = titleWidths[j] + x
                }
                else
                {
                    x = titleWidths[j]/2 + x
                }
            }
            titleCentersX.append(x)
        }
        
        navItemView.titleWidths = titleWidths
        navItemView.titleCentersX = titleCentersX
        navItemView.titles = titles

        array = newDataSource

        currentPage = navItemView.selectIndex
        selectPageIndex = navItemView.selectIndex
        lastContentOffset = CGFloat(navItemView.selectIndex) * pageWidth

        changeSearchView()
        changeThemeColor()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.navItemView.scrollToMidScreen(index: self.selectPageIndex)
        }
        
        navItemView.bottomPoint.center.x = titleCentersX[selectPageIndex]
        pageScrollView.setContentOffset(CGPoint(x: lastContentOffset, y: 0), animated: false)
        
    }
    
    func changeSearchView() {
        
        searchView.removeFromSuperview()
        searchView = dataSource?.getSearchViewWith(selectPageIndex)
        navHeaderView.addSubview(searchView)
    }
    
    func changeThemeColor() {
        
        colorDic = dataSource?.getNavHeaderThemeColorWith(selectPageIndex)
        
        navHeaderView.backgroundColor = colorDic?[backgroundColorKey] ?? ThemeBlackColor
        
        navItemView.norTextColor = colorDic?[norTextColorKey] ?? ThemeGrayWhiteColor
        navItemView.selTextColor = colorDic?[selTextColorKey] ?? ThemeBlueColor
        navItemView.bottomPoint.backgroundColor = colorDic?[selTextColorKey] ?? ThemeBlueColor
        navItemView.reloadData()
        
        if menuBtn != nil {
            menuBtn.tintColor = colorDic?[norTextColorKey] ?? UIColor.white
        }
        
    }
    
    @objc func showMenu() {
        
        if menuVC != nil {
            menuVC.displayMenu()
        }
        else
        {
            let rootVC = APPDELEGATE.window?.rootViewController
            menuVC = EditMenuController()
            menuVC.groupDataArray = dataSource?.getMenuData?() as? Array<Array<PageDataModel>>
            menuVC.sectionTitleArray = dataSource?.getMenuSectionTitle?()
            rootVC?.addChild(menuVC)
            menuVC.didMove(toParent: rootVC)
            menuVC.view.isHidden = false
            rootVC?.view.addSubview(menuVC.view)
            
            menuVC.finishEditingWithData = {[unowned self] (array: Array<PageDataModel>) in
                
                self.delegate?.editFinishWith?(array)
            }
            
            menuVC.displayMenu()
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

// MARK: - searchview复用
extension CFPageScrollView {
    
    func reuseSearchViewWith(classString: String, identifier: String) -> UIView {
        //根据identifier重用视图
        for view in searchViewArray {
            
            if (view as! BaseSearchView).identifier == identifier {
                return view
            }
        }

        //根据类名字符串创建类
        let anyobjecType: AnyObject.Type = swiftClassFromString(className: classString)
        
        let vw = (anyobjecType as! NSObject.Type).init()
        
        (vw as! BaseSearchView).frame = CGRect(x: 0, y: navItemView.frame.maxY, width: view.mj_w, height: searchViewHeight)
        
        (vw as! BaseSearchView).identifier = identifier

        searchViewArray.append(vw as! UIView)
        
        return vw as! UIView

    }
    
}

// MARK: - NavigationItemViewDelegate
extension CFPageScrollView: NavigationItemViewDelegate {
    func itemView(_ itemView: NavigationItemView, didSelectAt Index: Int) {
        
        isScroll = false
        
        pageScrollView.setContentOffset(CGPoint(x: view.mj_w * CGFloat(Index), y: 0), animated: false)
        
        selectPageIndex = Index
    
        changeSearchView()
        changeThemeColor()
    }
}

// MARK: - NavigationItemViewDataSource
extension CFPageScrollView: NavigationItemViewDataSource {
    func getNavigationItemTitles() -> Array<Any> {
        return titles
    }
}

// MARK: - UIScrollViewDelegate
extension CFPageScrollView: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isScroll = true
        
        lastContentOffset = scrollView.mj_offsetX
        
    }
    
    //bottomPoint动画执行逻辑
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //点击item切换时不触发滚动动画
        if !isScroll {
            return
        }
        
        //判断滑动超过半页时，计算出目标targetContentOffsetX,floor 如果参数是小数  则求最大的整数但不大于本身.
        let targetIndex: Int = Int(floor((scrollView.mj_offsetX - pageWidth/2)/pageWidth)) + 1
        
        if targetIndex != currentPage {
            
            if targetIndex > currentPage {
                
                targetContentOffsetX = CGFloat(targetIndex) * pageWidth
                refreshNavHeader = true
                print("下一页")
//                print(targetIndex)
            }
            else
            {
                targetContentOffsetX = CGFloat(targetIndex) * pageWidth
                refreshNavHeader = true
                print("上一页")
//                print(targetIndex)
            }
        
            currentPage = targetIndex
        }
        
        let offset_x = scrollView.mj_offsetX
        
        var index: Int = 0
        
        //向右滑动
        if offset_x < lastContentOffset {
            
            if self.selectPageIndex - 1 == -1
            {
                return
            }
            
            //如果参数是小数  则求最小的整数但不小于本身.
            index = Int(ceil((scrollView.mj_offsetX - pageWidth)/pageWidth)) + 1
            
            self.distance = self.titleCentersX[self.selectPageIndex] - self.titleCentersX[self.selectPageIndex - 1]
            
            let halfPageWidth = self.pageWidth/2
            
            if offset_x >= halfPageWidth + CGFloat(self.selectPageIndex - 1)*self.pageWidth
            {
                
                isFrontHalf = true
                
                let offset_page_x = CGFloat(self.selectPageIndex)*self.pageWidth - offset_x
                
                //bottomPoint向左按滑动位移比率增大
                
                self.navItemView.bottomPoint.mj_w = self.distance/halfPageWidth * offset_page_x < 5 ? 5 : self.distance/halfPageWidth * offset_page_x
                self.navItemView.bottomPoint.center.x = self.titleCentersX[self.selectPageIndex] - self.distance/self.pageWidth * offset_page_x
                
                //print("宽度增大")
                
            }//超过一半后x往右缩
            else
            {
                //解决滑动位移跳变导致位移不够的问题,在后半部纠正
                if isFrontHalf {
                    isFrontHalf = false
                    self.centerX = self.titleCentersX[self.selectPageIndex] - self.distance/2
                    self.navItemView.bottomPoint.center.x = self.centerX
                    self.navItemView.bottomPoint.mj_w = self.distance
                }
                
                let offset_page_x = offset_x - CGFloat(self.selectPageIndex - 1)*self.pageWidth
                
                let subDistance: CGFloat = self.distance/halfPageWidth * (halfPageWidth - offset_page_x)
                let subHalfDistance: CGFloat = self.distance/self.pageWidth * (halfPageWidth - offset_page_x)
                
                self.navItemView.bottomPoint.center.x = self.centerX - subHalfDistance
                self.navItemView.bottomPoint.mj_w = self.distance - subDistance < 4 ? 4 : self.distance - subDistance
                
                //print("宽度减小")
            }

        }
        else
        {
            
            if self.selectPageIndex + 1 == self.titleCentersX.count
            {
                return
            }
            //print("向左滑动");
            //floor 如果参数是小数  则求最大的整数但不大于本身.
            index = Int(floor((scrollView.mj_offsetX - pageWidth)/pageWidth)) + 1
            
            self.distance = self.titleCentersX[self.selectPageIndex + 1] - self.titleCentersX[self.selectPageIndex]

            let halfPageWidth = self.pageWidth/2
            
            let offset_page_x = offset_x - CGFloat(self.selectPageIndex)*self.pageWidth
            
            if offset_x <= halfPageWidth + CGFloat(self.selectPageIndex)*self.pageWidth
            {
                //bottomPoint向右按滑动位移比率增大
                
                isFrontHalf = true
                
                self.navItemView.bottomPoint.mj_w = self.distance/halfPageWidth * offset_page_x < 5 ? 5 : self.distance/halfPageWidth * offset_page_x
                self.navItemView.bottomPoint.center.x = self.titleCentersX[self.selectPageIndex] + self.distance/self.pageWidth * offset_page_x
                
                //print("宽度增大")
                
            }
            else
            {
                //print("宽度减小")
                
                if isFrontHalf {
                    isFrontHalf = false
                    self.centerX = self.titleCentersX[self.selectPageIndex] + self.distance/2
                    self.navItemView.bottomPoint.center.x = self.centerX
                    self.navItemView.bottomPoint.mj_w = self.distance
                }

                //超过一半后x往右缩
                let subDistance: CGFloat = self.distance/halfPageWidth * (offset_page_x - halfPageWidth)
                let subHalfDistance: CGFloat = self.distance/self.pageWidth * (offset_page_x - halfPageWidth)

                self.navItemView.bottomPoint.center.x = self.centerX + subHalfDistance

                self.navItemView.bottomPoint.mj_w = self.distance - subDistance < 4 ? 4 : self.distance - subDistance
                
            }
        }
    
        
        //判断滑动刚好一页时，更新数据
        if index == currentPage && index != selectPageIndex {
            
            if refreshNavHeader {
                
                selectPageIndex = Int(targetContentOffsetX/pageWidth);
                navItemView.selectItemWith(index: selectPageIndex)
                
                changeSearchView()
                changeThemeColor()
                
                refreshNavHeader = false
                
                self.navItemView.bottomPoint.center.x = self.titleCentersX[self.selectPageIndex]
                self.navItemView.bottomPoint.bounds.size = CGSize(width: 5, height: 5)
            }
            
        }
    }
}
