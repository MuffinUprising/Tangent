//
//  RoomViewController.swift
//  Tangent
//
//  Created by Casey on 4/27/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable class RoomViewController: UIViewController {
    //Room Properties View
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomHeightLabel: UILabel!
    @IBOutlet weak var roomWidthLabel: UILabel!
    @IBOutlet weak var roomDepthLabel: UILabel!
    @IBOutlet weak var roomVolumeLabel: UILabel!
    @IBOutlet weak var wallMaterialLabel: UILabel!
    @IBOutlet weak var floorMaterialLabel: UILabel!
    @IBOutlet weak var ceilingMaterialLabel: UILabel!
    @IBOutlet weak var doorAreaLabel: UILabel!
    @IBOutlet weak var doorMaterialLabel: UILabel!
    @IBOutlet weak var windowAreaLabel: UILabel!
    
    //Mode View
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var modeGraphView: UIView!
    @IBOutlet weak var modeHelpView: UIView!
    
    @IBInspectable var isModeHelpViewShowing = false
    
    @IBOutlet weak var heightModeLabel: UILabel!
    @IBOutlet weak var widthModeLabel: UILabel!
    @IBOutlet weak var depthModeLabel: UILabel!
    
    let calc = Calculator()
    
    //rt60 result view
    
    
    //recommendation view
    @IBOutlet weak var rt60Input: UITextField!
    
    //view instances
    @IBOutlet weak var roomInfoView: UIView!
    
    
    //room variables
    var roomID: NSManagedObjectID?
    var roomName: String?
    var roomHeight: Double?
    var roomWidth: Double?
    var roomDepth: Double?
    var doorHeight: Double?
    var doorWidth: Double?
    var windowHeight: Double?
    var windowWidth: Double?
    
    //calculated variables
    var roomVolume: Double?
    var doorArea: Double?
    var windowArea: Double?
    
    //pickerView variables
    var wallMaterial: String?
    var floorMaterial: String?
    var ceilingMaterial: String?
    var doorMaterial: String?
    var windowMaterial: String?

    var selectedRoom: Room?
    
    var heightModes: [Double] = []
    var widthModes: [Double] = []
    var depthModes: [Double] = []
    
    var wallAbsorption: [Double] = []
    var floorAbsorption: [Double] = []
    var ceilingAbsorption: [Double] = []
    var doorAbsorption: [Double] = []
    var windowAbsorption: [Double] = []
    
    @IBAction func getRecommendation(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //managed object context
        let moc = DataController().managedObjectContext
        //initialize fetch request
        let roomFetchRequest = NSFetchRequest(entityName: "Room")
        //initialize entity description
        let entityDescription = NSEntityDescription.entityForName("Room", inManagedObjectContext: moc)
        //configure fetch request
        roomFetchRequest.entity = entityDescription
        
        //execute request
        do {
            let result = try moc.executeFetchRequest(roomFetchRequest)
            
            if (result.count > 0) {
                
                for room in result {
                    if room.roomName == roomName {
                        selectedRoom = (room as! Room)
                        populateRoomDetailView()
                    }
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        //**MODES**
        //get height modes and display them in view
        self.heightModes = calc.determineHeightModes(self.roomHeight!)
        for mode in self.heightModes {
            print("returned height mode: \(mode)")
        }
        self.heightModeLabel.text = String(self.heightModes)
        
        //get width modes and display them
        self.widthModes = calc.determineWidthModes(self.roomWidth!)
        for mode in self.widthModes {
            print("returned width mode: \(mode)")
        }
        self.widthModeLabel.text = String(self.widthModes)
        
        //get depth modes and display them
        self.depthModes = calc.determineDepthModes(self.roomDepth!)
        for mode in self.depthModes {
            print("returned depth mode: \(mode)")
        }
        self.depthModeLabel.text = String(self.depthModes)
        
        //**RT60**
        //get wall reverb times
        self.wallAbsorption = calc.getWallAbsorption(self.roomHeight!, roomWidth: self.roomWidth!, roomDepth: self.roomDepth!, roomVolume: self.roomVolume!, wallMaterial: self.wallMaterial!)
        print("returned wall absorption:")
        for rt60 in wallAbsorption {
            print("rt60: \(rt60)")
        }
        //get floor absorption
        self.floorAbsorption = calc.getFloorAbsorption(self.roomWidth! , roomDepth: self.roomDepth!, roomVolume: self.roomVolume!, floorMaterial: self.floorMaterial!)
        print("returned floor absorption:")
        for rt60 in floorAbsorption {
            print("rt60: \(rt60)")
        }
        //get ceiling absorption
        self.ceilingAbsorption = calc.getCeilingAbsorption(self.roomWidth!, roomDepth: self.roomDepth!, roomVolume: self.roomVolume!, ceilingMaterial: self.ceilingMaterial!)
        print("returned ceiling absorption:")
        for rt60 in ceilingAbsorption {
            print("rt60: \(rt60)")
        }
        //get door absorption
        self.doorAbsorption = calc.getDoorAbsorption(self.doorHeight!, doorWidth: self.doorWidth!, roomVolume: self.roomVolume!, doorMaterial: self.doorMaterial!)
        print("returned door absorption:")
        for rt60 in doorAbsorption {
            print("rt60: \(rt60)")
        }
        //get window absorption
        self.windowAbsorption = calc.getWindowAbsorption(self.windowHeight!, windowWidth: self.windowWidth!, roomVolume: self.roomVolume!, windowMaterial: self.windowMaterial!)
        for rt60 in windowAbsorption {
            print("rt60: \(rt60)")
        }
        
    }
    
    //** MODE VIEW **
    // show and hide help view
    @IBAction func modeViewTap(gesture: UITapGestureRecognizer?) {
        if (isModeHelpViewShowing) {
            // hide help
            UIView.transitionFromView(modeHelpView, toView: modeGraphView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromTop, completion: nil)
        } else {
            //show help
            UIView.transitionFromView(modeGraphView, toView: modeHelpView, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromBottom, completion: nil)
        }
        isModeHelpViewShowing = !isModeHelpViewShowing
    }
    
    func populateRoomDetailView() {
        
        // set local variables for processing
        if (selectedRoom?.roomHeight) != nil {
            self.roomHeight = (selectedRoom!.valueForKey("roomHeight") as! Double)
        }
        if (selectedRoom?.roomWidth) != nil {
            self.roomWidth = (selectedRoom!.valueForKey("roomWidth") as! Double)
        }
        if (selectedRoom?.roomDepth) != nil {
            self.roomDepth = (selectedRoom!.valueForKey("roomDepth") as! Double)
        }
        if (selectedRoom?.roomVolume) != nil {
            self.roomVolume = (selectedRoom!.valueForKey("roomVolume") as! Double)
        }
        if (selectedRoom?.wallMaterial) != nil {
            self.wallMaterial = (selectedRoom!.wallMaterial as String!)
        }
        if (selectedRoom?.floorMaterial) != nil {
            self.floorMaterial = (selectedRoom!.floorMaterial as String!)
        }
        if (selectedRoom?.ceilingMaterial) != nil {
            self.ceilingMaterial = (selectedRoom!.ceilingMaterial as String!)
        }
        if (selectedRoom?.doorHeight) != nil {
            self.doorHeight = (selectedRoom!.doorHeight as! Double)
        }
        if (selectedRoom?.doorWidth) != nil {
            self.doorWidth = (selectedRoom!.doorWidth as! Double)
        }
        if (selectedRoom?.doorMaterial) != nil {
            self.doorMaterial = (selectedRoom!.doorMaterial as String!)
        }
        if (selectedRoom?.windowMaterial) != nil {
            self.windowMaterial = (selectedRoom!.windowMaterial as String!)
        }
        if (selectedRoom?.windowHeight) != nil {
            self.windowHeight = (selectedRoom!.windowHeight as! Double)
        }
        if (selectedRoom?.windowWidth) != nil {
            self.windowWidth = (selectedRoom!.windowWidth as! Double)
        }
        

        //take attributes from room and display in view
        roomNameLabel.text = roomName
        roomHeightLabel.text = String(roomHeight!)
        roomDepthLabel.text = String(roomDepth!)
        roomWidthLabel.text = String(selectedRoom!.valueForKey("roomWidth")!)
        roomVolumeLabel.text = String(selectedRoom!.valueForKey("roomVolume")!)
        wallMaterialLabel.text = String(selectedRoom!.valueForKey("wallMaterial")!)
        floorMaterialLabel.text = String(selectedRoom!.valueForKey("floorMaterial")!)
        ceilingMaterialLabel.text = String(selectedRoom!.valueForKey("ceilingMaterial")!)
        doorAreaLabel.text = String(selectedRoom!.valueForKey("doorArea")!)
        doorMaterialLabel.text = String(selectedRoom!.valueForKey("doorMaterial")!)
        windowAreaLabel.text = String(selectedRoom!.valueForKey("windowArea")!)
    }
}
