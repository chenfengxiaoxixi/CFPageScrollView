# CFPageScrollView

仿ios优酷视频主页分类滚动页面视图，实现了滑动切换动画，渐变色，编辑分类页面等功能。二级页面使用AVFoundation实现了一个简单流媒体视频播放器，包括，播放，暂停，滑动快进，横竖屏切换等功能。

## 版本1.0.0

效果图：

![演示图1](https://github.com/chenfengxiaoxixi/CFPageScrollView/blob/master/演示图/演示图1.gif)
![演示图2](https://github.com/chenfengxiaoxixi/CFPageScrollView/blob/master/演示图/演示图2.gif)

使用：

```
override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    //CFPageScrollView()是个viewcontroller，每个页面是childController，便于解耦
    pageView = CFPageScrollView()
    pageView.dataSource = self
    pageView.delegate = self
    addChild(pageView)
    pageView.didMove(toParent: self)
    pageView.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
    view.addSubview(pageView.view)
    
}

// MARK: - PageScrollViewDelegate
extension CFHomePageController: PageScrollViewDelegate {

  //编辑完成时，这个代理会把数据传递出来
    func editFinishWith(_ completionData: Array<Any>) {
        
        if pageData == completionData as? Array<PageDataModel> {
            
            print("相等时不作操作")
        }
        else
        {
            //数据改变时，需要重载显示页面，这里我用coredata模拟了一个存取数据的逻辑，如果是网络请求，这部分逻辑提交给后台处理，你只用上传数据，然后reload。
         }
    }

}

// MARK: - PageScrollviewViewDataSource
extension CFHomePageController: PageScrollViewDataSource {
    
    //是否需要显示编辑菜单
    func isDisplayMenu() -> Bool {
        return true
    }
    
    //编辑菜单数组
    func getMenuData() -> Array<Any> {
        return menuDataSource
    }
    
    //编辑菜单分组title
    func getMenuSectionTitle() -> Array<String> {
        return ["显示频道","未显示频道"]
    }
 
    //如果不要编辑菜单，以上三个协议不用实现
 
    //分类滑动页面数据
    func getScrollViewData() -> Array<Any> {
        return pageData
    }
    
    //分类滑动页面颜色主题
    func getNavHeaderThemeColorWith(_ index: Int) -> Dictionary<String, UIColor>         {
         return [backgroundColorKey: ThemeBlackColor, //顶部背景色
                norTextColorKey: ThemeGrayWhiteColor, //字体和底部标记正常颜色
                selTextColorKey: ThemeBlueColor] //字体和底部标记选中颜色
  
    }
   
   //分类滑动页面搜索栏，SearchView为动态创建，identifier为重用标识
   func getSearchViewWith(_ index: Int) -> BaseSearchView {
        
       let view: BaseSearchView = pageView.reuseSearchViewWith(classString: "SearchView", identifier: "view1") as! BaseSearchView
       view.searchButtonTransitionAnimation(preWidth: preWidth)
       view.searchButton.addTarget(self, action: #selector(displaySearchController), for: .touchUpInside)
       preWidth = view.searchButton.mj_w

       return view
    }
}


```
具体细节需要参考工程里面的代码。


