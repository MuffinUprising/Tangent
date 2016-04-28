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
    
    @IBAction func getRecommendation(sender: AnyObject) {
        
    }
    
    func fetchRoom() {
        
        let moc = DataController().managedObjectContext
        let roomFetch = NSFetchRequest(entityName: "Room")
        
        do {
            let fetchedRoom = try moc.executeFetchRequest(roomFetch) as! [Room]
            
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
