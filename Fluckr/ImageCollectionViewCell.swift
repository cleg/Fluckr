//
//  ImageCollectionViewCell.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 15.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import Kingfisher
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var flickrImgView: UIImageView!
    
    var imageUrl: NSURL? {
        didSet {
            flickrImgView?.kf_setImageWithURL(imageUrl!)
        }
    }
}
