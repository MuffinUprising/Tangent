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
    
    public var selectedRoom: Room?
    
    @IBAction func getRecommendation(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let room = selectedRoom {
            let height = String(room.roomHeight)
            print(height)
            roomHeightLabel.text = String(height)
            print("Room Height: \(room.roomHeight)")
            roomInfoView!.addSubview(roomHeightLabel)
        }
    }
}
