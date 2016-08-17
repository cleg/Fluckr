//
//  FullImageViewController.swift
//  Fluckr
//
//  Created by Paul Dmitryev on 16.08.16.
//  Copyright © 2016 Taburetka. All rights reserved.
//

import Kingfisher
import SVProgressHUD
import UIKit

class FullImageViewController: UIViewController {
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var imageUrl: NSURL?
    var imgSize: CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let imageUrl = imageUrl else {
            return
        }
        
        SVProgressHUD.show()
        fullImageView.kf_setImageWithURL(imageUrl, placeholderImage: nil, optionsInfo: nil, progressBlock: nil) {
            (image, error, cacheType, imageURL) -> () in
            SVProgressHUD.popActivity()
            if let image = image {
//                let widthScale = self.view.bounds.size.width / image.size.width
//                let heightScale = self.view.bounds.size.height / image.size.height
//                let minScale = min(widthScale, heightScale)
//                self.scrollView.minimumZoomScale = minScale
//                self.scrollView.zoomScale = minScale
                
                self.imgSize = image.size
                
                self.updateMinZoomScaleForSize(self.view.bounds.size)
                self.updateConstraintsForSize(self.view.bounds.size)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        fullImageView.kf_cancelDownloadTask()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }

    private func updateMinZoomScaleForSize(viewSize: CGSize) {
        guard let imgSize = imgSize where imgSize.width != 0 else {
            return
        }
        let widthScale = viewSize.width / imgSize.width
        let heightScale = viewSize.height / imgSize.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func updateConstraintsForSize(size: CGSize) {
        let yOffset = max(0, (size.height - fullImageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - fullImageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
}

extension FullImageViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return fullImageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
}
