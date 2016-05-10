//
//  RoomViewController.swift
//  Tangent
//
//  Created by Casey on 4/18/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit
import CoreData

class NewRoomViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //UI Outlets
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomHeightTextField: UITextField!
    @IBOutlet weak var roomWidthTextField: UITextField!
    @IBOutlet weak var roomDepthTextField: UITextField!
    
    @IBOutlet weak var doorHeightTextField: UITextField!
    @IBOutlet weak var doorWidthTextField: UITextField!
    
    @IBOutlet weak var windowHeightTextField: UITextField!
    @IBOutlet weak var windowWidthTextField: UITextField!
    
    @IBOutlet weak var wallMaterialPickerView: UIPickerView!
    @IBOutlet weak var floorMaterialPickerView: UIPickerView!
    @IBOutlet weak var ceilingMaterialPickerView: UIPickerView!
    @IBOutlet weak var doorMaterialPickerView: UIPickerView!
    
    //Room ans sentName variables
    var newRoom: Room?
    var sentName: String?
    
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
    
    // pickerView default selections
    var selectedRoom: Int = -1
    var selectedFloorMat = 0
    var selectedWallMat = 0
    var selectedCeilingMat = 0
    var selectedDoorMat = 0
    
    //CoreData path for Room
    var roomDBPath = NSString()
    
    //material lists for picker views
    var floorMaterialList = ["Concrete on tile", "Linoleum/vinyl tile on concrete", "Wood on joists", "Parquet on concrete", "Carpet on concrete", "Carpet on foam"]
    var wallMaterialList = ["Brick: unglazed", "Brick: unglazed & painted", "Concrete block - coarse", "Concrete block - painted", "Curtain: 10 oz/sq yd fabric molleton", "Curtain: 14 oz/sq yd fabric molleton", "Curtain: 18 oz/sq yd fabric molleton", "Fiberglass: 2\'\' 703 no airspace", "Fiberglass: spray 5\'\'", "Fiberglass: spray 1\'\'", "Fiberglass: 2\'\' rolls", "Foam: Sonex 2\'\'", "Foam: SDG 3\'\'", "Foam: SDG 4\'\'", "Foam: polyur. 1\'\'", "Foam: polyur. 1/2\'\'", "Glass: 1/4\'\' plate large", "Glass: window", "Plaster: smooth on tile/brick", "Plaster: rough on lath", "Marble/Tile", "Sheetrock 1/2\" 16\" on center", "Wood: 3/8\'\' plywood panel"]
    var ceilingMaterialList = ["Acoustic Tiles", "Acoustic Ceiling Tiles", "Fiberglass: 2\'\' 703 no airspace", "Fiberglass: spray 5\"", "Fiberglass: spray 1\"", "Fiberglass: 2\'\' rolls", "Wood", "Foam: Sonex 2\'\'", "Foam: SDG 3\'\'", "Foam: SDG 4\'\'", "Foam: polyur. 1\'\'", "Foam: polyur. 1/2\'\'", "Plaster: smooth on tile/brick", "Plaster: rough on lath", "Sheetrock 1/2” 16\" on center", "Wood: 3/8\" plywood panel"]
    var doorMaterialList = ["Wood", "Glass: 1/4\'\' plate large"]
    
    /** Saves new room to CoreData */
    func saveRoom() {
        
        //create an instance of managedObjectContext
        let moc = DataController().managedObjectContext
        
        //select entity and context to be targeted
        newRoom = NSEntityDescription.insertNewObjectForEntityForName("Room", inManagedObjectContext: moc) as? Room
        
        //room name and dimensions
        let roomName = roomNameTextField.text!
        let roomWidth = Double(roomWidthTextField.text!)!
        let roomHeight = Double(roomHeightTextField.text!)!
        let roomDepth = Double(roomDepthTextField.text!)!
        let roomVolume = (roomWidth * roomHeight * roomDepth)
        let doorHeight = Double(doorHeightTextField.text!)!
        let doorWidth = Double(doorWidthTextField.text!)!
        let doorArea = Double(doorHeight * doorWidth)
        let windowHeight = Double(windowHeightTextField.text!)!
        let windowWidth = Double(windowWidthTextField.text!)!
        let windowArea = Double(windowHeight * windowWidth)
        
        //set materials to pickerView materials
        let floorMaterial = floorMaterialList[selectedFloorMat]
        let wallMaterial = wallMaterialList[selectedWallMat]
        let ceilingMaterial = ceilingMaterialList[selectedCeilingMat]
        let doorMaterial = doorMaterialList[selectedDoorMat]
        let windowMaterial = "Glass: window"
        
        //set values for new room
        newRoom!.setValue(roomName, forKey: "roomName")
        newRoom!.setValue(roomWidth, forKey: "roomWidth")
        newRoom!.setValue(roomHeight, forKey: "roomHeight")
        newRoom!.setValue(roomDepth, forKey: "roomDepth")
        newRoom!.setValue(roomVolume, forKey: "roomVolume")
        newRoom!.setValue(doorHeight, forKey: "doorHeight")
        newRoom!.setValue(doorWidth, forKey: "doorWidth")
        newRoom!.setValue(doorArea, forKey: "doorArea")
        newRoom!.setValue(windowWidth, forKey: "windowWidth")
        newRoom!.setValue(windowHeight, forKey: "windowHeight")
        newRoom!.setValue(windowArea, forKey: "windowArea")
        newRoom!.setValue(floorMaterial, forKey: "floorMaterial")
        newRoom!.setValue(wallMaterial, forKey: "wallMaterial")
        newRoom!.setValue(ceilingMaterial, forKey: "ceilingMaterial")
        newRoom!.setValue(doorMaterial, forKey: "doorMaterial")
        newRoom!.setValue(windowMaterial, forKey: "windowMaterial")
        
        do {
            try moc.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        roomID = (newRoom?.objectID)
        sentName = (newRoom?.roomName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickerView delegates and datasources
        self.floorMaterialPickerView.delegate = self
        self.floorMaterialPickerView.dataSource = self
        self.wallMaterialPickerView.delegate = self
        self.wallMaterialPickerView.dataSource = self
        self.ceilingMaterialPickerView.delegate = self
        self.ceilingMaterialPickerView.dataSource = self
        self.doorMaterialPickerView.delegate = self
        self.doorMaterialPickerView.dataSource = self
        
    }
    
    //** PICKER VIEW **
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case wallMaterialPickerView:
            selectedWallMat = row
            break
        case floorMaterialPickerView:
            selectedFloorMat = row
            break
        case ceilingMaterialPickerView:
            selectedCeilingMat = row
            break
        case doorMaterialPickerView:
            selectedDoorMat = row
        default:
            break
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == wallMaterialPickerView {
            return wallMaterialList.count
        }
        else if pickerView == floorMaterialPickerView {
            return floorMaterialList.count
        }
        else if pickerView == ceilingMaterialPickerView {
            return ceilingMaterialList.count
        }
        else if pickerView == doorMaterialPickerView {
            return doorMaterialList.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case wallMaterialPickerView:
            return wallMaterialList[row]
        case floorMaterialPickerView:
            return floorMaterialList[row]
        case ceilingMaterialPickerView:
            return ceilingMaterialList[row]
        case doorMaterialPickerView:
            return doorMaterialList[row]
        default:
            return ""
        } 
    }
    
    
    // boilerplate functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        saveRoom()
        let newView = segue.destinationViewController as? RoomViewController
        newView!.roomID = self.roomID
        newView!.roomName = self.sentName
    }
}
