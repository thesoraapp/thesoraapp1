//
//  PhotoInfo.swift
//  Mung
//
//  Created by Jake Dorab on 11/6/16.
//  Copyright © 2016 Color & Space. All rights reserved.
//


import Foundation
import Alamofire
import FastImageCache
import UIKit

class PhotoInfo: NSObject, FICEntity {
    
    @objc(UUID) var uuid: String! {
        let imageName = sourceImageURL.lastPathComponent!
        let UUIDBytes = FICUUIDBytesFromMD5HashOfString(imageName)
        return FICStringWithUUIDBytes(UUIDBytes) as! String
    }
    
    var sourceImageUUID: String! {
        return uuid
    }
    
    var sourceImageURL: NSURL
    var request: Alamofire.Request?
    
    init(sourceImageURL: NSURL) {
        self.sourceImageURL = sourceImageURL
        super.init()
    }
    
    func isEqual(object: AnyObject?) -> Bool {
        return (object as! PhotoInfo).uuid == self.uuid
    }
    
    func sourceImageURL(withFormatName formatName: String!) -> URL! {
        return sourceImageURL as URL
    }
    
    func drawingBlock(for image: UIImage, withFormatName formatName: String) -> FastImageCache.FICEntityImageDrawingBlock! {
        
        let drawingBlock:FICEntityImageDrawingBlock = {
            (context:CGContext!, contextSize:CGSize) in
            var contextBounds = CGRect.zero
            contextBounds.size = contextSize
            context.clear(contextBounds)
            
            UIGraphicsPushContext(context)
            image.draw(in: contextBounds)
            UIGraphicsPopContext()
        } as! FastImageCache.FICEntityImageDrawingBlock
        return drawingBlock
    }
    
    
}
