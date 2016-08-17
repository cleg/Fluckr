//
//  ImagesCollectionViewController.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 15.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImagesCell"

protocol ImagesViewDelegate {
    func newPage()
}

class ImagesCollectionViewController: UICollectionViewController { // , UICollectionViewDelegateFlowLayout
    let numberOfColumns = 3
    var itemWidth: CGFloat = CGFloat(0)
    var delegate: ImagesViewDelegate?
    
    var photos: [FlickrPhoto] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        if let collectionView = collectionView {
            itemWidth = (CGRectGetWidth(collectionView.frame) - (CGFloat(numberOfColumns) - 1)) / CGFloat(numberOfColumns);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFullImageSeague" {
            guard let fullImageVC = segue.destinationViewController as? FullImageViewController,
                let selectedCell = sender as? ImageCollectionViewCell else {
                    return
            }
            
            if let indexPath = collectionView?.indexPathForCell(selectedCell) {
                fullImageVC.imageUrl = photos[indexPath.row].fullUrl
            }
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
    
        cell.imageUrl = photos[indexPath.row].thumbUrl
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == photos.count - 1 {
            delegate?.newPage()
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(itemWidth, itemWidth);
//    }    
}
