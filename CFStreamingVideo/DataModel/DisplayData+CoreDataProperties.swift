//
//  DisplayData+CoreDataProperties.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/24.
//  Copyright © 2019 chenfeng. All rights reserved.
//
//

import Foundation
import CoreData


extension DisplayData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DisplayData> {
        return NSFetchRequest<DisplayData>(entityName: "DisplayData")
    }

    @NSManaged public var title: String?
    @NSManaged public var controller: String?
    @NSManaged public var isAllowedEditing: Bool
    @NSManaged public var isNeedToDisplay: Bool

}
