//
//  SearchViewController.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 16.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,  UISearchBarDelegate, ImagesViewDelegate {
    let flickrApi = FlickrAPI()
    let perPage: Int = 21
    var page: Int = 0
    var hasMore = true
    var query: String? = nil
    var data: [FlickrPhoto] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    var imagesViewController: ImagesCollectionViewController? {
        get {
            return self.childViewControllers[0] as? ImagesCollectionViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        imagesViewController?.delegate = self
        
        if let searchText = NSUserDefaults.standardUserDefaults().stringForKey("search") {
            searchBar.text = searchText
        }
        
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        NSUserDefaults.standardUserDefaults().setObject(text, forKey: "search")
        
        hasMore = true
        page = 0
        query = text
        data = []
        
        newPage()
    }
    
    func newPage() {
        guard  let query = query else {
            return
        }
        
        page += 1
        flickrApi.searchPhotos(query, page: page, perPage: perPage) {
            result in
            if result.count < self.perPage {
                self.hasMore = false
            }
            self.data.appendContentsOf(result)
            self.imagesViewController?.photos = self.data
        }
    }
}
