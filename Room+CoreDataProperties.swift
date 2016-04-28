//
//  Room+CoreDataProperties.swift
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

extension Room {

    @NSManaged var roomName: String?
    @NSManaged var roomHeight: NSNumber?
    @NSManaged var roomWidth: NSNumber?
    @NSManaged var roomDepth: NSNumber?
    @NSManaged var roomVolume: NSNumber?
    @NSManaged var windowHeight: NSNumber?
    @NSManaged var windowWidth: NSNumber?
    @NSManaged var windowArea: NSNumber?
    @NSManaged var doorHeight: NSNumber?
    @NSManaged var doorWidth: NSNumber?
    @NSManaged var doorArea: NSNumber?
    @NSManaged var floorMaterial: String?
    @NSManaged var wallMaterial: String?
    @NSManaged var ceilingMaterial: String?
    @NSManaged var doorMaterial: String?
    @NSManaged var windowMaterial: String?

}
