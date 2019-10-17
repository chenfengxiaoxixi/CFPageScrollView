//
//  DataSourceFile.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/18.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import Foundation

// MARK: - 首页数据
//isAllowedEditing - 该页面是否允许增加或删除，isNeedToDisplay - 是否需要显示页面
func getDataSource() -> Array<Dictionary<String, Any>> {
    
    return [["title":"精选","controller":"ChildController1","isAllowedEditing":false,"isNeedToDisplay":true],
    ["title":"70年","controller":"ChildController2","isAllowedEditing":false,"isNeedToDisplay":true],
    ["title":"花花物语","controller":"ChildController3","isAllowedEditing":false,"isNeedToDisplay":true],
    ["title":"热点","controller":"ChildController4","isAllowedEditing":true,"isNeedToDisplay":true],
    ["title":"剧集","controller":"ChildController5","isAllowedEditing":true,"isNeedToDisplay":true],
    ["title":"电影","controller":"ChildController6","isAllowedEditing":true,"isNeedToDisplay":true],
    ["title":"综艺","controller":"ChildController7","isAllowedEditing":true,"isNeedToDisplay":true],
    ["title":"高清","controller":"ChildController8","isAllowedEditing":true,"isNeedToDisplay":false],
    ["title":"网络","controller":"ChildController9","isAllowedEditing":true,"isNeedToDisplay":false],
    ["title":"游戏","controller":"ChildController10","isAllowedEditing":true,"isNeedToDisplay":false]]
}

func getDisplayDataSource() -> Array<Dictionary<String, Any>> {
    
    return [["title":"精选","controller":"ChildController1","isAllowedEditing":false,"isNeedToDisplay":true],
    ["title":"70年","controller":"ChildController2","isAllowedEditing":false,"isNeedToDisplay":true],
    ["title":"花花物语","controller":"ChildController3","isAllowedEditing":false,"isNeedToDisplay":true],
    ["title":"热点","controller":"ChildController4","isAllowedEditing":true,"isNeedToDisplay":true],
    ["title":"剧集","controller":"ChildController5","isAllowedEditing":true,"isNeedToDisplay":true],
    ["title":"电影","controller":"ChildController6","isAllowedEditing":true,"isNeedToDisplay":true],
    ["title":"综艺","controller":"ChildController7","isAllowedEditing":true,"isNeedToDisplay":true]]
    
}

// MARK: - 热点数据

func getHotspotDataSource() -> Array<Dictionary<String, Any>> {
    
    return [["title":"关注","controller":"HotspotChildController1","isNeedToDisplay":true],
    ["title":"推荐","controller":"ChildController2","isNeedToDisplay":true],
    ["title":"小视频","controller":"ChildController3","isNeedToDisplay":true],
    ["title":"少儿","controller":"ChildController4","isNeedToDisplay":true],
    ["title":"体育","controller":"ChildController5","isNeedToDisplay":true],
    ["title":"搞笑","controller":"ChildController6","isNeedToDisplay":true],
    ["title":"NBA","controller":"ChildController7","isNeedToDisplay":true]]
    
}
