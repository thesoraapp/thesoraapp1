 //
//  AppDelegate.swift
//  Mung
//
//  Created by Chike Chiejine on 30/09/2016.
//  Copyright © 2016 Color & Space. All rights reserved.
//


import UIKit
import Parse
import Bolts
import CoreData
import Alamofire
import AlamofireImage


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        FastImageCacheHelper.setUp(delegate: self as! FICImageCacheDelegate )
        

        


        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        //Parse.setApplicationId("eOi9X05WR7Pks9zOlv2EypFg2BsHr6qEkpr7u4dX",
        //                       clientKey: "eMhx1tpnVkLcKY0JbugOH3wf637x9ujQF9qP25PJ")
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "eOi9X05WR7Pks9zOlv2EypFg2BsHr6qEkpr7u4dX"
            $0.clientKey = "eMhx1tpnVkLcKY0JbugOH3wf637x9ujQF9qP25PJ"
            //$0.server = "http://localhost:8080/parse"
            
            $0.server = "http://bold-case-162614.appspot.com/parse"
        }
        
        Parse.initialize(with: configuration)
        
        
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        
        
        
        
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController =  MainNavigationController()
//        self.window?.makeKeyAndVisible()
        
        
        
        
        
        meViewController2Data.sharedInstance

        
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0)
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.17, green:0.17, blue:0.17, alpha:1.0), NSFontAttributeName: UIFont(name: "Proxima Nova Soft", size: 20 )!]
        

           // ProximaNovaSoft-Regular
        return true

    }
    
    /*
    override init() {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
    }
    */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: FICImageCacheDelegate
    
//    func imageCache(imageCache: FICImageCache!, wantsSourceImageForEntity entity: FICEntity!, withFormatName formatName: String!, completionBlock: FICImageRequestCompletionBlock!) {
//        if let entity = entity as? PhotoInfo {
//            let imageURL = entity.sourceImageURL(withFormatName: formatName) as URL
//            let request = NSURLRequest(url: imageURL)
//        
//            //might cause issues
//            entity.request = Alamofire.request(imageURL).validate(contentType: ["image/*"]).responseImage() {
//                response in
//                switch response.result {
//                case .success(let image):
//                    completionBlock(image)
//                case .failure:
//                    break
//                }
//            }
    
    
            //might cause issues
//            entity.request = Alamofire.request(imageURL).validate(contentType: ["image/*"]).responseImage() {
//                (_, _, result, _) in
            //   result in
                //switch result {
                //case .success(let image):
             //   let image
//             completionBlock(result)
             //  completionBlock(image)
                //      completionBlock(image)
               // case .failure:
                 //   break;
//                }
//            }

   // }

    
//    func imageCache(imageCache: FICImageCache!, cancelImageLoadingForEntity entity: FICEntity!, withFormatName formatName: String!) {
//        
//        if let entity = entity as? PhotoInfo, let request = entity.request {
//            request.cancel()
//            entity.request = nil
//            //debugPrint("be canceled:\(entity.UUID)")
//        }
//    }
//    
//    func imageCache(imageCache: FICImageCache!, shouldProcessAllFormatsInFamily formatFamily: String!, forEntity entity: FICEntity!) -> Bool {
//        return true
//    }
//    
//    func imageCache(imageCache: FICImageCache!, errorDidOccurWithMessage errorMessage: String!) {
//        debugPrint("errorMessage" + errorMessage)
//    }


    
}

