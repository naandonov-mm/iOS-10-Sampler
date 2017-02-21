//
//  DetailViewController.swift
//  SiriKitSwiftSample
//
//  Created by Nikolay Andonov on 12/8/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
    
    //MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
