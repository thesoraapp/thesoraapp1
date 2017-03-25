//
//  inviteUserViewCell.swift
//  Mung
//
//  Created by Chike Chiejine on 14/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class inviteUserViewCell: UITableViewCell {
    
    
    @IBOutlet weak var inviteFriends: UILabel!
    
    @IBOutlet weak var sendInvite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        inviteFriends.text = "Don’t keep your goals to yourself! Get some motivation from friends and family."
        sendInvite.layer.cornerRadius = 2
        
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
