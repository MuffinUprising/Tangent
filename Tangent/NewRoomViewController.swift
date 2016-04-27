//
//  RoomViewController.swift
//  Tangent
//
//  Created by Casey on 4/18/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit

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
    
    var roomName = ""
    
    //calculated variables
    var roomVolume =  Double("")
    var doorArea =  Double("")
    var windowArea = Double("")
    
    //pickerView variables
    var wallMaterial: String = ""
    var floorMaterial: String = ""
    var ceilingMaterial: String = ""
    var doorMaterial: String = ""
    var windowMaterial: String = ""
    
    // pickerView variables
    var selectedRoom: Int = -1
    var selectedFloorMat = 0
    var selectedWallMat: String = ""
    var selectedCeilingMat = 0
    var selectedDoorMat = 0
    
    var roomDBPath = NSString()
    
    var floorMaterialList = ["concrete on tile", "linoleum/vinyl tile on concrete", "wood on joists", "parquet on concrete", "carpet on concrete", "carpet on foam"]
    var wallMaterialList = ["Brick: unglazed", "Brick: unglazed & painted", "Concrete block - coarse", "Concrete block - painted", "Curtain: 10 oz/sq yd fabric molleton", "Curtain: 14 oz/sq yd fabric molleton", "Curtain: 18 oz/sq yd fabric molleton", "Fiberglass: 2\'\' 703 no airspace", "Fiberglass: spray 5\'\'", "Fiberglass: spray 1\'\'", "Fiberglass: 2\'\' rolls", "Foam: Sonex 2\'\'", "Foam: SDG 3\'\'", "Foam: SDG 4\'\'", "Foam: polyur. 1\'\'", "Foam: polyur. 1/2\'\'", "Glass: 1/4\'\' plate large", "Glass: window", "Plaster: smooth on tile/brick", "Plaster: rough on lath", "Marble/Tile", "Sheetrock 1/2\" 16\" on center", "Wood: 3/8\'\' plywood panel"]
    var ceilingMaterialList = ["Acoustic Tiles", "Acoustic Ceiling Tiles", "Fiberglass: 2\'\' 703 no airspace", "Fiberglass: spray 5\"", "Fiberglass: spray 1\"", "Fiberglass: 2\'\' rolls", "wood", "Foam: Sonex 2\'\'", "Foam: SDG 3\'\'", "Foam: SDG 4\'\'", "Foam: polyur. 1\'\'", "Foam: polyur. 1/2\'\'", "Plaster: smooth on tile/brick", "Plaster: rough on lath", "Sheetrock 1/2” 16\" on center", "Wood: 3/8\" plywood panel"]
    var doorMaterialList = ["wood", "Glass: 1/4\'\' plate large"]

    
    
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
        
        let fileMgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        
        roomDBPath = docsDir.stringByAppendingString("rooms.db")
        
        
        // check if db exists
        if !fileMgr.fileExistsAtPath(roomDBPath as String) {
            
            // create db
            let roomDB = FMDatabase(path: roomDBPath as String)
            print("Room Database Created")
            
            if roomDB == nil {
                print("Error: \(roomDB.lastErrorMessage()). Database is nil")
            }
            
            // prepare sql statement
            if roomDB.open() {
        
                let sql_statement = "CREATE TABLE IF NOT EXISTS ROOMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, HEIGHT REAL, WIDTH REAL, DEPTH REAL, VOLUME REAL, WINDOWH REAL, WINDOWW REAL, WINDOWA REAL, DOORH REAL, DOORW REAL, DOORA REAL, FLOORMAT TEXT, WALLMAT TEXT, CEILINGMAT TEXT, DOORMAT TEXT, WINDOWMAT TEXT)"
                
                if !roomDB.executeStatements(sql_statement) {
                    print("Error: \(roomDB.lastErrorMessage()). No execute statements")
                }
                //close db
                roomDB.close()
            } else {
                print("Error: \(roomDB.lastErrorMessage()). Database is closed.")
            }
        }
    }
    
    
    // Save room to DB
    @IBAction func saveRoomToDB(sender: UIButton) {
        let roomDB = FMDatabase(path: roomDBPath as String)
        
        //room name and dimensions
        let roomName = roomNameTextField.text!
        let roomWidth = Double(roomWidthTextField.text!)
        let roomHeight = Double(roomHeightTextField.text!)
        let roomDepth = Double(roomDepthTextField.text!)
        let roomVolume = (roomWidth! * roomHeight! * roomDepth!)
        let doorHeight = Double(doorHeightTextField.text!)
        let doorWidth = Double(doorWidthTextField.text!)
        let doorArea = (doorHeight! * doorWidth!)
        let windowHeight = Double(windowHeightTextField.text!)
        let windowWidth = Double(windowWidthTextField.text!)
        let windowArea = (windowHeight! * windowWidth!)
        
        //pickerView materials
        let floorMaterial = selectedFloorMat
        let wallMaterial = selectedWallMat
        let ceilingMaterial = selectedCeilingMat
        let doorMaterial = selectedDoorMat
        
        let windowMaterial = "Glass: window"
        
        if roomDB.open() {
            
            let insertSQL = "INSERT INTO ROOMS (NAME, HEIGHT, WIDTH, DEPTH, VOLUME, WINDOWH, WINDOWW, WINDOWA, DOORH, DOORW, DOORA, FLOORMAT, WALLMAT, CEILINGMAT, DOORMAT) VALUES ('\(roomName)', '\(roomHeight)', '\(roomWidth)', '\(roomDepth)', '\(roomVolume)', '\(windowHeight)', '\(windowWidth)', '\(windowArea)', '\(doorHeight)', '\(doorWidth)', '\(doorArea)', '\(floorMaterial)', '\(wallMaterial)', '\(ceilingMaterial)', '\(doorMaterial)', '\(windowMaterial)')"
            
            let result = roomDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                print("Error: \(roomDB.lastErrorMessage())")
            } else {
                roomNameTextField.text = ""
                roomWidthTextField.text = ""
                roomHeightTextField.text = ""
                roomDepthTextField.text = ""
                doorHeightTextField.text = ""
                doorWidthTextField.text = ""
                windowHeightTextField.text = ""
                windowWidthTextField.text = ""
                
                //TODO: reset pickerView
                wallMaterialPickerView.selectRow(0, inComponent: 0, animated: false)
                floorMaterialPickerView.selectRow(0, inComponent: 0, animated: false)
                ceilingMaterialPickerView.selectRow(0, inComponent: 0, animated: false)
                doorMaterialPickerView.selectRow(0, inComponent: 0, animated: false)
                
            }
            
        } else {
            print("Error: \(roomDB.lastErrorMessage())")
        }
    }
    
    //** PICKER VIEW **
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case wallMaterialPickerView:
            selectedWallMat = String(row.description)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
