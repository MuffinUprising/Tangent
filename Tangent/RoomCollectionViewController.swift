//
//  RoomCollectionViewController.swift
//  Tangent
//
//  Created by Casey on 4/19/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit

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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let navView = segue.destinationViewController as? UINavigationController {
//            let newView = navView.viewControllers[0] as? RoomViewController
//            newView!.room = roomCollection[selectedRoom]
//    }
}
