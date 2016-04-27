//
//  Room.swift
//  Tangent
//
//  Created by Casey on 4/18/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import Foundation

class Room {
    
    var roomId : Int
    static var roomIndex = 1
    
    // Label
    var roomName : String?
    
    // MEASUREMENTS
        //Room
    var roomHeight : Double?
    var roomWidth : Double?
    var roomDepth : Double?
    var roomVolume : Double {
        return (roomHeight! * roomWidth! * roomDepth!)
    }
    
        // Window
    var windowHeight : Double?
    var windowWidth : Double?
    var windowArea : Double {
        return (windowWidth! * windowHeight!)
    }
        // Door
    var doorHeight : Double?
    var doorWidth : Double?
    var doorArea : Double {
        return (doorWidth! * doorHeight!)
    }
    
    // MATERIALS
    var floorMaterial : String?
    var wallMaterial : String?
    var ceilingMaterial : String?
    var doorMaterial : String?
    
    // MODES
    var roomModes : [Double?]
    
    //ABSORPTION
    var floorAbsorption : [Double?]
    var wallAbsorption : [Double?]
    var ceilingAbsorption : [Double?]
    var doorAbsorption : [Double?]
    var windowAbsorption : [Double?]
    var totalRoomAbsorption : [Double?]
    
    
    init() {
        roomId = Room.roomIndex
        Room.roomIndex += 1
        roomModes = []
        floorAbsorption = []
        wallAbsorption = []
        ceilingAbsorption = []
        doorAbsorption = []
        windowAbsorption = []
        totalRoomAbsorption = []
    }
    
    
    // FUNCTIONS
    func addMode(mode: Double) {
        roomModes.append(mode)
    }
    
    func addFloorAbs(sabin: Double) {
        floorAbsorption.append(sabin)
    }
    
    func addWallAbs(sabin: Double) {
        wallAbsorption.append(sabin)
    }
    
    func addCeilingAbs(sabin: Double) {
        ceilingAbsorption.append(sabin)
    }
    
    func addWindowAbs(sabin: Double) {
        windowAbsorption.append(sabin)
    }
    
    func addDoorAbs(sabin: Double) {
        doorAbsorption.append(sabin)
    }
    
    func addToTotalAbsorption(sabin: Double) {
        totalRoomAbsorption.append(sabin)
    }
}
