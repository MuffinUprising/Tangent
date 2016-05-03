//
//  RoomViewController.swift
//  Tangent
//
//  Created by Casey on 4/27/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit
import CoreData

class RoomViewController: UIViewController {
    
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

    @IBOutlet weak var modeImageView: UIImageView!
    
    @IBOutlet weak var rt60Input: UITextField!
    
    @IBOutlet weak var roomInfoView: UIView!
    
    var roomName: String?
    
//    let roomHeight: Double
    
    @IBAction func getRecommendation(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = roomName {
            let moc = DataController().managedObjectContext
            let roomsFetch = NSFetchRequest(entityName: "Room")
            roomsFetch.predicate = NSPredicate(format: "roomName == %@", name)
            
            do {
                let fetchedRooms = try moc.executeFetchRequest(roomsFetch) as! [Room]
                print(fetchedRooms.first?.valueForKey("roomName"))
            } catch {
                fatalError("Failed to fetch rooms: \(error)")
            }
        }
    }
}
