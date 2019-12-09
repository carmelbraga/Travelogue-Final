//
//  Log+CoreDataProperties.swift
//  Travelogue
//
//  Created by Carmel Braga on 12/7/19.
//  Copyright © 2019 Carmel Braga. All rights reserved.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var title: String?
    @NSManaged public var entry: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var media: NSData?
    @NSManaged public var caption: String?
    @NSManaged public var trip: Trip?

}
