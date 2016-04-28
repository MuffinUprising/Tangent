//
//  Coefficient+CoreDataProperties.swift
//  Tangent
//
//  Created by Casey on 4/27/16.
//  Copyright © 2016 Casey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Coefficient {

    @NSManaged var type: String?
    @NSManaged var oneTwentyFiveHz: NSNumber?
    @NSManaged var twoFiftyHz: NSNumber?
    @NSManaged var fiveHundredHz: NSNumber?
    @NSManaged var onekHz: NSNumber?
    @NSManaged var twokHz: NSNumber?
    @NSManaged var fourkHz: NSNumber?

}
