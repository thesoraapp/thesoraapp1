//
//  meGoalCollectionViewCell.swift
//  Mung
//
//  Created by Jake Dorab on 2/21/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//



import Foundation
import UIKit
import Alamofire
import AlamofireImage


@IBDesignable class MeGoalCollectionViewCell: UICollectionViewCell {
    
    var view: UICollectionViewCell!
    
    //MARK: Properties
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalTotalSaved: UILabel!
    @IBOutlet weak var goalTimeLeft: UILabel!
    @IBOutlet weak var goalPercComplete: UILabel!
    
    //MARK: Methods
    
    
    //MARK: Methods
    override func prepareForReuse() {
        //  self.separatorView.isHidden = false
        self.goalImage.image = UIImage.init(named: "emptyTumbnail")
        self.goalTitle.text = ""
        //    self.goalImage.setImage(UIImage(), for: [])
        
    }
    
    func UICustomization() {
        let overlayGradient = CAGradientLayer()
        helpers().addGradientLayer(element: self.goalImage, overlay: overlayGradient)
    }
    
    var goal: goalsClass? {
        didSet {
            guard let goal = goal else {
                return
            }
            
            let goalImageString = goal.goalImagePath
            
            self.goalImage.af_setImage(withURL: URL(string: goalImageString!)!, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            
            goal.userGoalAllocation2 { (error) in
                if error == nil {
                    self.goalTitle.text = goal.goalTitle
                    
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 2
                    if goal.goalTotalSaved != nil {
                        self.goalTotalSaved.text = formatter.string(from: goal.goalTotalSaved! as NSNumber)
                    }
                    self.goalTimeLeft.text = goal.goalTimeLeft
                    if goal.goalPercComplete != nil {
                        self.goalPercComplete.text = String(describing: goal.goalPercComplete!)
                    }
                }
            }
        }
    }
    
    
    
    
    
    //MARK: Inits
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UICustomization()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
}
