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
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var roomCollection = [Room]()
//    private let room = Room()
    
    var selectedRoom = 0 {
        didSet {
            performSegueWithIdentifier("RoomCell", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dh = DataHelper()
        seedRoom()
        fetchRoom()
        dh.parseCSV()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func roomForIndexPath(indexPath: NSIndexPath) -> Room {
        return roomCollection[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedRoom = indexPath.row
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomCollection.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = roomCollectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! RoomCollectionViewCell
        let room = roomForIndexPath(indexPath)
        cell.backgroundColor = UIColor.blackColor()
        cell.roomCellLabel.text = room.roomName
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
    
    // retrieve entry
    func fetchRoom() {
        let moc = DataController().managedObjectContext
        let roomFetch = NSFetchRequest(entityName: "Room")
        
        do {
            let fetchedRoom = try moc.executeFetchRequest(roomFetch) as! [Room]
            print(fetchedRoom.first!.roomName!)
            for room in fetchedRoom {
                roomCollection.append(room)
            }
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let navView = segue.destinationViewController as? UINavigationController {
//            let newView = navView.viewControllers[0] as? RoomViewController
//            newView!.room = roomCollection[selectedRoom]
//    }
}
