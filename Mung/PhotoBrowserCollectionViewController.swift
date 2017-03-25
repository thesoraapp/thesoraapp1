//
//  PhotoBrowserCollectionViewController.swift
//  Mung
//
//  Created by Jake Dorab on 11/6/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//


import UIKit
import Foundation
import CoreData
import Alamofire
import SwiftyJSON
import FastImageCache
import Parse
import AlamofireImage



protocol backFromViewDelegate {
    func backFromAction(goalObject: goalsClass?)
    func profileBackFromAction(user: UserClass?)
}


class PhotoBrowserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
    var delegate: backFromViewDelegate?

    var onActionComplete: ((goalsClass) -> Void)?
    var onProfileComplete: ((UserClass) -> Void)?
    
    var goalObject = goalsClass(goal: nil)
    var userObject = UserClass(userPFObject: nil, userPFUser: nil)
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    

    let formatName = KMSmallImageFormatName
    var shouldLogin = false
    
    
    var user = PFUser.current()
    
    var photos = [PhotoInfo]()
    let refreshControl = UIRefreshControl()
    var populatingPhotos = false
    var nextURLRequest: NSURLRequest?
    var coreDataStack: CoreDataStack!
    
    let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
    let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView"
    
    // MARK: Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        print(PFUser.current())
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if user != nil {
            handleRefresh()
        } else {
            shouldLogin = true
        }
        
        if shouldLogin {
            print("Logged In")
            let vC = helpers().refStoryboards(name: "Main").instantiateViewController(withIdentifier: "instaLoginRoot")
            self.navigationController?.show(vC, sender: self)
            shouldLogin = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToPhotoBrowser (segue : UIStoryboardSegue) {
        
    }
    
    // MARK: CollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellIdentifier, for: indexPath as IndexPath) as! PhotoBrowserCollectionViewCell
        let sharedImageCache = FICImageCache.shared()
        cell.imageView.image = nil
        
        
        
        let photo = photos[indexPath.row] as PhotoInfo
        
    
        cell.imageView.af_setImage(withURL: photo.sourceImageURL as URL) { _ in
            
        }
               return cell
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PhotoBrowserFooterViewIdentifier, for: indexPath as IndexPath) as! PhotoBrowserLoadingCollectionView
        if nextURLRequest == nil {
            footerView.spinner.stopAnimating()
        } else {
            footerView.spinner.startAnimating()
        }
        return footerView
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoInfo = photos[indexPath.row]
        
        
        if let goalsSetupController = self.storyboard?.instantiateViewController(withIdentifier:
            "step2") as? goalsSetup2ViewController {
            
            self.goalObject.goalImagePath = photoInfo.sourceImageURL.absoluteString
            self.userObject.userImagePath = photoInfo.sourceImageURL.absoluteString
            
            self.delegate?.backFromAction(goalObject: self.goalObject)
            self.delegate?.profileBackFromAction(user: self.userObject)
            
            //self.delegate?.backFromAction(goalObject: self.goalObject)
//            if let goalObject = goalObject {
//                onActionComplete?(goalObject)
//            }
            //self.delegate?.profileBackFromAction(user: self.userObject)
//            if let userObject = userObject {
//                onProfileComplete?(userObject)
//            }
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let column = UI_USER_INTERFACE_IDIOM() == .pad ? 4 : 3
        let itemWidth = floor((view.bounds.size.width - CGFloat(column - 1)) / CGFloat(column))
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        layout.footerReferenceSize = CGSize(width: collectionView!.bounds.size.width, height: 100.0)
        collectionView!.collectionViewLayout = layout
    }
    
    func setupView() {
        setupCollectionViewLayout()
        collectionView!.register(PhotoBrowserCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PhotoBrowserCellIdentifier)
        collectionView!.register(PhotoBrowserLoadingCollectionView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoBrowserFooterViewIdentifier)
        
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.nextURLRequest != nil && scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8) {
            populatePhotos(request: self.nextURLRequest! as! URLRequestConvertible)
        }
    }
    
    
    
    func populatePhotos(request: URLRequestConvertible) {
        
        if populatingPhotos {
            return
        }
        
        populatingPhotos = true
        
        print("RequestNumber2")
        print(request)
        print("RequestNumber2END")
        
        Alamofire.request(request).responseJSON {
            result in
            
            defer {
                self.populatingPhotos = false
            }
            switch result.result {
            case .success(let jsonObject):
                //debugPrint(jsonObject)
                let json = JSON(jsonObject)
                
                if (json["meta"]["code"].intValue  == 200) {
                    
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async() {
      
                        let photoInfos = json["data"].arrayValue
                            .filter {
                                $0["type"].stringValue == "image"
                            }.map({
                                PhotoInfo(sourceImageURL: $0["images"]["standard_resolution"]["url"].URL! as NSURL)
                            })
 
                        let lastItem = self.photos.count
                        self.photos.append(contentsOf: photoInfos)
                        let indexPaths = (lastItem..<self.photos.count).map { IndexPath(row: $0, section: 0) }
        
                        DispatchQueue.main.async() {
                            self.collectionView!.insertItems(at: indexPaths)
                        }
                        
                    }
                    
                }
            case .failure:
                break
            }
            
        }
    }
    
    func handleRefresh() {
        
        print("testadmin1")
        
        nextURLRequest = nil
        refreshControl.beginRefreshing()
        self.photos.removeAll(keepingCapacity: false)
        self.collectionView!.reloadData()
        refreshControl.endRefreshing()
        
        // this was user != nil
        if user != nil {

            let currentUser = PFUser.current()
            let accessTokenINSTA = currentUser!["userInstagramAccessToken"]
            // let accessTokenINSTA = Parse.User.current()!.get("userInstagramUserName")

            //can't access userInstagramUserName in currentUser so writing this weird function
            let string1 = currentUser!["username"] as! String
            let index1 = string1.index(string1.endIndex, offsetBy: -4)
            let userNameINSTA = string1.substring(to: index1)
            
            //can't access userInstagramUserName in currentUser so writing this weird function
            let request = Instagram.Router.PopularPhotos(userNameINSTA as! String, accessTokenINSTA as! String)
     
            populatePhotos(request: request)
        }
    }
    
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let setup2 = segue.destination as? goalsSetup2ViewController {
            
            setup2.goalObject = self.goalObject
            
        }
        
    
        if (segue.identifier == "show photo" && segue.destination is PhotoViewerViewController) {
            let photoViewerViewController = segue.destination as! PhotoViewerViewController
            
        } else if (segue.identifier == "login" && segue.destination is UINavigationController) {
            let navigationController = segue.destination as! UINavigationController
            if let oauthLoginViewController = navigationController.topViewController as? OauthLoginViewController {
                oauthLoginViewController.coreDataStack = coreDataStack
            }
            
        }
    }
}


class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    var photoInfo: PhotoInfo?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        imageView.frame = bounds
        addSubview(imageView)
    }
}

class PhotoBrowserLoadingCollectionView: UICollectionReusableView {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        spinner.startAnimating()
        spinner.center = self.center
        addSubview(spinner)
    }
}
