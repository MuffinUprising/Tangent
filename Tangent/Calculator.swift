//
//  Calculator.swift
//  Tangent
//
//  Created by Casey on 5/4/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import Foundation
import CoreData

class Calculator {
    
    var room: Room?
    //entered variables
    var roomHeight: Double?
    var roomDepth: Double?
    var roomWidth: Double?
    var doorHeight: Double?
    var doorWidth: Double?
    var windowHeight: Double?
    var windowWidth: Double?
    
    //calculated variables
    var roomVolume: Double?
    var doorArea: Double?
    var windowArea: Double?
    
    //pickerView variables
    var wallMaterial: Coefficient?
    var floorMaterial: Coefficient?
    var ceilingMaterial: Coefficient?
    var doorMaterial: Coefficient?
    var windowMaterial: Coefficient?
    
    //material ids
    var wallID: NSManagedObjectID?
    var floorID: NSManagedObjectID?
    var ceilingID: NSManagedObjectID?
    var doorID: NSManagedObjectID?
    
    //Modes
    var heightModes: [Double]?
    var heightModesRounded: [Double]?
    var widthModes: [Double]?
    var widthModesRounded: [Double]?
    var depthModes: [Double]?
    var depthModesRounded: [Double]?
    
    //RT60 values
    var wallRT60: [Double]?
    var floorRT60: [Double]?
    var ceilingRT60: [Double]?
    var doorRT60: [Double]?
    var windowRT60:[Double]?
    var totalRT60: [Double]?
    
    //material types
    var wallMatType: String?
    var floorMatType: String?
    var ceilingMatType: String?
    var doorMatType: String?
    
    //coefficient lists
    var wallCoefficients: [Double]?
    var floorCoefficients: [Double]?
    var ceilingCoefficients: [Double]?
    var doorCoeffients: [Double]?
    
    //absorption lists
    var wallAbsorption: [Double]?
    var floorAbsorption: [Double]?
    var ceilingAbsorption: [Double]?
    var doorAbsorption: [Double]?
    
    
    // ** MODES **
    //Height
    func determineHeightModes(roomHeight: Double) -> [Double]{
        heightModes = []
        heightModesRounded = []
        let height = Double(roomHeight)
        
        //fundamental mode
        // each mode after is the fundamental mode * multiplier
        let roomFundamental = Double(563.5 / height)
        heightModes!.append(roomFundamental)
        var currentMode = roomFundamental
        var modeMultiplier =  2.0
        
        //multipier counts up by one each time until it hits 300Hz
        while currentMode < (300 - roomFundamental) {
            let mode: Double = (roomFundamental * modeMultiplier)
            heightModes!.append(mode)
            modeMultiplier += 1
            currentMode = mode
        }
        print("Height modes calculated")
        for mode in self.heightModes! {
            let roundedMode = round(mode)
            heightModesRounded?.append(roundedMode)
            
        }
        return heightModesRounded!
        
    }
    
    //Width
    func determineWidthModes(roomWidth: Double) -> [Double] {
        widthModes = []
        widthModesRounded = []
        let width = Double(roomWidth)
        
        //fundamental mode
        // each mode after is the fundamental mode * multiplier
        let roomFundamental = Double(563.5 / width)
        widthModes!.append(roomFundamental)
        var currentMode = roomFundamental
        var modeMultiplier =  2.0
        
        //multipier counts up by one each time until it hits 300Hz
        while currentMode <= (300 - roomFundamental) {
            let mode: Double = (roomFundamental * modeMultiplier)
            widthModes!.append(mode)
            modeMultiplier += 1
            currentMode = mode
        }
        print("Width modes calculated")
        for mode in self.widthModes! {
            let roundedMode = round(mode)
            widthModesRounded?.append(roundedMode)
        }
        return widthModesRounded!
    }
    
    //Depth
    func determineDepthModes(roomDepth: Double) -> [Double]{
        depthModes = []
        depthModesRounded = []
        let depth = Double(roomDepth)
        
        //fundamental mode
        // each mode after is the fundamental mode * multiplier
        let roomFundamental = Double(563.5 / depth)
        depthModes?.append(roomFundamental)
        var currentMode = roomFundamental
        var modeMultiplier =  2.0
        
        //multipier counts up by one each time until it hits 300Hz
        while currentMode <= (300 - roomFundamental) {
            let mode: Double = (roomFundamental * modeMultiplier)
            depthModes!.append(mode)
            modeMultiplier += 1
            currentMode = mode
        }
        print("Depth modes calculated")
        for mode in self.depthModes! {
            let roundedMode = round(mode)
            depthModesRounded?.append(roundedMode)
        }
        return depthModesRounded!
    }
    
    
    // ** ABSORPTION **
    // WALL
    func getWallAbsorption (roomHeight: Double, roomWidth: Double, roomDepth: Double, roomVolume: Double, wallMaterial: String) -> [Double] {
        //get coefficients list from db
            //managed object context
            let moc = DataController().managedObjectContext
            //fetch request
            let materialFetchRequest = NSFetchRequest(entityName: "Coefficient")
            //entity description
            let entityDescription = NSEntityDescription.entityForName("Coefficient", inManagedObjectContext: moc)
            materialFetchRequest.entity = entityDescription
            var wallAbsorption: [Double] = []
        
            //execute request
            do {
                let result = try moc.executeFetchRequest(materialFetchRequest)
                print("result: \(result)")
                
                if (result.count > 0) {
                    for coefficient in result {
                        if coefficient.type == wallMaterial {
//                            print("fault- \(coefficient)")
                            
                            if let type = coefficient.valueForKey("type") {
                                print("Material type: \(type)")
                            }
                            self.wallMaterial = (coefficient as! Coefficient)
                            print("results: \(coefficient)")
                            
                            let wallMatType = self.wallMaterial?.type
                            print("wall material: \(wallMatType! as String)")
                            var wallCoefficients = [Double]()
                            let wall125 = self.wallMaterial?.oneTwentyFiveHz as! Double
                            wallCoefficients.append(wall125)
                            print("wall125: \(wall125)")
                            let wall250 = self.wallMaterial?.twoFiftyHz as! Double
                            wallCoefficients.append(wall250)
                            print("wall250: \(wall250)")
                            let wall500 = self.wallMaterial?.fiveHundredHz as! Double
                            wallCoefficients.append(wall500)
                            print("wall500: \(wall500)")
                            let wall1k = self.wallMaterial?.onekHz as! Double
                            wallCoefficients.append(wall1k)
                            print("wall1k: \(wall1k)")
                            let wall2k = self.wallMaterial?.twokHz as! Double
                            wallCoefficients.append(wall2k)
                            print("wall2k: \(wall2k)")
                            let wall4k = self.wallMaterial?.fourkHz as! Double
                            wallCoefficients.append(wall4k)
                            print("wall4k: \(wall4k)")
                            
                            //retrieve room h/w/d and area
                            let height = Double(roomHeight)
                            let depth = Double(roomDepth)
                            let width = Double(roomWidth)
                            let volume = Double(roomVolume)
                            print("height: \(height), depth: \(depth), width: \(width), volume: \(volume)")
                            
                            //wall area1 = h * l
                            let wallArea1 = height * depth
                            //wall area2 = h * w
                            let wallArea2 = height * width
                            // total area = (area1 + area2) * 2
                            let totalArea = (wallArea1 + wallArea2) * 2 as Double
                            print("total area: \(totalArea)")
                            
                            //for coefficient in list..
                            for coefficient in wallCoefficients {
                                //coefficient = coefficient
                                let c = coefficient
                                print("wall coefficient: \(c)")
                                //absorption = total area * coefficient
                                let absorption = (totalArea * c)
                                print("wall absorption: \(absorption)")
                                //rt60 = (0.05 * volume) / absorption
                                let rt60 = (0.049 * volume) / absorption
                                print("wall rt60: \(rt60)")
                                //add to absorption list
                                wallAbsorption.append(rt60)
                            }
                        } else {
                            continue
                        }
                    }
                } else {
                    print("error loading coefficient database")
                    
                }
                
            } catch {
                let fetchError = error as NSError
                print(fetchError)
        }
        for item in wallAbsorption {
            print("wall absorption: \(item)")
        }
        self.wallAbsorption = wallAbsorption
        return wallAbsorption
    }
    
    
    // FLOOR
    func getFloorAbsorption(roomWidth: Double, roomDepth: Double, roomVolume: Double, floorMaterial: String) -> [Double] {
        //get coefficients list from db
        //managed object context
        let moc = DataController().managedObjectContext
        //fetch request
        let materialFetchRequest = NSFetchRequest(entityName: "Coefficient")
        //entity description
        let entityDescription = NSEntityDescription.entityForName("Coefficient", inManagedObjectContext: moc)
        materialFetchRequest.entity = entityDescription
        var floorAbsorption: [Double] = []
        
        //execute request
        do {
            let result = try moc.executeFetchRequest(materialFetchRequest)
//            print("result: \(result)")
            print("floor material: \(floorMaterial)")
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == floorMaterial {
                        
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.floorMaterial = (coefficient as! Coefficient)
                        print("results: \(coefficient)")
                        
                        let floorMatType = self.floorMaterial?.type
                        print("floor material: \(floorMatType! as String)")
                        var floorCoefficients = [Double]()
                        let floor125 = self.floorMaterial?.oneTwentyFiveHz as! Double
                        floorCoefficients.append(floor125)
                        print("floor125: \(floor125)")
                        let floor250 = self.floorMaterial?.twoFiftyHz as! Double
                        floorCoefficients.append(floor250)
                        print("floor250: \(floor250)")
                        let floor500 = self.floorMaterial?.fiveHundredHz as! Double
                        floorCoefficients.append(floor500)
                        print("floor500: \(floor500)")
                        let floor1k = self.floorMaterial?.onekHz as! Double
                        floorCoefficients.append(floor1k)
                        print("floor1k: \(floor1k)")
                        let floor2k = self.floorMaterial?.twokHz as! Double
                        floorCoefficients.append(floor2k)
                        print("floor2k: \(floor2k)")
                        let floor4k = self.floorMaterial?.fourkHz as! Double
                        floorCoefficients.append(floor4k)
                        print("floor4k: \(floor4k)")
                        
                        //retrieve room w/d and volume
                        let depth = Double(roomDepth)
                        let width = Double(roomWidth)
                        let volume = Double(roomVolume)
                        print("depth: \(depth), width: \(width), volume: \(volume)")
                        
                        //floor area
                        let totalArea = width * depth
                    
                        print("total floor area: \(totalArea)")
                        
                        //for coefficient in list..
                        for coefficient in floorCoefficients {
                            //coefficient = coefficient
                            let c = coefficient
                            print("floor coefficient: \(c)")
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            print("floor absorption: \(absorption)")
                            //rt60 = (0.05 * volume) / absorption
                            let rt60 = (0.049 * volume) / absorption
                            print("floor rt60: \(rt60)")
                            //add to absorption list
                            floorAbsorption.append(rt60)
                        }
                    } else {
                        continue
                    }
                }
            } else {
                print("error loading coefficient database")
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        for item in floorAbsorption {
            print("floor absorption: \(item)")
        }
        self.floorAbsorption = floorAbsorption
        return floorAbsorption
    }
    
    // CEILING
    func getCeilingAbsorption(roomWidth: Double, roomDepth: Double, roomVolume: Double, ceilingMaterial: String) -> [Double] {
        //get coefficients list from db
        //managed object context
        let moc = DataController().managedObjectContext
        //fetch request
        let materialFetchRequest = NSFetchRequest(entityName: "Coefficient")
        //entity description
        let entityDescription = NSEntityDescription.entityForName("Coefficient", inManagedObjectContext: moc)
        materialFetchRequest.entity = entityDescription
        var ceilingAbsorption: [Double] = []
        
        //execute request
        do {
            let result = try moc.executeFetchRequest(materialFetchRequest)
            //            print("result: \(result)")
            print("ceiling material: \(ceilingMaterial)")
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == ceilingMaterial {
                        
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.ceilingMaterial = (coefficient as! Coefficient)
                        print("results: \(coefficient)")
                        
                        let ceilingMatType = self.ceilingMaterial?.type
                        print("ceiling material: \(ceilingMatType! as String)")
                        var ceilingCoefficients = [Double]()
                        let ceiling125 = self.ceilingMaterial?.oneTwentyFiveHz as! Double
                        ceilingCoefficients.append(ceiling125)
                        print("ceiling125: \(ceiling125)")
                        let ceiling250 = self.ceilingMaterial?.twoFiftyHz as! Double
                        ceilingCoefficients.append(ceiling250)
                        print("ceiling250: \(ceiling250)")
                        let ceiling500 = self.ceilingMaterial?.fiveHundredHz as! Double
                        ceilingCoefficients.append(ceiling500)
                        print("ceiling500: \(ceiling500)")
                        let ceiling1k = self.ceilingMaterial?.onekHz as! Double
                        ceilingCoefficients.append(ceiling1k)
                        print("ceiling1k: \(ceiling1k)")
                        let ceiling2k = self.ceilingMaterial?.twokHz as! Double
                        ceilingCoefficients.append(ceiling2k)
                        print("ceiling2k: \(ceiling2k)")
                        let ceiling4k = self.ceilingMaterial?.fourkHz as! Double
                        ceilingCoefficients.append(ceiling4k)
                        print("ceiling4k: \(ceiling4k)")
                        
                        //retrieve room w/d and volume
                        let depth = Double(roomDepth)
                        let width = Double(roomWidth)
                        let volume = Double(roomVolume)
                        print("depth: \(depth), width: \(width), volume: \(volume)")
                        
                        //ceiling area
                        let totalArea = width * depth
                        
                        print("total ceiling area: \(totalArea)")
                        
                        //for coefficient in list..
                        for coefficient in ceilingCoefficients {
                            //coefficient = coefficient
                            let c = coefficient
                            print("ceiling coefficient: \(c)")
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            print("ceiling absorption: \(absorption)")
                            //rt60 = (0.05 * volume) / absorption
                            let rt60 = (0.049 * volume) / absorption
                            print("ceiling rt60: \(rt60)")
                            //add to absorption list
                            ceilingAbsorption.append(rt60)
                        }
                    } else {
                        continue
                    }
                }
            } else {
                print("error loading coefficient database")
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        for item in ceilingAbsorption {
            print("ceiling absorption: \(item)")
        }
        self.ceilingAbsorption = ceilingAbsorption
        return ceilingAbsorption

    }
    
    // DOOR
    func getDoorAbsorption(doorHeight: Double, doorWidth: Double, roomVolume: Double, doorMaterial: String) -> [Double] {
        //get coefficients list from db
        //managed object context
        let moc = DataController().managedObjectContext
        //fetch request
        let materialFetchRequest = NSFetchRequest(entityName: "Coefficient")
        //entity description
        let entityDescription = NSEntityDescription.entityForName("Coefficient", inManagedObjectContext: moc)
        materialFetchRequest.entity = entityDescription
        var doorAbsorption: [Double] = []
        
        //execute request
        do {
            let result = try moc.executeFetchRequest(materialFetchRequest)
            //            print("result: \(result)")
            print("door material: \(doorMaterial)")
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == doorMaterial {
                        
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.doorMaterial = (coefficient as! Coefficient)
                        print("results: \(coefficient)")
                        
                        let doorMatType = self.doorMaterial?.type
                        print("door material: \(doorMatType! as String)")
                        var doorCoefficients = [Double]()
                        let door125 = self.doorMaterial?.oneTwentyFiveHz as! Double
                        doorCoefficients.append(door125)
                        print("door125: \(door125)")
                        let door250 = self.doorMaterial?.twoFiftyHz as! Double
                        doorCoefficients.append(door250)
                        print("door250: \(door250)")
                        let door500 = self.doorMaterial?.fiveHundredHz as! Double
                        doorCoefficients.append(door500)
                        print("door500: \(door500)")
                        let door1k = self.doorMaterial?.onekHz as! Double
                        doorCoefficients.append(door1k)
                        print("door1k: \(door1k)")
                        let door2k = self.doorMaterial?.twokHz as! Double
                        doorCoefficients.append(door2k)
                        print("door2k: \(door2k)")
                        let door4k = self.doorMaterial?.fourkHz as! Double
                        doorCoefficients.append(door4k)
                        print("door4k: \(door4k)")
                        
                        //retrieve room w/d and volume
                        let height = Double(doorHeight)
                        let width = Double(doorWidth)
                        let volume = Double(roomVolume)
                        print("door height: \(height), width: \(width), room volume: \(volume)")
                        
                        //door area
                        let totalArea = width * height
                        
                        print("total door area: \(totalArea)")
                        
                        //for coefficient in list..
                        for coefficient in doorCoefficients {
                            //coefficient = coefficient
                            let c = coefficient
                            print("door coefficient: \(c)")
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            print("door absorption: \(absorption)")
                            //rt60 = (0.05 * volume) / absorption
                            let rt60 = (0.049 * volume) / absorption
                            print("door rt60: \(rt60)")
                            //add to absorption list
                            doorAbsorption.append(rt60)
                        }
                    } else {
                        continue
                    }
                }
            } else {
                print("error loading coefficient database")
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        for item in doorAbsorption {
            print("door absorption: \(item)")
        }
        self.doorAbsorption = doorAbsorption
        return doorAbsorption
        
    }
    
    // WINDOW
    func getWindowAbsorption() {
        
    }
    
    // 125Hz
    func get125HzAbsorption() {
        //let 125sum = 125HzList.reduce(0, combine: +)
    }
    
    // 250Hz
    func get250HzAbsorption() {
        
    }
    
    // 500Hz
    func get500HzAbsorption() {
        
    }
    
    // 1kHz
    func get1kHzAbsorption() {
        
    }
    
    // 2kHz
    func get2kHzAbsorption (){
        
    }
    // 4kHz
    func get4kHzAbsorption (){
        
    }
}
