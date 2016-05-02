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
    
    var newRoom: Room?
    
    //room variables
    var roomName: String = ""
    var roomHeight: Double = 0.0
    var roomWidth: Double = 0.0
    var roomDepth: Double = 0.0
    var doorHeight: Double = 0.0
    var doorWidth: Double = 0.0
    var windowHeight: Double = 0.0
    var windowWidth: Double = 0.0
    
    //calculated variables
    var roomVolume: Double = 0.0
    var doorArea: Double = 0.0
    var windowArea: Double = 0.0
    
    //pickerView variables
    var wallMaterial: String = ""
    var floorMaterial: String = ""
    var ceilingMaterial: String = ""
    var doorMaterial: String = ""
    var windowMaterial: String = ""
    
    // pickerView variables
    var selectedRoom: Int = -1
    var selectedFloorMat = 0
    var selectedWallMat = 0
    var selectedCeilingMat = 0
    var selectedDoorMat = 0
    
    var roomDBPath = NSString()
    
    var floorMaterialList = ["concrete on tile", "linoleum/vinyl tile on concrete", "wood on joists", "parquet on concrete", "carpet on concrete", "carpet on foam"]
    var wallMaterialList = ["Brick: unglazed", "Brick: unglazed & painted", "Concrete block - coarse", "Concrete block - painted", "Curtain: 10 oz/sq yd fabric molleton", "Curtain: 14 oz/sq yd fabric molleton", "Curtain: 18 oz/sq yd fabric molleton", "Fiberglass: 2\'\' 703 no airspace", "Fiberglass: spray 5\'\'", "Fiberglass: spray 1\'\'", "Fiberglass: 2\'\' rolls", "Foam: Sonex 2\'\'", "Foam: SDG 3\'\'", "Foam: SDG 4\'\'", "Foam: polyur. 1\'\'", "Foam: polyur. 1/2\'\'", "Glass: 1/4\'\' plate large", "Glass: window", "Plaster: smooth on tile/brick", "Plaster: rough on lath", "Marble/Tile", "Sheetrock 1/2\" 16\" on center", "Wood: 3/8\'\' plywood panel"]
    var ceilingMaterialList = ["Acoustic Tiles", "Acoustic Ceiling Tiles", "Fiberglass: 2\'\' 703 no airspace", "Fiberglass: spray 5\"", "Fiberglass: spray 1\"", "Fiberglass: 2\'\' rolls", "wood", "Foam: Sonex 2\'\'", "Foam: SDG 3\'\'", "Foam: SDG 4\'\'", "Foam: polyur. 1\'\'", "Foam: polyur. 1/2\'\'", "Plaster: smooth on tile/brick", "Plaster: rough on lath", "Sheetrock 1/2” 16\" on center", "Wood: 3/8\" plywood panel"]
    var doorMaterialList = ["wood", "Glass: 1/4\'\' plate large"]
    
    @IBAction func saveRoom(sender: AnyObject) {
        
        //create an instance of managedObjectContext
        let moc = DataController().managedObjectContext
        
        //select entity and context to be targeted
        let newRoom = NSEntityDescription.insertNewObjectForEntityForName("Room", inManagedObjectContext: moc) as! Room
        
        //room name and dimensions
        self.roomName = roomNameTextField.text!
        self.roomWidth = Double(roomWidthTextField.text!)!
        self.roomHeight = Double(roomHeightTextField.text!)!
        self.roomDepth = Double(roomDepthTextField.text!)!
        self.roomVolume = (roomWidth * roomHeight * roomDepth)
        self.doorHeight = Double(doorHeightTextField.text!)!
        self.doorWidth = Double(doorWidthTextField.text!)!
        self.doorArea = Double(doorHeight * doorWidth)
        self.windowHeight = Double(windowHeightTextField.text!)!
        self.windowWidth = Double(windowWidthTextField.text!)!
        self.windowArea = Double(windowHeight * windowWidth)
        
        //pickerView materials
        
        let floorMaterial = floorMaterialList[selectedFloorMat]
        let wallMaterial = wallMaterialList[selectedWallMat]
        let ceilingMaterial = ceilingMaterialList[selectedCeilingMat]
        let doorMaterial = doorMaterialList[selectedDoorMat]
        let windowMaterial = "Glass: window"
        
        newRoom.setValue(roomName, forKey: "roomName")
        newRoom.setValue(roomWidth, forKey: "roomWidth")
        newRoom.setValue(roomHeight, forKey: "roomHeight")
        newRoom.setValue(roomDepth, forKey: "roomDepth")
        newRoom.setValue(roomVolume, forKey: "roomVolume")
        newRoom.setValue(doorHeight, forKey: "doorHeight")
        newRoom.setValue(doorWidth, forKey: "doorWidth")
        newRoom.setValue(doorArea, forKey: "doorArea")
        newRoom.setValue(windowWidth, forKey: "windowWidth")
        newRoom.setValue(windowHeight, forKey: "windowHeight")
        newRoom.setValue(windowArea, forKey: "windowArea")

        newRoom.setValue(floorMaterial, forKey: "floorMaterial")
        newRoom.setValue(wallMaterial, forKey: "wallMaterial")
        newRoom.setValue(ceilingMaterial, forKey: "ceilingMaterial")
        newRoom.setValue(doorMaterial, forKey: "doorMaterial")
        newRoom.setValue(windowMaterial, forKey: "windowMaterial")
        
        performSegueWithIdentifier("saveRoom", sender: nil)
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
        self.roomName = roomNameTextField.text!
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
    
    
    // default functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let newView = segue.destinationViewController as? RoomViewController
        newView?.roomHeightLabel.text = String(newRoom?.roomHeight!)
        
    }
}
