//
//  DataHelper.swift
//  Tangent
//
//  Created by Casey on 4/21/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import Foundation
import CoreData

class DataHelper {
    
    func parseCSV(){
        
        // CSV
        let coefficientPath = NSBundle.mainBundle().pathForResource("absorption-coefficients", ofType: "csv")
        let pathString = try? String(contentsOfFile: coefficientPath!)
        let stringArray = pathString?.componentsSeparatedByString("\r")
        
        // ** Core Data **
        let moc = DataController().managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Coefficient", inManagedObjectContext: moc) as! Coefficient
        
        let delimiter = ","
        
        for line in stringArray! {
            var values = line.componentsSeparatedByString(delimiter)
            
            let materialType = values[0]
            let oneTwentyFiveHz = values[1]
            let twoFiftyHz = values[2]
            let fiveHundredHz = values[3]
            let onekHz = values[4]
            let twokHz = values[5]
            let fourkHz = values[6]
            
            entity.type = materialType
            print("adding: '\(materialType)'")
            entity.oneTwentyFiveHz = Double(oneTwentyFiveHz)
            print("adding: '\(oneTwentyFiveHz)'")
            entity.twoFiftyHz = Double(twoFiftyHz)
            print("adding: '\(twoFiftyHz)'")
            entity.fiveHundredHz = Double(fiveHundredHz)
            print("adding: '\(fiveHundredHz)'")
            entity.onekHz = Double(onekHz)
            print("adding: '\(onekHz)'")
            entity.twokHz = Double(twokHz)
            print("adding: '\(twokHz)'")
            entity.fourkHz = Double(fourkHz)
            print("adding: '\(fourkHz)'")
        }
    }
}