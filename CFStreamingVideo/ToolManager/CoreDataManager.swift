//
//  CoreDataManager.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/29.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit


class CoreDataManager: NSObject {
    
    ///获取上下文
    static var viewContext = APPDELEGATE.persistentContainer.viewContext
    
    ///Return - 实体模型
    class func getEntityAndInsertNewObjectWith(entityName: String) -> NSManagedObject {
        
        let model = NSEntityDescription.insertNewObject(forEntityName: entityName, into: APPDELEGATE.persistentContainer.viewContext)
        
        return model
    }
    
    ///保存
    class func saveContext() {
        APPDELEGATE.saveContext()
    }
    
    
}
