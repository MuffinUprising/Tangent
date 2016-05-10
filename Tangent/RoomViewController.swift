//
//  RoomViewController.swift
//  Tangent
//
//  Created by Casey on 4/27/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable class RoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    
    //RT60 View
    @IBOutlet weak var rt60125HzLabel: UILabel!
    @IBOutlet weak var rt60250HzLabel: UILabel!
    @IBOutlet weak var rt60500HzLabel: UILabel!
    @IBOutlet weak var rt601kHzLabel: UILabel!
    @IBOutlet weak var rt602kHzLabel: UILabel!
    @IBOutlet weak var rt604kHzLabel: UILabel!
    
    let calc = Calculator()
    
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

    /** This is the current room */
    var selectedRoom: Room?
    
    /** List of modes based on the height of the room */
    var heightModes: [Double] = []
    /** List of modes based on the width of the room */
    var widthModes: [Double] = []
    /** List of modes based on the depth of the room */
    var depthModes: [Double] = []
    
    /** list of total absorption of wall surfaces at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var wallAbsorption: [Double] = []
    /** list of total absorption of floor surface at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var floorAbsorption: [Double] = []
    /** list of total absorption of ceiling surface at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var ceilingAbsorption: [Double] = []
    /** list of total absorption of door surface at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var doorAbsorption: [Double] = []
    /** list of total absorption of window surface at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var windowAbsorption: [Double] = []
    /** list of all surface lists at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var allAbsorptionLists: [[Double]] = []
    /** Sum of all absorption for all surfaces at all frequencies.
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var allAbsorptions: [Double] = []
    /** Reverb totals for the room at all frequencies (in seconds).
     125Hz, 250Hz, 500Hz, 1kHz, 2kHz, and 4kHz, in that order. */
    var allRt60Results: [Double] = []
    
    
    //future development
    @IBAction func getRecommendation(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*! Fetch Room objects from CoreData */
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
        //get wall reverb times
        self.wallAbsorption = calc.getWallAbsorption(self.roomHeight!, roomWidth: self.roomWidth!, roomDepth: self.roomDepth!, roomVolume: self.roomVolume!, wallMaterial: self.wallMaterial!, doorArea: self.doorArea!, windowArea: self.windowArea!)
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
        
        //create list of absorption coefficients
        calc.createAbsorptionList()
        
        //set local list of all absorption lists
        self.allAbsorptionLists = calc.getAllAbsorptionLists()
        print("allAbsorptionlists: \(allAbsorptionLists)")
        print("returned list of all rt60 values:")
        for list in self.allAbsorptionLists {
            print("rt60 list: \(list)")
        }
        //set list of calculated total absorption for each freq
        self.allAbsorptions =  calc.makeListOfTotalAbsorption()
        print("returned all total absorptions: \(self.allAbsorptions)")
        
        //set rt60 results list
        self.allRt60Results = calc.getTotalRt60(self.roomVolume!)
        print("returned final rt60 calculations: \(self.allRt60Results)")
        
        calc.makeListOfTotalAbsorption()
        
        //populate RT60 labels
        populateRT60Labels()
    }
    
    //** MODE VIEW **
    /*! show and hide help view */
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
    
    //*! ** ROOM DETAIL VIEW ** */
    func populateRoomDetailView() {
        
        // set local variables that are needed for processing
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
            self.doorHeight = (selectedRoom!.valueForKey("doorHeight") as! Double)
        }
        if (selectedRoom?.doorWidth) != nil {
            self.doorWidth = (selectedRoom!.valueForKey("doorWidth") as! Double)
        }
        if (selectedRoom?.doorMaterial) != nil {
            self.doorMaterial = (selectedRoom!.doorMaterial as String!)
        }
        if (selectedRoom?.windowMaterial) != nil {
            self.windowMaterial = (selectedRoom!.windowMaterial as String!)
        }
        if (selectedRoom?.windowHeight) != nil {
            self.windowHeight = (selectedRoom!.valueForKey("windowHeight") as! Double)
        }
        if (selectedRoom?.windowWidth) != nil {
            self.windowWidth = (selectedRoom!.valueForKey("windowWidth") as! Double)
        }
        if (selectedRoom?.doorArea) != nil {
            self.doorArea = (selectedRoom!.valueForKey("doorArea") as! Double)
        }
        if (selectedRoom?.windowArea) != nil {
            self.windowArea = (selectedRoom!.valueForKey("windowArea") as! Double)
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
    
    //** RT60 VIEW **
    func populateRT60Labels() {
        
        if self.allRt60Results.isEmpty {
            print("Oh noes ther rt60 results list is empty D:")
        } else {
            let oneTwoFiveHzRounded = round(self.allRt60Results[0] * 100) / 100
            let twoFiveZeroHzRounded = round(self.allRt60Results[1] * 100) / 100
            let fiveHundredHzRounded = round(self.allRt60Results[2] * 100) / 100
            let onekHzRounded = round(self.allRt60Results[3] * 100) / 100
            let twokHzRounded = round(self.allRt60Results[4] * 100) / 100
            let fourkHzRounded = round(self.allRt60Results[5] * 100) / 100
            
            rt60125HzLabel.text = String(oneTwoFiveHzRounded)
            rt60250HzLabel.text = String(twoFiveZeroHzRounded)
            rt60500HzLabel.text = String(fiveHundredHzRounded)
            rt601kHzLabel.text = String(onekHzRounded)
            rt602kHzLabel.text = String(twokHzRounded)
            rt604kHzLabel.text = String(fourkHzRounded)
        }
    }
    
    //TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allAbsorptionLists.count
    }
    //Populate cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AbsorptionCell", forIndexPath: indexPath) as! rt60TableViewCell
        let surfaceAbsorptions = self.allAbsorptionLists
        let surface = surfaceAbsorptions[indexPath.row]
        let surfaceNames = ["Wall", "Floor", "Ceiling", "Door", "Window", "Total"]
        cell.surfaceLabel.text = surfaceNames[indexPath.row]
        cell.oneTwoFiveHzLabel.text = String(surface[0])
        cell.twoFiveZeroHzLabel.text = String(surface[1])
        cell.fiveHundredHzLabel.text = String(surface[2])
        cell.onekHzLabel.text = String(surface[3])
        cell.twokHzLabel.text = String(surface[4])
        cell.fourkHzLabel.text = String(surface[5])
        
        return cell
    }
}
