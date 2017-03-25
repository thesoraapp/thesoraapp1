//
//  userViewCell.swift
//  Mung
//
//  Created by Chike Chiejine on 14/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class userViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfile: UIImageView!

    @IBOutlet weak var followButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //Write a function for rounded corners
        userProfile.layer.masksToBounds = true
        userProfile.layer.cornerRadius = 25
        followButton.layer.cornerRadius = 5
        
        
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
