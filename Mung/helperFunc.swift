//
//  helperFunc.swift
//  Mung
//
//  Created by Jake Dorab on 10/18/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import Foundation
import UIKit
import Parse

class helperFunc {
class func convertStringtoUIImage (pathString : String) -> UIImage {

        var profileImage = UIImage()
        
        let urlObj = URL(string: pathString)
        print("urlObj")
        print(urlObj)
        URLSession.shared.dataTask(with: urlObj!) { (data, response, error) in
            if error != nil {
            } else {
            if let data = data {
                print("dataTESTTEST")
                print(data)
                
                
                profileImage = UIImage(data: data)!
               
                
                
                }}
            }.resume()
        print("testBOOYAKASHA")
        print(profileImage)
    print("testBOOYAKASHAEND")
        return profileImage
}
}
