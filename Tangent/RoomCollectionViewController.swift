//
//  RoomCollectionViewController.swift
//  Tangent
//
//  Created by Casey on 4/19/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit
import CoreData

class RoomCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var roomCollectionView: UICollectionView!
    
    private let reuseIdentifier = "RoomCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    var roomID: NSManagedObjectID?
    var roomName: String?
    var room: Room?
    var helper: DataHelper?
    
    private var roomCollection = [String]()
    
    //perform segue when room is selected from list
    var selectedRoom = 0 {
        didSet {
            performSegueWithIdentifier("showSavedRoom", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//        addCoefficientsToDB()
//        clearCoefficientDB()
        fetchRooms()
//        fetchCoefficients()
    }

    //** COLLECTION VIEW **
    func roomForIndexPath(indexPath: NSIndexPath) -> String {
        return roomCollection[indexPath.row]
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedRoom = indexPath.row
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomCollection.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = roomCollectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RoomCollectionViewCell
        cell.roomCellLabel.text = roomCollection[indexPath.row]
        return cell
    }
    
    
    // ** CORE DATA **
    // add test data
    func seedRoom() {
        
        //create an instance of managedObjectContext
        let moc = DataController().managedObjectContext
        
        //select entity and context to be targeted
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Room", inManagedObjectContext: moc) as! Room
        
        //add seed data
        entity.setValue("Home Studio", forKey: "roomName")
        entity.setValue(12.5, forKey: "roomHeight")
        entity.setValue(17.5, forKey: "roomWidth")
        entity.setValue(11.5, forKey: "roomDepth")
        entity.setValue(2515.625, forKey: "roomVolume")
        
        entity.setValue(5.5, forKey: "windowHeight")
        entity.setValue(3.5, forKey: "windowWidth")
        entity.setValue(19.25, forKey: "windowArea")
        
        entity.setValue(7.5, forKey: "doorHeight")
        entity.setValue(4.5, forKey: "doorWidth")
        entity.setValue(33.75, forKey: "doorArea")
        
        entity.setValue("wood on joists", forKey: "floorMaterial")
        entity.setValue("Plaster: smooth on tile/brick", forKey: "wallMaterial")
        entity.setValue("Fiberglass: spray 5\"", forKey: "ceilingMaterial")
        entity.setValue("wood", forKey: "doorMaterial")
        entity.setValue("Glass: window", forKey: "windowMaterial")
        
        //save entity
        do {
            try moc.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    /** Parses CSV file containing coefficient values and adds them to CoreData 
     
     1. Intitialize path to CSV file
     2. Set constant for CSV file
     3. initialize CoreData managed object context
     4. Set delimiter to comma
     5. Iterate through CSV file
     5. Set values for material type and absorption coefficients for all frequencies
     6. Save to CoreData
     
     */
    func addCoefficientsToDB(){
        
        
        // CSV
        let coefficientPath = NSBundle.mainBundle().pathForResource("absorption-coefficients", ofType: "csv")
        let pathString = try? String(contentsOfFile: coefficientPath!)
        let stringArray = pathString?.componentsSeparatedByString("\r")
        
        // ** Core Data **
        let moc = DataController().managedObjectContext
        
        
        let delimiter = ","
        
        //iterate through csv file
        for line in stringArray! {
            let entity = NSEntityDescription.insertNewObjectForEntityForName("Coefficient", inManagedObjectContext: moc) as! Coefficient
            var values = line.componentsSeparatedByString(delimiter)
            
            // set material type for material
            let materialType = values[0]
            entity.setValue(materialType, forKey: "type")
            print("adding: '\(materialType)'")
            
            //set 125Hz
            if let oneTwentyFiveHz = Double(values[1]) {
                let oneTwentyFiveNumber = NSNumber(double: oneTwentyFiveHz)
                entity.setValue(oneTwentyFiveNumber, forKey: "oneTwentyFiveHz")
                print("added 125Hz value: '\(oneTwentyFiveNumber)'")
                
            } else {
                print("Error importing 125Hz: value was not a number")
            }
            
            //set 250Hz
            if let twoFiftyHz = Double(values[2]) {
                let twoFiftyNumber = NSNumber(double: twoFiftyHz)
                entity.setValue(twoFiftyNumber, forKey: "twoFiftyHz")
                print("added 250Hz value: '\(twoFiftyNumber)'")
                
            } else {
                print("Error importing 250Hz. value was not a number")
            }
            
            //set 500Hz
            if let fiveHundredHz = Double(values[3]) {
                let fiveHundredNumber = NSNumber(double:fiveHundredHz)
                entity.setValue(fiveHundredHz, forKey: "fiveHundredHz")
                print("added 500Hz value: '\(fiveHundredNumber)'")
                
            } else {
                print("Error importing 500Hz: value was not a number")
            }
            
            //set 1kHz
            if let onekHz = Double(values[4]) {
                let oneKNumber = NSNumber(double:onekHz)
                entity.setValue(oneKNumber, forKey: "onekHz")
                print("added 1kHz value: '\(onekHz)'")

            } else {
                print("Error importing 1kHz: value was not a number")
            }
            
            //set 2kHz
            if let twokHz = Double(values[5]) {
                let twokNumber = NSNumber(double:twokHz)
                entity.setValue(twokNumber, forKey: "twokHz")
                print("added 2kHz value: '\(twokHz)'")
                
            } else {
                print("Error importing 2kHz: value was not a number")
            }
            
            //set 4kHz
            if let fourkHz = Double(values[6]) {
                let fourKNumber = NSNumber(double:fourkHz)
                entity.setValue(fourKNumber, forKey: "fourkHz")
                print("added 4kHz value: '\(fourkHz)'")
                
            } else {
                print("Error importing 4kHz: value was not a number")
            }
            
            //save db
            do {
                try moc.save()
                print("Entry \(line) saved.")
            } catch {
                fatalError("failure saving Coefficient DB: \(error)")
            }
        }
    }

    
    // retrieve rooms
    /** Returns room from CoreData to be displayed in the CollectionView
     
     1. set up managed object context
     2. iterate through rooms in CoreData
     3. Append to roomCollection[Room]
     
     */
    func fetchRooms() {
        let moc = DataController().managedObjectContext
        let roomFetch = NSFetchRequest(entityName: "Room")
        
        do {
            let fetchedRoom = try moc.executeFetchRequest(roomFetch) as! [Room]

            for room in fetchedRoom {
                if let name = room.valueForKey("roomName") {
                    print("Room Name: \(name)")
                    roomCollection.append(String(name))
                }
            }
        } catch {
            fatalError("Failed to fetch room: \(error)")
        }
    }
    
    //clear coefficient database -- for data integrity testing
    func clearCoefficientDB() {
        let moc = DataController().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Coefficient")
        
        do {
            let fetchedEntities = try moc.executeFetchRequest(fetchRequest)
            for entity in fetchedEntities {
                print("deleting entity: \(entity.valueForKey("type"))")
                moc.deleteObject(entity as! NSManagedObject)
            }
        } catch {
            fatalError("no entry found: \(error)")
        }
        
        do {
            try moc.save()
        } catch {
            fatalError("Could not save Coefficients DB: \(error)")
        }
    }
    
    //retrieve coefficients - also for testing: not used in this view
    func fetchCoefficients() {
        let moc = DataController().managedObjectContext
        let coefficientFetch = NSFetchRequest(entityName: "Coefficient")
        
        do {
            let fetchedCoefficients = try moc.executeFetchRequest(coefficientFetch) as! [Coefficient]
            print("fetched coefficients: \(fetchedCoefficients)")
            if fetchedCoefficients.isEmpty {
                print("Material coefficient database is empty D:")
            } else {
                for material in fetchedCoefficients {
                    print("fault- \(material)")
                    if let type = material.valueForKey("type") {
                        print("Material type: \(type)")
                    }
                    print("results: \(material)")
                }
            }
        } catch {
            fatalError("Failed to fetch material coefficients: \(error)")
        }
    }
    
    //boilerplate fuctions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let newView = segue.destinationViewController as? RoomViewController {
            
            newView.roomName = roomCollection[selectedRoom]
            print("sending room: \(newView.roomName!)")
        }
    }
        
}