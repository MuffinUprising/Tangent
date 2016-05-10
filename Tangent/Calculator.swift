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
    
    //Calculated variables
    /** Volume of the current room returned from CoreData */
    var roomVolume: Double?
    /** Door Area returned from CoreData */
    var doorArea: Double?
    /** Window Area returned from CoreData */
    var windowArea: Double?
    
    //Material variables
    /** Wall material returned from CoreData */
    var wallMaterial: Coefficient?
    /** floorMaterial returned from CoreData */
    var floorMaterial: Coefficient?
    /** Ceiling aterial returned from CoreData */
    var ceilingMaterial: Coefficient?
    /** Door Material returned from CoreData */
    var doorMaterial: Coefficient?
    /** Window Material returned from CoreData for consistency, even though it is always glass. */
    var windowMaterial: Coefficient?
    
    //Material ids - not really used
    var wallID: NSManagedObjectID?
    var floorID: NSManagedObjectID?
    var ceilingID: NSManagedObjectID?
    var doorID: NSManagedObjectID?
    
    //Modes
    /** Array of height modes
     returned from determineHeightModes */
    var heightModes: [Double]?
    /** Array of rounded height modes
     returned from determineHeightModes */
    var heightModesRounded: [Double]?
    /** Array of width modes
     returned from determineHeightModes */
    var widthModes: [Double]?
    /** Array of rounded width modes
     returned from determineHeightModes */
    var widthModesRounded: [Double]?
    /** Array of depth modes
     returned from determineHeightModes */
    var depthModes: [Double]?
    /** Array of rounded depth modes
     returned from determineHeightModes */
    var depthModesRounded: [Double]?
    
    //Coefficient lists
    /** Array of wall coefficients returned from CoreData */
    var wallCoefficients: [Double]?
    /** Array of floor coefficients returned from CoreData */
    var floorCoefficients: [Double]?
    /** Array of ceiling coefficients returned from CoreData */
    var ceilingCoefficients: [Double]?
    /** Array of door coefficients returned from CoreData */
    var doorCoeffients: [Double]?
    
    //absorption lists
    /** Array of total absorption of wall surfaces at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var wallAbsorption: [Double]?
    /** Array of total absorption of floor surface at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var floorAbsorption: [Double]?
    /** Array of total absorption of ceiling surface at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var ceilingAbsorption: [Double]?
    /** Array of total absorption of door surface(s) at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var doorAbsorption: [Double]?
    /** Array of total absorption of window surface(s) at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var windowAbsorption: [Double]?
    /** Array of total absorption of all surfaces at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var totalAbsorption: [Double] = []
    
    /** Array of all absorption arrays for all surfaces at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var allAbsorptionLists: [[Double]]?
    
    //total absorption values for room
    /** Sum of absorption of all surfaces at 125Hz */
    var sum125Hz: Double = 0.0
    /** Sum of absorption of all surfaces at 250Hz */
    var sum250Hz: Double = 0.0
    /** Sum of absorption of all surfaces at 500Hz */
    var sum500Hz: Double = 0.0
    /** Sum of absorption of all surfaces at 1kHz */
    var sum1kHz: Double = 0.0
    /** Sum of absorption of all surfaces at 2kHz */
    var sum2kHz: Double = 0.0
    /** Sum of absorption of all surfaces at 4kHz */
    var sum4kHz: Double = 0.0
    
    //list of total absorptions
    /** Array of all sums at all frequencies 
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var allTotalAbsorptions: [Double] = []
    /** Array of reverb times at all freqencies for the room 
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var allRt60Results: [Double] = []
    
    
    // ** MODES **
    /** 
     Determines resonant frequencies of the room based on height
     
     1. Determine fundamental 563.5 / height
     2. Append mode to heightModes Array
     3. Update currentMode
     4. Update mulitplier
     5. 2nd mode = fundamental * 2
     6. 3rd mode = fundamental * 3
     7. Continue until currentMode = 300 - fundamental
     8. Round mode to whole number
     
     :returns: heightModesRounded
     */
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
    /**
     Determines resonant frequencies of the room based on width
     
     1. Determine fundamental 563.5 / width
     2. Append mode to widthModes Array
     3. Update currentMode
     4. Update mulitplier
     5. 2nd mode = fundamental * 2
     6. 3rd mode = fundamental * 3
     7. Continue until currentMode = 300 - fundamental
     8. Round mode to whole number
     
     :returns:  widthModesRounded
     */
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
    /**
     Determines resonant frequencies of the room based on depth
     
     1. Determine fundamental 563.5 / depth
     2. Append mode to depthModes Array
     3. Update currentMode
     4. Update mulitplier
     5. 2nd mode = fundamental * 2
     6. 3rd mode = fundamental * 3
     7. Continue until currentMode = 300 - fundamental
     8. Round mode to whole number
     
     :returns: depthModesRounded
     */
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
    /** 
     Determines wall absorption at all six frequencies.
     
     :param:   roomHeight: Double, roomWidth:Double, roomDepth: Double, roomVolume: Double, wallMaterial: String, doorArea: Double, windowArea: Double
     
     1. Make call to CoreData to return wall material
     2. Set local variables from material
     3. Set local variables Room's height, width, depth, volume, doorArea, windowArea, and subtracted area (from doors and windows)
     4. Determine wall area and subtract doors and windows
     5. Loop through list of coefficients and determine absorption (wall area * coefficient)
     6. Append absorption to wallAbsorption for each frequency
     
     :returns: wallAbsortion[Double]
     
     */
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
                if (result.count > 0) {
                    for coefficient in result {
                        if coefficient.type == wallMaterial {
                            
                            if let type = coefficient.valueForKey("type") {
                                print("Material type: \(type)")
                            }
                            self.wallMaterial = (coefficient as! Coefficient)
                            
                            let wallMatType = self.wallMaterial?.type
                            print("wall material: \(wallMatType! as String)")
                            var wallCoefficients = [Double]()
                            let wall125 = self.wallMaterial?.oneTwentyFiveHz as! Double
                            wallCoefficients.append(wall125)
                            let wall250 = self.wallMaterial?.twoFiftyHz as! Double
                            wallCoefficients.append(wall250)
                            let wall500 = self.wallMaterial?.fiveHundredHz as! Double
                            wallCoefficients.append(wall500)
                            let wall1k = self.wallMaterial?.onekHz as! Double
                            wallCoefficients.append(wall1k)
                            let wall2k = self.wallMaterial?.twokHz as! Double
                            wallCoefficients.append(wall2k)
                            let wall4k = self.wallMaterial?.fourkHz as! Double
                            wallCoefficients.append(wall4k)

                            
                            //retrieve room h/w/d and area
                            let height = Double(roomHeight)
                            let depth = Double(roomDepth)
                            let width = Double(roomWidth)
                            let dArea = Double(doorArea)
                            let wArea = Double(windowArea)
                            let subtractedArea = dArea + wArea
                            
                            //wall area1 = h * l
                            let wallArea1 = height * depth
                            //wall area2 = h * w
                            let wallArea2 = height * width
                            // total area = (area1 + area2) * 2
                            let totalArea = (((wallArea1 + wallArea2) * 2) - subtractedArea)
                            
                            //for coefficient in list..
                            for coefficient in wallCoefficients {
                                //coefficient = coefficient
                                let c = coefficient
                                //absorption = total area * coefficient
                                let absorption = (totalArea * c)
                                let roundedAbsorption = round(absorption * 100) / 100
                                //add to absorption list
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
        self.wallAbsorption = wallAbsorption
        return wallAbsorption
    }
    
    
    // FLOOR
    /** 
     Determines floor absorption at all six frequencies.
     
     :param:   roomWidth:Double, roomDepth: Double, roomVolume: Double, floorMaterial: String
     
     1. Make call to CoreData to return floor material
     2. Set local variables from material
     3. Set local variables Room's width, depth, and volume
     4. Determine floor area
     5. Loop through list of coefficients and determine absorption (floor area * coefficient)
     6. Append absorption to floorAbsorption for each frequency
     
     :returns: floorAbsortion[Double]
     
     */
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
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == floorMaterial {
                        
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.floorMaterial = (coefficient as! Coefficient)
                        
                        let floorMatType = self.floorMaterial?.type
                        print("floor material: \(floorMatType! as String)")
                        var floorCoefficients = [Double]()
                        let floor125 = self.floorMaterial?.oneTwentyFiveHz as! Double
                        floorCoefficients.append(floor125)
                        let floor250 = self.floorMaterial?.twoFiftyHz as! Double
                        floorCoefficients.append(floor250)
                        let floor500 = self.floorMaterial?.fiveHundredHz as! Double
                        floorCoefficients.append(floor500)
                        let floor1k = self.floorMaterial?.onekHz as! Double
                        floorCoefficients.append(floor1k)
                        let floor2k = self.floorMaterial?.twokHz as! Double
                        floorCoefficients.append(floor2k)
                        let floor4k = self.floorMaterial?.fourkHz as! Double
                        floorCoefficients.append(floor4k)
                        
                        //retrieve room w/d and volume
                        let depth = Double(roomDepth)
                        let width = Double(roomWidth)
                        
                        //floor area
                        let totalArea = width * depth
                        
                        //for coefficient in list..
                        for coefficient in floorCoefficients {
                            
                            let c = coefficient
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            let roundedAbsorption = round(absorption * 100) / 100
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

        self.floorAbsorption = floorAbsorption
        return floorAbsorption
    }
    
    // CEILING
    /** 
     Determines ceiling absorption at all six frequencies.
     
     :param:   roomWidth:Double, roomDepth: Double, roomVolume: Double, ceilingMaterial: String
     
     1. Make call to CoreData to return ceiling material
     2. Set local variables from material
     3. Set local variables Room's width, depth, and volume
     4. Determine ceiling area
     5. Loop through list of coefficients and determine absorption (ceiling area * coefficient)
     6. Append absorption to ceilingAbsorption for each frequency
     
     :returns: ceilingAbsortion[Double]
     
     */
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
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == ceilingMaterial {
                        
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.ceilingMaterial = (coefficient as! Coefficient)
                        
                        let ceilingMatType = self.ceilingMaterial?.type
                        print("ceiling material: \(ceilingMatType! as String)")
                        var ceilingCoefficients = [Double]()
                        let ceiling125 = self.ceilingMaterial?.oneTwentyFiveHz as! Double
                        ceilingCoefficients.append(ceiling125)
                        let ceiling250 = self.ceilingMaterial?.twoFiftyHz as! Double
                        ceilingCoefficients.append(ceiling250)
                        let ceiling500 = self.ceilingMaterial?.fiveHundredHz as! Double
                        ceilingCoefficients.append(ceiling500)
                        let ceiling1k = self.ceilingMaterial?.onekHz as! Double
                        ceilingCoefficients.append(ceiling1k)
                        let ceiling2k = self.ceilingMaterial?.twokHz as! Double
                        ceilingCoefficients.append(ceiling2k)
                        let ceiling4k = self.ceilingMaterial?.fourkHz as! Double
                        ceilingCoefficients.append(ceiling4k)
                        
                        //retrieve room w/d and volume
                        let depth = Double(roomDepth)
                        let width = Double(roomWidth)
                        
                        //ceiling area
                        let totalArea = width * depth
                        
                        //for coefficient in list..
                        for coefficient in ceilingCoefficients {
                            let c = coefficient
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            let roundedAbsorption = round(absorption * 100) / 100
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
        
        self.ceilingAbsorption = ceilingAbsorption
        return ceilingAbsorption
    }
    
    // DOOR
    /** 
     Determines door absorption at all six frequencies.
     
     :param:   doorHeight:Double, doorWidth: Double, roomVolume: Double, doorMaterial: String
     
     1. Make call to CoreData to return door material
     2. Set local variables from material
     3. Set local variables Room's  door width, door height, and volume
     4. Determine door area
     5. Loop through list of coefficients and determine absorption (door area * coefficient)
     6. Append absorption to doorAbsorption for each frequency
     
     :returns: doorAbsortion[Double]
     
     */
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
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == doorMaterial {
                        
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.doorMaterial = (coefficient as! Coefficient)
                        
                        let doorMatType = self.doorMaterial?.type
                        print("door material: \(doorMatType! as String)")
                        var doorCoefficients = [Double]()
                        let door125 = self.doorMaterial?.oneTwentyFiveHz as! Double
                        doorCoefficients.append(door125)
                        let door250 = self.doorMaterial?.twoFiftyHz as! Double
                        doorCoefficients.append(door250)
                        let door500 = self.doorMaterial?.fiveHundredHz as! Double
                        doorCoefficients.append(door500)
                        let door1k = self.doorMaterial?.onekHz as! Double
                        doorCoefficients.append(door1k)
                        let door2k = self.doorMaterial?.twokHz as! Double
                        doorCoefficients.append(door2k)
                        let door4k = self.doorMaterial?.fourkHz as! Double
                        doorCoefficients.append(door4k)
                        
                        //retrieve room w/d and volume
                        let height = Double(doorHeight)
                        let width = Double(doorWidth)
                        
                        //door area
                        let totalArea = width * height
                        
                        self.doorArea = totalArea
                        
                        //for coefficient in list..
                        for coefficient in doorCoefficients {
                    
                            let c = coefficient
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            let roundedAbsorption = round(absorption * 100) / 100
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
        
        self.doorAbsorption = doorAbsorption
        return doorAbsorption
    }
    
    // WINDOW
    /** 
     Determines window absorption at all six frequencies.
     
     :param:   windowHeight:Double, windowWidth: Double, roomVolume: Double, windowMaterial: String
     
     1. Make call to CoreData to return window material
     2. Set local variables from material
     3. Set local variables Room's window width, window height, and volume
     4. Determine window area
     5. Loop through list of coefficients and determine absorption (window area * coefficient)
     6. Append absorption to windowAbsorption for each frequency
     
     :returns: windowAbsortion[Double]
     
     */
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
            if (result.count > 0) {
                for coefficient in result {
                    if coefficient.type == windowMaterial {
                        //if material matches result, get variables
                        if let type = coefficient.valueForKey("type") {
                            print("Material type: \(type)")
                        }
                        self.windowMaterial = (coefficient as! Coefficient)
                        
                        let windowMatType = self.windowMaterial?.type
                        print("window material: \(windowMatType! as String)")
                        var windowCoefficients = [Double]()
                        let window125 = self.windowMaterial?.oneTwentyFiveHz as! Double
                        windowCoefficients.append(window125)
                        let window250 = self.windowMaterial?.twoFiftyHz as! Double
                        windowCoefficients.append(window250)
                        let window500 = self.windowMaterial?.fiveHundredHz as! Double
                        windowCoefficients.append(window500)
                        let window1k = self.windowMaterial?.onekHz as! Double
                        windowCoefficients.append(window1k)
                        let window2k = self.windowMaterial?.twokHz as! Double
                        windowCoefficients.append(window2k)
                        let window4k = self.windowMaterial?.fourkHz as! Double
                        windowCoefficients.append(window4k)
                        
                        //retrieve room w/d and volume
                        let height = Double(windowHeight)
                        let width = Double(windowWidth)
                        
                        //window area
                        let totalArea = width * height
                        self.windowArea = totalArea
                        
                        //for coefficient in list..
                        for coefficient in windowCoefficients {
                            
                            let c = coefficient
                            //absorption = total area * coefficient
                            let absorption = (totalArea * c)
                            let roundedAbsorption = round(absorption * 100) / 100
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

        self.windowAbsorption = windowAbsorption
        return windowAbsorption
    }
    
    //populate total freq absorptions
    /** 
     Adds absortion Arrays to allAbsorptionLists
     
     :returns: allAbsorptionLists
     */
    func createAbsorptionList(){
        var all: [[Double]] = []
        if self.doorAbsorption != nil {
            all.append(self.doorAbsorption!)
        }
        if self.windowAbsorption != nil {
            all.append(self.windowAbsorption!)
        }
        if self.wallAbsorption != nil {
            all.append(self.wallAbsorption!)
        }
        if self.floorAbsorption != nil {
            all.append(self.floorAbsorption!)
        }
        if self.ceilingAbsorption != nil {
            all.append(self.ceilingAbsorption!)
        }
        
        //set local variable
        self.allAbsorptionLists = all
        getAllEverything()
    }
    
    /** 
     Calls all the methods that compile abosorption values by frequency 
     */
    func getAllEverything() {
        compile125HzAbsorptions()
        compile250HzAbsorptions()
        compile500HzAbsorptions()
        compile1kHzAbsorptions()
        compile2kHzAbsorptions()
        compile4kHzAbsorptions()
    }
    
    // 125Hz
    /** 
     Iterates through the Arrays in allAbsorptionLists and adds values to new lists based on frequency
     
     1. Set all to self.allAbsoprtionLists
     2. Set sum on 125Hz absorption to 0
     3. Iterate through all lists
     4. Set new125 to element [0] of list
     5. Add new125 with sum125
     6. Repeat for all surface lists
     
     :returns: sum125Hz
     */
    func compile125HzAbsorptions() {
        let all = self.allAbsorptionLists
        var sum125 = 0.0
        for list in all! {
            let new125 = list[0]
            sum125 += new125
        }
        self.sum125Hz = sum125
    }
    
    // 250Hz
    /** 
     Iterates through the Arrays in allAbsorptionLists and adds values to new lists based on frequency
     
     1. Set all to self.allAbsoprtionLists
     2. Set sum on 250Hz absorption to 0
     3. Iterate through all lists
     4. Set new250 to element [1] of list
     5. Add new250 with sum250
     6. Repeat for all surface lists
     
     :returns: sum250Hz
     */
    func compile250HzAbsorptions() {
        let all = self.allAbsorptionLists
        var sum250 = 0.0
        for list in all! {
            let new250 = list[1]
            sum250 += new250
        }
        self.sum250Hz = sum250
    }
    
    // 500Hz
    /** 
     Iterates through the Arrays in allAbsorptionLists and adds values to new lists based on frequency
     
     1. Set all to self.allAbsoprtionLists
     2. Set sum on 500Hz absorption to 0
     3. Iterate through all lists
     4. Set new500 to element [2] of list
     5. Add new500 with sum500
     6. Repeat for all surface lists
     
     :returns: sum500Hz
     */
    func compile500HzAbsorptions() {
        let all = self.allAbsorptionLists
        var sum500 = 0.0
        for list in all! {
            let new500 = list[2]
            sum500 += new500
        }
        self.sum500Hz = sum500
    }
    
    // 1kHz
    /** 
     Iterates through the Arrays in allAbsorptionLists and adds values to new lists based on frequency
     
     1. Set all to self.allAbsoprtionLists
     2. Set sum on 1kHz absorption to 0
     3. Iterate through all lists
     4. Set new1k to element [3] of list
     5. Add new1k with sum1k
     6. Repeat for all surface lists
     
     :returns: sum1kHz
     */
    func compile1kHzAbsorptions() {
        let all = self.allAbsorptionLists
        var sum1k = 0.0
        for list in all! {
            let new1k = list[3]
            sum1k += new1k
        }
        self.sum1kHz = sum1k
    }
    
    // 2kHz
    /** 
     Iterates through the Arrays in allAbsorptionLists and adds values to new lists based on frequency
     
     1. Set all to self.allAbsoprtionLists
     2. Set sum on 2kHz absorption to 0
     3. Iterate through all lists
     4. Set new2k to element [4] of list
     5. Add new2k with sum2k
     6. Repeat for all surface lists
     
     :returns: sum2kHz
     */
    func compile2kHzAbsorptions(){
        let all = self.allAbsorptionLists
        var sum2k = 0.0
        for list in all! {
            let new2k = list[4]
            sum2k += new2k
        }
        self.sum2kHz = sum2k
    }
    
    // 4kHz
    /** 
     Iterates through the Arrays in allAbsorptionLists and adds values to new lists based on frequency
     
     1. Set all to self.allAbsoprtionLists
     2. Set sum on 4kHz absorption to 0
     3. Iterate through all lists
     4. Set new4k to element [5] of list
     5. Add new4k with sum4k
     6. Repeat for all surface lists
     
     :returns: sum4kHz
     */
    func compile4kHzAbsorptions(){
        let all = self.allAbsorptionLists
        var sum4k = 0.0
        for list in all! {
            let new4k = list[5]
            sum4k += new4k
        }
        self.sum4kHz = sum4k
    }
    
    /** 
     This method returns allAbsorptionList.
     To call it, simply use calc.getAllAbsorptionLists()
     
     :returns: allAbsorptionLists[Double]
     */
    func getAllAbsorptionLists() -> [[Double]]{
        return self.allAbsorptionLists!
    }
    
    /** 
     Compiles a list of absorptions for all frequencies.
     
     :returns: allTotalAbsorptions[Double]
     */
    func makeListOfTotalAbsorption() -> [Double] {
        self.allTotalAbsorptions.append(self.sum125Hz)
        self.allTotalAbsorptions.append(self.sum250Hz)
        self.allTotalAbsorptions.append(self.sum500Hz)
        self.allTotalAbsorptions.append(self.sum1kHz)
        self.allTotalAbsorptions.append(self.sum2kHz)
        self.allTotalAbsorptions.append(self.sum4kHz)
        if self.allAbsorptionLists != nil {
            self.allAbsorptionLists?.append(self.allTotalAbsorptions)
            
            print("Total Absorptions: \(self.allTotalAbsorptions)")
        }
        return self.allTotalAbsorptions
    }
    
    /** 
     
     Determines reverb times for all frequencies.
     :param: roomVolume: Double
     
     1. Set list for all reverb times
     2. Set volume to roomVolume
     3. Iterate through allTotalAbsorptions
     4. Set rt60 to (0.049 * volume) / total
     5. Append to allRt60
     6. Set local variable for allRt60
     
     :returns: allRt60
     */
    func getTotalRt60(roomVolume: Double) -> [Double] {
        var allRt60: [Double] = []
        let volume = roomVolume
        for total in self.allTotalAbsorptions {
            let rt60 = (0.049 * volume) / total
            allRt60.append(rt60)
        }
        self.allRt60Results = allRt60
        return allRt60
    }
}
