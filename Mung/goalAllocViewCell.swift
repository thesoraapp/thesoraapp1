//
//  goalAllocViewCell.swift
//  Mung
//
//  Created by Chike Chiejine on 21/11/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import UIKit



class goalAllocViewCell: UITableViewCell {

    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalCurrentAmount: UILabel!
    @IBOutlet weak var goalReturn: UILabel!
    @IBOutlet weak var goalTimeLeft: UILabel!
    @IBOutlet weak var goalPercComplete: UILabel!
    @IBOutlet weak var goalProgress: KDCircularProgress!

    let overLay = UIView()
    let overlayGradient = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.black
        self.goalImage.clipsToBounds = true
        self.goalImage.contentMode = .scaleAspectFill
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
