//
//  commentTableViewCell.swift
//  Coined
//
//  Created by Chike Chiejine on 03/02/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {
    
    
    
    @IBOutlet weak var userProfile: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.userProfile.layer.masksToBounds = true
        self.userProfile.layer.cornerRadius = 22.5
    
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
