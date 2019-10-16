//
//  MenuData+CoreDataProperties.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/25.
//  Copyright © 2019 chenfeng. All rights reserved.
//
//

import Foundation
import CoreData


extension MenuData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuData> {
        return NSFetchRequest<MenuData>(entityName: "MenuData")
    }

    @NSManaged public var title: String?
    @NSManaged public var controller: String?
    @NSManaged public var isNeedToDisplay: Bool
    @NSManaged public var isAllowedEditing: Bool

}
