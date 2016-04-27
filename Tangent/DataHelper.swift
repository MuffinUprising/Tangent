//
//  DataHelper.swift
//  Tangent
//
//  Created by Casey on 4/21/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import Foundation

class DataHelper {
    
    func parseCSV(){
        
        let coefficientPath = NSBundle.mainBundle().pathForResource("absorption-coefficients", ofType: "csv")
        let pathString = try? String(contentsOfFile: coefficientPath!)
        let stringArray = pathString?.componentsSeparatedByString("\r")
        
        let delimiter = ","
        var materials: [(materialType:String, oneTwentyFiveHz:String, twoFiftyHz:String, fiveHundredHz:String, onekHz:String, twokHz:String, fourkHz:String)]?
        
        for line in stringArray! {
            var values = line.componentsSeparatedByString(delimiter)
            
            let item = (materialType: values[0], oneTwentyFiveHz: values[1], twoFiftyHz: values[2], fiveHundredHz: values[3], onekHz: values[4], twokHz: values[5], fourkHz: values[6])
                print(item)
                materials?.append(item)
        }
        if materials != nil {
            for entry in materials! {
                print(String(entry))
            }
        }
        
    }
}