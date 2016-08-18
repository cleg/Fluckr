//
//  PhotoCollectionViewController.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 17.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewController: UIViewController, ImagesViewDelegate {
    var page: Int = 0
    let perPage: Int = 21
    var hasMore = true
    
    private var tmpData: [FlickrPhoto] = []
    
    var photos: [FlickrPhoto] = [] {
        didSet {
            imagesViewController?.photos = photos
        }
    }

    var imagesViewController: ImagesCollectionViewController? {
        get {
            return self.childViewControllers[0] as? ImagesCollectionViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesViewController?.delegate = self
    }
    
    // MARK: Search
    func newSearch() {
        page = 0
        hasMore = true
        photos = []
    }
    
    // we don't have pure virtual functions, so we could declare protocol and partially extend it with real code, but this is simplier solution actually
    func getNextPage(onSuccess: ([FlickrPhoto]) -> Void) {
        fatalError("This function must be overriden in descendants in order to perform actual search")
    }
    
    func newPage() {
        if !hasMore {
            return
        }
        page += 1
        getNextPage() {
            newPhotos in
            if newPhotos.count < self.perPage {
                self.hasMore = false
            }
            self.photos.appendContentsOf(newPhotos)
        }
    }
    
    // MARK: Storing data
    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        guard let restId = self.restorationIdentifier else {
            return
        }
        let archivedData = NSKeyedArchiver.archivedDataWithRootObject(photos)
        NSUserDefaults.standardUserDefaults().setObject(archivedData, forKey: "data\(restId)")
        
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        guard let restId = self.restorationIdentifier else {
            return
        }
        if let archivedData = NSUserDefaults.standardUserDefaults().objectForKey("data\(restId)") as? NSData {
            photos = NSKeyedUnarchiver.unarchiveObjectWithData(archivedData) as! [FlickrPhoto]
        }
        super.decodeRestorableStateWithCoder(coder)
    }

}
