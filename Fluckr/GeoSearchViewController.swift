//
//  GeoSearchViewController.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 15.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import CoreLocation
import UIKit
import SVProgressHUD

class GeoSearchViewController: UIViewController, CLLocationManagerDelegate, ImagesViewDelegate {
    let locationManager = CLLocationManager()
    let flickrApi = FlickrAPI()
    
    var page: Int = 0
    let perPage: Int = 21
    var hasMore = true
    var data: [FlickrPhoto] = []
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    var imagesViewController: ImagesCollectionViewController? {
        get {
            return self.childViewControllers[0] as? ImagesCollectionViewController
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        imagesViewController?.delegate = self

        if NSUserDefaults.standardUserDefaults().boolForKey("storedLocation") {
            latitude = NSUserDefaults.standardUserDefaults().doubleForKey("latitude")
            longitude = NSUserDefaults.standardUserDefaults().doubleForKey("longitude")
            newPage()
        } else {
            newSearch()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newSearch() {
        page = 0
        hasMore = true
        data = []
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
    
    func newPage() {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        if !hasMore {
            return
        }
        
        page += 1
        flickrApi.getNearbyPhotos(latitude, longitude: longitude, page: page, perPage: perPage) {
            result in
            if result.count < self.perPage {
                self.hasMore = false
            }
            self.data.appendContentsOf(result)
            self.imagesViewController?.photos = self.data
        }
        
    }
}
