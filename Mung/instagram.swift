//
//  instagram.swift
//  Mung
//
//  Created by Jake Dorab on 11/6/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import AlamofireImage


struct Instagram {
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://api.instagram.com"
        static let clientID = "33b2a82d8bf44196ac902850e2c65e62"
        static let redirectURI = "http://www.example.com/"
        static let clientSecret = "6f577e96b1cb49fcb21f10e82ddef26a"
        
        case PopularPhotos(String, String)
        case requestOauthCode
        
        static func requestAccessTokenURLStringAndParms(code: String) -> (URLString: String, params: [String: AnyObject]) {
            let params = ["client_id": Router.clientID, "client_secret": Router.clientSecret, "grant_type": "authorization_code", "redirect_uri": Router.redirectURI, "code": code]
            let pathString = "/oauth/access_token"
            let urlString = Instagram.Router.baseURLString + pathString
            return try (urlString, params as [String : AnyObject])
        }
        // MARK: URLRequestConvertible
        
        func asURLRequest() throws -> URLRequest {
            
            let result: (path: String, parameters: [String: AnyObject]?) = try {
                switch self {
                case .PopularPhotos (let userID, let accessToken):
                    let params = ["access_token": accessToken]
                    
                    //https://api.instagram.com/v1/users/self/media/liked?access_token=4024218344.33b2a82.cf5ef8bf9dd7449b8d3118ea137ae4d9
                    
                    let pathString = "/v1/users/self/media/liked?access_token=" + accessToken
                    return (pathString, params as [String : AnyObject]?)
                    
                case .requestOauthCode:
                    let pathString =  "/oauth/authorize/?client_id=" + Router.clientID + "&redirect_uri=" + Router.redirectURI + "&response_type=code"
                    
                    //https://api.instagram.com/oauth/authorize/?client_id=33b2a82d8bf44196ac902850e2c65e62&redirect_uri=http://www.example.com/&response_type=code
                    
                 //   https://api.instagram.com/oauth/authorize/?client_id=33b2a82d8bf44196ac902850e2c65e62&redirect_uri=http://www.example.com/&response_type=code
                    
                    return  (pathString, nil)
                
                default: break
                    
                }
            }()
            
            
            let baseURL = try Router.baseURLString.asURL()
            
            let newURL = Router.baseURLString + result.path
            let urlRequest = URLRequest(url: try newURL.asURL())
            
           
            
            //let urlRequest = URLRequest(url: baseURL.appendingPathComponent(result.path))
            //return try Alamofire.URLEncoding.default.encode(urlRequest, with: result.parameters)
            
            
//            let baseURL = try NSURL(string: Router.baseURLString)!
//            let URLRequest = try NSMutableURLRequest(url: NSURL(string: result.path ,relativeTo:baseURL as URL)! as URL)
           
         //   return encoding.encode(URLRequest, parameters: result.parameters).0
            
            
//            return try Alamofire.URLEncoding.default.encode(urlRequest!, with: result.parameters)
            
            //return try Alamofire.URLEncoding().encode(URLRequest as! URLRequestConvertible, with: result.parameters)
      
    
            //let requestURL = (Router.baseURLString + result.path)
            //let b =  Alamofire.request(requestURL, method: .post ,parameters: result.parameters, encoding: URLEncoding.default, headers : nil)
        
            print("hereistheurlrequest")
            print(urlRequest)
            
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
        
    }
    
}

//Changed to datarequest

extension Alamofire.Request {
    //print("HELLO98788")
    
    class func imageResponseSerializer() -> DataResponseSerializer<UIImage> {
        
        print("HELLO987")
        return DataResponseSerializer { request, response, data, error in
            
            
            print("DATARESPONSE")
            print(response)
            print("DATADATA")
            print(data)
            print("DATADATAEND")
            
            
            guard let validData = data , validData.count > 0 else {
                return error as! Result<UIImage>
            }
            
            if let image = UIImage(data: validData, scale: UIScreen.main.scale) {
                return Result<UIImage>.success(image)
            }
            else {
                return error as! Result<UIImage>
            }
            
        }
        
    }

//    func responseImage(completionHandler: @escaping (NSURLRequest?, HTTPURLResponse?, Result<UIImage>, Error?) -> Void) -> Self {
//        
//        return response(responseSerializer: request.imageResponseSerializer(), completionHandler: completionHandler)
//
////        return  response(responseSerializer: DataRequest.imageResponseSerializer(), completionHandler: completionHandler)
//    }
//    
    
    
    
    
    
//    public init(serializeResponse: @escaping (URLRequest?, HTTPURLResponse?, Data?, Error?) -> Result<Value>) {
//        self.serializeResponse = serializeResponse
//    }
//    
    
    
    //sending via dropbox. thnsks
    private class func imageDataError() -> Error {
        let failureReason = "Failed to create a valid Image from the response data"
        return Error.self as! Error
        //return Error(NSURLErrorCannotDecodeContentData, failureReason: failureReason)
    }
}
