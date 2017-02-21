//
//  MainViewController.swift
//  AVCapturePhotoOutputSwiftSample
//
//  Created by Nikolay Andonov on 11/11/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, CapturePhotoHandlerDelegate {
    
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    @IBOutlet weak var cameraOverlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CapturePhotoHandler.sharedHandler.createCaptureSession(forView: cameraOverlayView);
        CapturePhotoHandler.sharedHandler.delegate = self
    }

    deinit {
        
        CapturePhotoHandler.sharedHandler.delegate = nil
    }
    
    @IBAction func takeLivePhotoButtonAction(_ sender: Any) {
        
        if CapturePhotoHandler.sharedHandler.isLivePhotoCaptureSupported() {
            
            CapturePhotoHandler.sharedHandler.takeLivePhoto()
            takePhotoButton.isEnabled = false
        }
        else {
            
            let alertController = UIAlertController(title: "Error", message: "Live Photo capture is not supported on this device", preferredStyle: .alert)
            let оKAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alertController.addAction(оKAction)
            present(alertController, animated: true, completion: nil)

        }
    }
    
    //MARK - CapturePhotoHandlerDelegate
    
    func didEndCapturingLivePhoto(success: Bool) {
        
        takePhotoButton.isEnabled = true
        
        let alertController = UIAlertController(title: "", message: "Live Photo was captured!", preferredStyle: .alert)
        let оKAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(оKAction)
        present(alertController, animated: true, completion: nil)
    }
}
