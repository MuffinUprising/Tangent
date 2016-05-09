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
    var windowAbsorption: [Double]?
//    var totalAbsorption: [Double] = []
    
    //list of absorption lists
    var allAbsorptionLists: [[Double]]?
    
    //total absorption values for room
    var sum125Hz: Double = 0.0
    var sum250Hz: Double = 0.0
    var sum500Hz: Double = 0.0
    var sum1kHz: Double = 0.0
    var sum2kHz: Double = 0.0
    var sum4kHz: Double = 0.0
    
    //list of total absorptions
    var allTotalAbsorptions: [Double] = []
    var allRt60Results: [Double] = []
    
    
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
    func getWallAbsorption (roomHeight: Double, roomWidth: Double, roomDepth: Double, roomVolume: Double, wallMaterial: String, doorArea: Double, windowArea: Double) -> [Double] {
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
                            print("fault- \(coefficient)")
                            
                            if let type = coefficient.valueForKey("type") {
                                print("Material type: \(type)")
                            }
                            self.wallMaterial = (coefficient as! Coefficient)
                            
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
                            let dArea = Double(doorArea)
                            let wArea = Double(windowArea)
                            let subtractedArea = dArea + wArea
                            print("subtracted area: \(subtractedArea)")
                            print("height: \(height), depth: \(depth), width: \(width), volume: \(volume)")
                            
                            //wall area1 = h * l
                            let wallArea1 = height * depth
                            //wall area2 = h * w
                            let wallArea2 = height * width
                            // total area = (area1 + area2) * 2
                            let totalArea = (((wallArea1 + wallArea2) * 2) - subtractedArea)
                            print("total area: \(totalArea)")
                            
                            //for coefficient in list..
                            for coefficient in wallCoefficients {
                                //coefficient = coefficient
                                let c = coefficient
                                print("wall coefficient: \(c)")
                                //absorption = total area * coefficient
                                let absorption = (totalArea * c)
                                print("wall absorption: \(absorption)")
                                let roundedAbsorption = round(absorption * 100) / 100
                                print("rounded wall absorption: \(roundedAbsorption)")
//                                //add to absorption list
                                wallAbsorption.append(roundedAbsorption)
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
                            let roundedAbsorption = round(absorption * 100) / 100
                            print("rounded floor absorption: \(roundedAbsorption)")
                            //add to absorption list
                            floorAbsorption.append(roundedAbsorption)
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
                            let roundedAbsorption = round(absorption * 100) / 100
                            print("rounded ceiling absorption: \(roundedAbsorption)")
                            //add to absorption list
                            ceilingAbsorption.append(roundedAbsorption)
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
                        self.doorArea = totalArea
                        
                        //for coefficient in list..
                        for coefficient in doorCoefficients {
                            //coefficient = coefficient
                            let c = coefficient
                            print("door coefficient: \(c)")
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            print("door absorption: \(absorption)")
                            let roundedAbsorption = round(absorption * 100) / 100
                            print("rounded door abosrption: \(roundedAbsorption)")
                            //add to absorption list
                            doorAbsorption.append(roundedAbsorption)
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
    func getWindowAbsorption(windowHeight: Double, windowWidth: Double, roomVolume: Double, windowMaterial: String) -> [Double] {
        //get coefficients list from db
        //managed object context
        let moc = DataController().managedObjectContext
        //fetch request
        let materialFetchRequest = NSFetchRequest(entityName: "Coefficient")
        //entity description
        let entityDescription = NSEntityDescription.entityForName("Coefficient", inManagedObjectContext: moc)
        materialFetchRequest.entity = entityDescription
        var windowAbsorption: [Double] = []
        
        //execute request
        do {
            let result = try moc.executeFetchRequest(materialFetchRequest)
            //            print("result: \(result)")
            print("window material: \(doorMaterial)")
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == windowMaterial {
                        //if material matches result, get variables
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.windowMaterial = (coefficient as! Coefficient)
                        print("results: \(coefficient)")
                        
                        let windowMatType = self.windowMaterial?.type
                        print("window material: \(windowMatType! as String)")
                        var windowCoefficients = [Double]()
                        let window125 = self.windowMaterial?.oneTwentyFiveHz as! Double
                        windowCoefficients.append(window125)
                        print("window125: \(window125)")
                        let window250 = self.windowMaterial?.twoFiftyHz as! Double
                        windowCoefficients.append(window250)
                        print("window250: \(window250)")
                        let window500 = self.windowMaterial?.fiveHundredHz as! Double
                        windowCoefficients.append(window500)
                        print("window500: \(window500)")
                        let window1k = self.windowMaterial?.onekHz as! Double
                        windowCoefficients.append(window1k)
                        print("window1k: \(window1k)")
                        let window2k = self.windowMaterial?.twokHz as! Double
                        windowCoefficients.append(window2k)
                        print("window2k: \(window2k)")
                        let window4k = self.windowMaterial?.fourkHz as! Double
                        windowCoefficients.append(window4k)
                        print("door4k: \(window4k)")
                        
                        //retrieve room w/d and volume
                        let height = Double(windowHeight)
                        let width = Double(windowWidth)
                        let volume = Double(roomVolume)
                        print("window height: \(height), width: \(width), room volume: \(volume)")
                        
                        //window area
                        let totalArea = width * height
                        print("total window area: \(totalArea)")
                        self.windowArea = totalArea
                        
                        //for coefficient in list..
                        for coefficient in windowCoefficients {
                            //coefficient = coefficient
                            let c = coefficient
                            print("window coefficient: \(c)")
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            print("window absorption: \(absorption)")
                            let roundedAbsorption = round(absorption * 100) / 100
                            print("rounded window rt60: \(roundedAbsorption)")
                            //add to absorption list
                            windowAbsorption.append(roundedAbsorption)
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
        for item in windowAbsorption {
            print("window absorption: \(item)")
        }
        self.windowAbsorption = windowAbsorption
        return windowAbsorption
    }
    
    //populate total freq absorptions
    func createAbsorptionList(){
        var all: [[Double]] = []
        if self.doorAbsorption != nil {
            all.append(self.doorAbsorption!)
            print("door absorption list: \(self.doorAbsorption)")
            print("door absorption values added to total list")
        }
        if self.windowAbsorption != nil {
            all.append(self.windowAbsorption!)
            print("window absorption list: \(self.windowAbsorption)")
            print("window absorption values added to total list")
        }
        if self.wallAbsorption != nil {
            all.append(self.wallAbsorption!)
            print("wall absorption list: \(self.wallAbsorption)")
            print("wall absorption values added to total list")
        }
        if self.floorAbsorption != nil {
            all.append(self.floorAbsorption!)
            print("floor absorption list: \(self.floorAbsorption)")
            print("floor absorption values added to total list")
        }
        if self.ceilingAbsorption != nil {
            all.append(self.ceilingAbsorption!)
            print("ceiling absorption list: \(self.ceilingAbsorption)")
            print("ceiling absorption values added to total list")
        }
        
        //set local variable
        self.allAbsorptionLists = all
        print("all absorption lists: \(self.allAbsorptionLists)")
        getAllEverything()
    }
    
    func getAllEverything() {
        compile125HzAbsorptions()
        compile250HzAbsorptions()
        compile500HzAbsorptions()
        compile1kHzAbsorptions()
        compile2kHzAbsorptions()
        compile4kHzAbsorptions()
    }
    
    // 125Hz
    func compile125HzAbsorptions() {
        let all = self.allAbsorptionLists
        print("all: \(all)")
        var sum125 = 0.0
        for list in all! {
            print("list: \(list)")
            let new125 = list[0]
            sum125 += new125
            print("new sum for 125Hz: \(sum125)")
        }
        self.sum125Hz = sum125
        print("125Hz total absorption: \(self.sum125Hz)")
    }
    
    // 250Hz
    func compile250HzAbsorptions() {
        let all = self.allAbsorptionLists
        var sum250 = 0.0
        for list in all! {
            let new250 = list[1]
            sum250 += new250
            print("new sum for 250Hz: \(sum250)")
        }
        self.sum250Hz = sum250
        print("250Hz total absorption: \(self.sum250Hz)")
        
    }
    
    // 500Hz
    func compile500HzAbsorptions() {
        let all = self.allAbsorptionLists
        var sum500 = 0.0
        for list in all! {
            let new500 = list[2]
            sum500 += new500
            print("new sum for 500Hz: \(sum500)")
        }
        self.sum500Hz = sum500
        print("500Hz total absorption: \(self.sum500Hz)")
    }
    
    // 1kHz
    func compile1kHzAbsorptions() {
        let all = self.allAbsorptionLists
        var sum1k = 0.0
        for list in all! {
            let new1k = list[3]
            sum1k += new1k
            print("new sum for 250Hz: \(sum1k)")
        }
        self.sum1kHz = sum1k
        print("1kHz total absorption: \(self.sum1kHz)")
    }
    
    // 2kHz
    func compile2kHzAbsorptions(){
        let all = self.allAbsorptionLists
        var sum2k = 0.0
        for list in all! {
            let new2k = list[4]
            sum2k += new2k
            print("new sum for 2kHz: \(sum2k)")
        }
        self.sum2kHz = sum2k
        print("2kHz total absorption: \(self.sum2kHz)")
    }
    
    // 4kHz
    func compile4kHzAbsorptions(){
        let all = self.allAbsorptionLists
        var sum4k = 0.0
        for list in all! {
            let new4k = list[5]
            sum4k += new4k
            print("new sum for 4kHz: \(sum4k)")
        }
        self.sum4kHz = sum4k
         print("4kHz total absorption: \(self.sum4kHz)")
    }
    
    func getAllAbsorptionLists() -> [[Double]]{
        return self.allAbsorptionLists!
    }
    
    func makeListOfTotalAbsorption() -> [Double] {
        self.allTotalAbsorptions.append(self.sum125Hz)
        self.allTotalAbsorptions.append(self.sum250Hz)
        self.allTotalAbsorptions.append(self.sum500Hz)
        self.allTotalAbsorptions.append(self.sum1kHz)
        self.allTotalAbsorptions.append(self.sum2kHz)
        self.allTotalAbsorptions.append(self.sum4kHz)
        if self.allAbsorptionLists != nil {
            self.allAbsorptionLists?.append(self.allTotalAbsorptions)
            for list in self.allAbsorptionLists! {
                print("absorption list from list of lists: \(list)")
            }
        }
        return self.allTotalAbsorptions
    }
    
    func getTotalRt60(roomVolume: Double) -> [Double] {
        var allRt60: [Double] = []
        let volume = roomVolume
        for total in self.allTotalAbsorptions {
            let rt60 = (0.049 * volume) / total
            print("rt60: \(rt60)")
            allRt60.append(rt60)
        }
        self.allRt60Results = allRt60
        print("all rt60 results: \(allRt60)")
        return allRt60
    }
}
