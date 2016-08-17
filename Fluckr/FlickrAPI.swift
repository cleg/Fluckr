//
//  FlickrAPI.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 15.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import CoreLocation
import Foundation
import FlickrKit
import SVProgressHUD

class FlickrAPI {
    private func getPhotosFromResponse(data: [NSObject : AnyObject]) -> [FlickrPhoto] {
        var photosUrls: [FlickrPhoto] = []
        let topPhotos = data["photos"] as! [NSObject: AnyObject]
        let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]
        
        for photoDictionary in photoArray {
            let thumbURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeSmall240, fromPhotoDictionary: photoDictionary)
            let fullURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeLarge1024, fromPhotoDictionary: photoDictionary)
            photosUrls.append(FlickrPhoto(thumbUrl: thumbURL, fullUrl: fullURL))
        }
        return photosUrls
    }
    
    private func performSearch(method: FKFlickrAPIMethod, onSuccess: ([FlickrPhoto]) -> Void) {
        SVProgressHUD.show()
        FlickrKit.sharedFlickrKit().call(method) {
            response, error in
            defer {
                dispatch_async(dispatch_get_main_queue()) {
                    SVProgressHUD.dismiss()
                }
            }
            if let response = response {
                var photosUrls: [FlickrPhoto] = []
                
                photosUrls = self.getPhotosFromResponse(response)
                
                dispatch_async(dispatch_get_main_queue()) {
                    onSuccess(photosUrls)
                }
            }
        }
    }
    
    func getNearbyPhotos(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radiusInKm: Float = 1.0, page: Int = 1, perPage: Int = 21, onSuccess: ([FlickrPhoto]) -> Void) {
        let nearby = FKFlickrPhotosSearch()
        nearby.lat = String(format: "%f", latitude)
        nearby.lon = String(format: "%f", longitude)
        nearby.radius = "\(radiusInKm)"
        nearby.page = "\(page)"
        nearby.per_page = "\(perPage)"
        
        performSearch(nearby, onSuccess: onSuccess)
    }
    
    func searchPhotos(query: String, page: Int = 1, perPage: Int = 21, onSuccess: ([FlickrPhoto]) -> Void) {
        let search = FKFlickrPhotosSearch()
        search.text = query
        search.page = "\(page)"
        search.per_page = "\(perPage)"
        
        performSearch(search, onSuccess: onSuccess)
    }
}
