//
//  MainCollectionViewCell.swift
//  UICollectionViewDataSourcePrefetchingSwiftSample
//
//  Created by Nikolay Andonov on 10/24/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        imageView.image = nil
        activityIndicator.startAnimating()
    }
}
