//
//  goalViewCell.swift
//  Mung
//
//  Created by Chike Chiejine on 03/10/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit

class goalViewCell: UITableViewCell {
    
    
    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalAuthorProfile: UIButton!
    @IBOutlet weak var goalAuthorName: UIButton!
    @IBOutlet weak var likeGoal: UIButton!
    @IBOutlet weak var shareGoal: UIButton!
    @IBOutlet weak var commentButton: UIButton!

    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var copyIcon: UIImageView!
    
    @IBOutlet weak var likeAmount: UIButton!
    @IBOutlet weak var copyAmount: UIButton!
    
    

    let overLay = UIView()
    let overlayGradient = CAGradientLayer()

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .white
        
        self.goalImage.clipsToBounds = true
        self.goalImage.layer.masksToBounds = true
        self.goalImage.contentMode = .scaleAspectFill
        self.likeGoal.imageView?.contentMode = .scaleAspectFit
        self.shareGoal.imageView?.contentMode = .scaleAspectFit
        self.commentButton.imageView?.contentMode = .scaleAspectFit
        
        let width = self.frame.size.width
        let height = self.goalImage.frame.height
        
        goalAuthorProfile.layer.cornerRadius = 25
        goalAuthorProfile.layer.masksToBounds = true
        goalAuthorProfile.imageView?.contentMode = .scaleAspectFill
        
   
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
