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
    
    //absorption list
    var wallAbsorption: [Double]?
    var floorAbsorption: [Double]?
    var ceilingAbsorption: [Double]?
    var doorAbsorption: [Double]?
    
    
    //TODO: set up initializers
//    init() {
//        
//    }
    
    
    // ** MODES **
    //Height
    func determineHeightModes(roomHeight: Double) -> [Double]{
        heightModes = []
        heightModesRounded = []
        let height = Double(roomHeight)
//        print("Room height: \(roomHeight)")
        
        //fundamental mode
        // each mode after is the fundamental mode * multiplier
        let roomFundamental = Double(563.5 / height)
        heightModes!.append(roomFundamental)
//        print("height fundamental added: \(roomFundamental)")
        var currentMode = roomFundamental
        var modeMultiplier =  2.0
        
        //multipier counts up by one each time until it hits 300Hz
        while currentMode <= 300 {
            let mode: Double = (roomFundamental * modeMultiplier)
            heightModes!.append(mode)
//            print("height mode appended: \(mode)")
            modeMultiplier += 1
            currentMode = mode
        }
        print("Height modes calculated")
        for mode in self.heightModes! {
//            print("height mode: \(mode)")
            let roundedMode = round(mode)
//            print("rounded height mode: \(roundedMode)")
            heightModesRounded?.append(roundedMode)
            
        }
        return heightModesRounded!
        
    }
    
    //Width
    func determineWidthModes(roomWidth: Double) -> [Double] {
        widthModes = []
        widthModesRounded = []
        let width = Double(roomWidth)
//        print("Room width: \(roomWidth)")
        
        //fundamental mode
        // each mode after is the fundamental mode * multiplier
        let roomFundamental = Double(563.5 / width)
        widthModes!.append(roomFundamental)
//        print("width fundamental added: \(roomFundamental)")
        var currentMode = roomFundamental
        var modeMultiplier =  2.0
        
        //multipier counts up by one each time until it hits 300Hz
        while currentMode <= 300 {
            let mode: Double = (roomFundamental * modeMultiplier)
            widthModes!.append(mode)
//            print("width mode appended: \(mode)")
            modeMultiplier += 1
            currentMode = mode
        }
        print("Width modes calculated")
        for mode in self.widthModes! {
//            print("mode: \(mode)")
            let roundedMode = round(mode)
//            print("rounded width mode: \(roundedMode)")
            widthModesRounded?.append(roundedMode)
        }
        return widthModesRounded!
    }
    
    //Depth
    func determineDepthModes(roomDepth: Double) -> [Double]{
        depthModes = []
        depthModesRounded = []
        let depth = Double(roomDepth)
//        print("Room depth: \(roomDepth)")
        
        //fundamental mode
        // each mode after is the fundamental mode * multiplier
        let roomFundamental = Double(563.5 / depth)
        depthModes?.append(roomFundamental)
//        print("depth fundamental added: \(roomFundamental)")
        var currentMode = roomFundamental
        var modeMultiplier =  2.0
        
        //multipier counts up by one each time until it hits 300Hz
        while currentMode <= 300 {
            let mode: Double = (roomFundamental * modeMultiplier)
            depthModes!.append(mode)
//            print("depth mode appended: \(mode)")
            modeMultiplier += 1
            currentMode = mode
        }
        print("Depth modes calculated")
        for mode in self.depthModes! {
//            print("mode: \(mode)")
            let roundedMode = round(mode)
//            print("rounded depth mode: \(roundedMode)")
            depthModesRounded?.append(roundedMode)
        }
        return depthModesRounded!
    }
    
    
    // ** ABSORPTION **
    // WALL
    func getWallAbsorption (roomHeight: Double, roomWidth: Double, roomDepth: Double, roomVolume: Double, wallMaterial: String) -> [Double] {
        //get coefficients list from db
//        if let id = wallID {
//            print("received material id: \(id))")
            //managed object context
            let moc = DataController().managedObjectContext
            //fetch request
            let materialFetchRequest = NSFetchRequest(entityName: "Coefficient")
            //entity description
            let entityDescription = NSEntityDescription.entityForName("Coefficient", inManagedObjectContext: moc)
            materialFetchRequest.entity = entityDescription
            
            //execute request
            do {
                let result = try moc.executeFetchRequest(materialFetchRequest)
                print("result: \(result)")
                
                if (result.count > 0) {
                    for coefficient in result {
                        print("material: \(coefficient.type) 125Hz: \(coefficient.valueForKey("oneTwentyFiveHz")) 250Hz: \(coefficient.valueForKey("twoFiftyHz")) 500Hz: \(coefficient.valueForKey("fiveHundredHz")) 1kHz: \(coefficient.valueForKey("onekHz")) 2kHz: \(coefficient.valueForKey("twokHz")) 4kHz: \(coefficient.valueForKey("fourkHz"))")
                        if coefficient.type == wallMaterial {
                            print("fault- \(coefficient)")
                            
                            if let type = coefficient.valueForKey("type") {
                                print("Material type: \(type)")
                            }
                            self.wallMaterial = (coefficient as! Coefficient)
                            print("results: \(coefficient)")
                            
                            let wallMatType = self.wallMaterial?.type
                            print("wall material: \(wallMatType)")
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
                            
                            //starting frequency = 125
//                            var freq = 125
                            
                            //retrieve room h/w/d and area
                            let height = Double(roomHeight)
                            let depth = Double(roomDepth)
                            let width = Double(roomWidth)
                            let volume = Double(roomVolume)
                            print("height: \(height), depth: \(depth), width: \(width), volume\(volume)")
                            
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
                                print("coefficient: \(c)")
                                //absorption = total area * coefficient
                                let absorption = (totalArea * c)
                                print("absorption: \(absorption)")
                                //rt60 = (0.05 * volume) / absorption
                                let rt60 = (0.049 * volume) / absorption
                                print("rt60: \(rt60)")
                                //add to absorption list
                                wallAbsorption?.append(rt60)
                                //double frequency
//                                freq = freq * 2
                            }
                        }
                    }
                } else {
                    print("error loading coefficient database")
                    
                }
                
            } catch {
                let fetchError = error as NSError
                print(fetchError)

//            }
            
        }
        return wallAbsorption!
    }
    
    
    // FLOOR
    func getFloorAbsorption() {
    
    }
    
    // CEILING
    func getCeilingAbsorption() {
        
    }
    
    // DOOR
    func getDoorAbsorption() {
        
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
