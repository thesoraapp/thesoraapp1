//
//  depositCell.swift
//  Mung
//
//  Created by Chike Chiejine on 29/01/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit

class depositCell: UITableViewCell {
    
    //XYZ444 - Deposit label is detached from Storyboard now as it's not needed
    @IBOutlet weak var depositAmount: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var depositTime: UILabel!
    @IBOutlet weak var cancelPayment: UIButton!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
