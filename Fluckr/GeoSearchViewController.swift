//
//  GeoSearchViewController.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 15.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import CoreLocation
import Kingfisher
import SVProgressHUD
import UIKit


class GeoSearchViewController: PhotoCollectionViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let flickrApi = FlickrAPI()
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        imagesViewController?.delegate = self

        let hadLocation = NSUserDefaults.standardUserDefaults().boolForKey("storedLocation")
        if  hadLocation {
            latitude = NSUserDefaults.standardUserDefaults().doubleForKey("latitude")
            longitude = NSUserDefaults.standardUserDefaults().doubleForKey("longitude")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if photos.count == 0 {
            if NSUserDefaults.standardUserDefaults().boolForKey("storedLocation") {
                newPage()
            } else {
                newSearch()
            }
        }
    }
    
    override func newSearch() {
        super.newSearch()
        latitude = nil
        longitude = nil
        
        SVProgressHUD.showWithStatus("Getting location")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func refreshButtonTap(sender: UIBarButtonItem) {
        newSearch()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        SVProgressHUD.dismiss()
        if let location = locations.first {
            NSUserDefaults.standardUserDefaults().setDouble(location.coordinate.latitude, forKey: "latitude")
            NSUserDefaults.standardUserDefaults().setDouble(location.coordinate.longitude, forKey: "longitude")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "storedLocation")
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            newPage()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        SVProgressHUD.dismiss()
        let errorType = error.code == CLError.Denied.rawValue ? "Access Denied": "Error \(error.code)"
        let alertController = UIAlertController(title: "Location Manager Error", message: errorType, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { action in })
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func getNextPage(onSuccess: ([FlickrPhoto]) -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            onSuccess([])
            return
        }
        
        flickrApi.getNearbyPhotos(latitude, longitude: longitude, page: page, perPage: perPage) {
            result in
            onSuccess(result)
        }
    }
}
