//
//  CustomGoalCollectionViewCell.swift
//  Sora
//
//  Created by Jake Dorab on 2/14/17.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import Parse


@IBDesignable class PublicGoalCollectionViewCell: UICollectionViewCell {
    
    var view: UICollectionViewCell!
    
    //MARK: Properties
    @IBOutlet weak var goalLikeButton: UIButton!
    @IBOutlet weak var goalLikeCount: UIButton!
    @IBOutlet weak var goalAuthorImage: UIButton!
    @IBOutlet weak var goalAuthor: UIButton!
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalImage: UIImageView!
    @IBOutlet weak var goalCommentButton: UIButton!
    @IBOutlet weak var goalCommentCount: UIButton!
    @IBOutlet weak var goalShareButton: UIButton!

    //MARK: Methods
   override func prepareForReuse() {
      //  self.separatorView.isHidden = false
        self.goalImage.image = UIImage.init(named: "emptyTumbnail")
        self.goalTitle.text = ""
    //    self.goalImage.setImage(UIImage(), for: [])
    
    }
    
    func UICustomization() {
        helpers().roundCorners(element: self.goalAuthorImage)
        let overlayGradient = CAGradientLayer()
        helpers().addGradientLayer(element: self.goalImage, overlay: overlayGradient)
    }

    var goal: goalsClass? {
        didSet {
            guard let goal = goal else {
                return
            }
            

            let goalAuthorImageString = goal.goalAuthorImagePath
            
            self.goalAuthorImage.af_setImage(for: UIControlState.normal, url: URL(string: goalAuthorImageString!)!, placeholderImage: UIImage(named: "user-placeholder"))
            
            let goalImageString = goal.goalImagePath
            
            self.goalImage.af_setImage(withURL: URL(string: goalImageString!)!, placeholderImage: UIImage(named:"no-image-bg"), filter: nil,imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            
            
            self.goalAuthor.setTitle(goal.goalAuthorName, for: UIControlState.normal)
            self.goalTitle.text = goal.goalTitle
            
            if goal.goalLikeCount != 0 {
                self.goalLikeCount.setTitle(String(describing: goal.goalLikeCount!), for: UIControlState.normal)
            } else {
                self.goalLikeCount.setTitle("", for: UIControlState.normal)
            }
            if goal.goalCommentCount! != 0 {
                self.goalCommentCount.setTitle(String(describing: goal.goalCommentCount!), for: UIControlState.normal)
            } else {
                self.goalCommentCount.setTitle("", for: UIControlState.normal)
            }
                        
            print("printingLike1.a")
            print(goal.curUserLikedBool)
           
            goal.getCurUserLikedBool(completion: { isLiked in
                
                if isLiked == false {
                    print("settingLikedButtontoNOTFilled.a")
                    
                    let likedButton = UIImage(named: "linedHeart-icon.png")
                    self.goalLikeButton.setImage(likedButton, for: UIControlState.normal)
                }
                else {
                    print("settingLikedButtontoFilled.a")
                    let likedButton = UIImage(named: "filledHeart-icon.png")?.withRenderingMode(.alwaysTemplate)
                    self.goalLikeButton.tintColor = UIColor(red:0.90, green:0.04, blue:0.20, alpha:1)
                    self.goalLikeButton.setImage(likedButton, for: UIControlState.normal)
                }
            })
            
        }
    }

    @IBAction func likeTapped(_ sender: UIButton) {
        if PFUser.current() != nil {
            likeTappedC(sender as! UIButton)
        } else {
            // rather than perform segue to login, keep the UX light and just pop an alert urging login
        }
    }
    
    
    func likeTappedC(_ sender: UIButton) {
        sender.isEnabled = false
        goal?.toggleLike(completion: { liked, error in
            if error != nil {
                // Show error...
                // donY
            }
            if liked {
                let likedButton = UIImage(named: "filledHeart-icon.png")?.withRenderingMode(.alwaysTemplate)
                sender.tintColor = UIColor(red:0.90, green:0.04, blue:0.20, alpha:1)
                sender.setImage(likedButton, for: UIControlState.normal)
            
            } else {
                let likedButton = UIImage(named: "linedHeart-icon.png")
                sender.setImage(likedButton, for: UIControlState.normal)
            }
            sender.isEnabled = true
        })
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
