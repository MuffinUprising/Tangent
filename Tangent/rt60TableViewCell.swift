//
//  rt60TableViewCell.swift
//  Tangent
//
//  Created by Casey on 5/7/16.
//  Copyright © 2016 Casey. All rights reserved.
//

import UIKit

class rt60TableViewCell: UITableViewCell {

    
    @IBOutlet weak var surfaceLabel: UILabel!
    @IBOutlet weak var oneTwoFiveHzLabel: UILabel!
    @IBOutlet weak var twoFiveZeroHzLabel: UILabel!
    @IBOutlet weak var fiveHundredHzLabel: UILabel!
    @IBOutlet weak var onekHzLabel: UILabel!
    @IBOutlet weak var twokHzLabel: UILabel!
    @IBOutlet weak var fourkHzLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
