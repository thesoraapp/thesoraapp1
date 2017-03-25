//
//  bankAccountCell.swift
//  Mung
//
//  Created by Chike Chiejine on 05/03/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit

class bankAccountCell: UITableViewCell {
    
    
    @IBOutlet weak var selectedTick: UIImageView!
    @IBOutlet weak var bankBalance: UILabel!
    @IBOutlet weak var lastFourDigits: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var bankLogo: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.selectedTick.tintColor = .soraGreen()
        helpers().roundCorners(element: bankLogo)
        bankLogo.layer.borderColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).cgColor
        bankLogo.layer.borderWidth = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        self.selectedTick.isHidden = false
        
        
    }

}
