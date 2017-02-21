//
//  CapturePhotoHandler.swift
//  AVCapturePhotoOutputSwiftSample
//
//  Created by Nikolay Andonov on 11/11/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

let sharedInstance = CapturePhotoHandler()

protocol CapturePhotoHandlerDelegate: class {
    func didEndCapturingLivePhoto(success:Bool)
}

class CapturePhotoHandler: NSObject, AVCapturePhotoCaptureDelegate {
    
    weak var delegate: CapturePhotoHandlerDelegate?
    
    private let photoOutput = AVCapturePhotoOutput()
    private var session: AVCaptureSession?
    private var cameraInput: AVCaptureDeviceInput?
    private var microphoneInput: AVCaptureDeviceInput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private var photoSampleBuffer: CMSampleBuffer?
    private var previewPhotoSampleBuffer: CMSampleBuffer?
    
    class var sharedHandler : CapturePhotoHandler {
        
        return sharedInstance
    }
    
    func createCaptureSession(forView: UIView) {
        
        session = AVCaptureSession()
        session?.addOutput(photoOutput)
        session?.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        let microphoneDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInMicrophone, mediaType: AVMediaTypeAudio, position: .unspecified)
        
        do {
            try cameraInput = AVCaptureDeviceInput(device: backCameraDevice)
            session?.addInput(cameraInput)
        } catch {
            print("camera input error: \(error)")
        }
        
        
        do {
            try microphoneInput = AVCaptureDeviceInput(device: microphoneDevice)
            session?.addInput(microphoneInput)
        } catch {
            print("microphone input error: \(error)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        if let captureLayer = previewLayer {
            
            captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            captureLayer.frame.size = forView.frame.size
            forView.layer.addSublayer(captureLayer)
        }
        
        photoOutput.isLivePhotoCaptureEnabled = true
        photoOutput.isLivePhotoAutoTrimmingEnabled = true;
        photoOutput.isHighResolutionCaptureEnabled = true
        
        session?.startRunning()
    }
    
    func isLivePhotoCaptureSupported() -> Bool {
        return photoOutput.isLivePhotoCaptureSupported
    }
    
    func takeLivePhoto() {
        
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        
        //Storing the video clip associated with the live photo on a temporary location, when the live photo is comprised and sent to the photo library
        //This file is moved as well.
        let writeURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("LivePhotoVideo\(settings.uniqueID).mov")
        settings.livePhotoMovieFileURL = writeURL
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    //MARK: - AVCapturePhotoCaptureDelegate
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        self.photoSampleBuffer = photoSampleBuffer
        self.previewPhotoSampleBuffer = photoSampleBuffer
    }
    
    //This method is required if the AVCapturePhotoSettings has been assigned a livePhotoMovieFileURL value
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplay photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
        saveLivePhotoToPhotoLibrary(outputFileURL, completionHandler:{ (_, error) -> Void in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            }
        } )
    }
    
    //This method would be called last from the AVCapturePhotoCaptureDelegate methods
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
        let success = error != nil ? false : true
        weak var weakSelf = self
        DispatchQueue.main.async {
            //The delegate should invoke UI changes
            weakSelf?.delegate?.didEndCapturingLivePhoto(success: success)
        }
    }
    
    //MARK - Utilities
    
    private func saveLivePhotoToPhotoLibrary(_ livePhotoMovieURL: URL,
                                             completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?) {
        
        weak var weakSelf = self
        checkPhotoLibraryAuthorization({ authorized in
            guard authorized else {
                print("Permission to access photo library denied.")
                completionHandler?(false, nil)
                return
            }
            guard ((weakSelf?.photoOutput) != nil) else {
                print("Unable to continue, AVCaptureOutputIsMissing")
                completionHandler?(false, nil)
                return
            }
            
            guard let jpegData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
                forJPEGSampleBuffer: (weakSelf?.photoSampleBuffer)!,
                previewPhotoSampleBuffer: weakSelf?.previewPhotoSampleBuffer)
                else {
                    print("Unable to create JPEG data.")
                    completionHandler?(false, nil)
                    return
            }
            
            PHPhotoLibrary.shared().performChanges( {
                let creationRequest = PHAssetCreationRequest.forAsset()
                let creationOptions = PHAssetResourceCreationOptions()
                creationOptions.shouldMoveFile = true
                creationRequest.addResource(with: PHAssetResourceType.photo, data: jpegData, options: nil)
                creationRequest.addResource(with: PHAssetResourceType.pairedVideo, fileURL: livePhotoMovieURL, options: creationOptions)
            }, completionHandler: completionHandler)
        })
    }
    
    private func checkPhotoLibraryAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            // The user has previously granted access to the photo library.
            completionHandler(true)
            
        case .notDetermined:
            // The user has not yet been presented with the option to grant photo library access so request access.
            PHPhotoLibrary.requestAuthorization({ status in
                completionHandler((status == .authorized))
            })
            
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
            
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(false)
        }
    }
}
