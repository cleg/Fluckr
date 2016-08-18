//
//  FlickrPhoto.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 16.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import Foundation

class FlickrPhoto: NSObject, NSCoding {
    var thumbUrl: NSURL
    var fullUrl: NSURL
    
    init(thumbUrl: NSURL, fullUrl: NSURL) {
        self.thumbUrl = thumbUrl
        self.fullUrl = fullUrl
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let thumbU = aDecoder.decodeObjectForKey("thumbUrl") as? NSURL,
            let fullU = aDecoder.decodeObjectForKey("fullUrl") as? NSURL else {
                return nil
        }
        self.init(thumbUrl: thumbU, fullUrl: fullU)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(thumbUrl.absoluteURL, forKey: "thumbUrl")
        aCoder.encodeObject(fullUrl.absoluteURL, forKey: "fullUrl")
    }
}