//
//  SearchViewController.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 16.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import UIKit

class SearchViewController: PhotoCollectionViewController, UISearchBarDelegate {
    let flickrApi = FlickrAPI()
    var query: String? = nil

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        if let searchText = NSUserDefaults.standardUserDefaults().stringForKey("search") {
            searchBar.text = searchText
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            print("Oups")
            return
        }
        searchBar.resignFirstResponder()
        
        NSUserDefaults.standardUserDefaults().setObject(text, forKey: "search")
        
        query = text
        
        newSearch()
        newPage()
    }
    
    override func getNextPage(onSuccess: ([FlickrPhoto]) -> Void) {
        guard  let query = query else {
            onSuccess([])
            return
        }
        
        flickrApi.searchPhotos(query, page: page, perPage: perPage) {
            result in
            onSuccess(result)
        }
    }
}
