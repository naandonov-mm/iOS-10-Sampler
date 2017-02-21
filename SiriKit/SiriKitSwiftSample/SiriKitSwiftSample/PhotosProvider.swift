//
//  PhotosProvider.swift
//  SiriKitSwiftSample
//
//  Created by Nikolay Andonov on 12/7/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

private let sharedProvider = PhotosProvider()

class PhotosProvider: NSObject {

    var photos : Dictionary<String, UIImage>
    
    class var sharedInstance: PhotosProvider {
        return sharedProvider;
    }
    
    override init() {
    
        let keys = ["cat","dog","pig","seal"]
        var result : Dictionary<String, UIImage> = [:]
        for key in keys {
            let imageName = "\(key).jpg"
            result[key] = UIImage.init(named: imageName)
        }
        photos = result
        
        super.init()
    }
    
    func allPhotos() -> Array<String> {
        return photos.keys.sorted()
    }
    
    func photoForSearchTerm(term: String) -> UIImage? {
        return photos[term]
    }
    
    func containsPhotoForSearchTerm(term: String) -> Bool {
        return photos[term] != nil
    }
}
