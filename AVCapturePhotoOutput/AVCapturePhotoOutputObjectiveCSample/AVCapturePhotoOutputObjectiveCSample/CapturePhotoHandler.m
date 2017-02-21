//
//  CapturePhotoHandler.m
//  AVCapturePhotoOutputObjectiveCSample
//
//  Created by Nikolay Andonov on 12/6/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import "CapturePhotoHandler.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <Photos/PHPhotoLibrary.h>

@interface CapturePhotoHandler() <AVCapturePhotoCaptureDelegate>

@property(strong, nonatomic) AVCapturePhotoOutput *photoOutput;
@property(strong, nonatomic) AVCaptureSession *session;
@property(strong, nonatomic) AVCaptureDeviceInput *cameraInput;
@property(strong, nonatomic) AVCaptureDeviceInput *microphoneInput;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property(assign, nonatomic) CMSampleBufferRef photoSampleBuffer;
@property(assign, nonatomic) CMSampleBufferRef previewPhotoSampleBuffer;

@end

@implementation CapturePhotoHandler

+ (instancetype)sharedHandler {
    static CapturePhotoHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CapturePhotoHandler alloc] init];
    });
    return sharedInstance;
}

- (void)createCaptureSessionForView:(UIView *)view {
    
    self.session = [[AVCaptureSession alloc] init];
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
    [self.session addOutput:self.photoOutput];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureDevice *backCameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position: AVCaptureDevicePositionBack];
     AVCaptureDevice *microphoneDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInMicrophone mediaType:AVMediaTypeAudio position: AVCaptureDevicePositionUnspecified];
    
    NSError *cameraInputError = nil;
    self.cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:backCameraDevice error:&cameraInputError];
    if (cameraInputError) {
        NSLog(@"Camera input error: %@", cameraInputError.localizedDescription);
    }
    
    NSError *microphoneInputError = nil;
    [self.session addInput:self.cameraInput];
    self.microphoneInput = [[AVCaptureDeviceInput alloc] initWithDevice:microphoneDevice error:&microphoneInputError];
    if (microphoneInputError) {
        NSLog(@"Microphone input error: %@", microphoneInputError.localizedDescription);
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = view.frame;
    [view.layer addSublayer:self.previewLayer];
    
    self.photoOutput.livePhotoCaptureEnabled = YES;
    self.photoOutput.livePhotoAutoTrimmingEnabled = YES;
    self.photoOutput.highResolutionCaptureEnabled = YES;
    
    [self.session startRunning];
}

- (BOOL)isLivePhotoSupported {
    
    if (self.photoOutput) {
        return self.photoOutput.isLivePhotoCaptureSupported;
    }
    return NO;
}

- (void)takeLivePhoto {
    
    AVCapturePhotoSettings *settings = [[AVCapturePhotoSettings alloc] init];
    settings.highResolutionPhotoEnabled = YES;
    
    //Storing the video clip associated with the live photo on a temporary location, when the live photo is comprised and sent to the photo library
    //This file is moved as well.
    NSURL *writeURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"LivePhotoVideo%ld.mov",(long)settings.uniqueID]]];
    settings.livePhotoMovieFileURL = writeURL;
    
    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
    
}

#pragma mark - AVCapturePhotoCaptureDelegate

-(void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {

    if (photoSampleBuffer) {
        CFRetain(photoSampleBuffer);
        self.photoSampleBuffer = photoSampleBuffer ;
    }
    
    if (previewPhotoSampleBuffer) {
        CFRetain(previewPhotoSampleBuffer);
        self.previewPhotoSampleBuffer = previewPhotoSampleBuffer;
    }
}

//This method is required if the AVCapturePhotoSettings has been assigned a livePhotoMovieFileURL value
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingLivePhotoToMovieFileAtURL:(NSURL *)outputFileURL duration:(CMTime)duration photoDisplayTime:(CMTime)photoDisplayTime resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(NSError *)error {
    
    __weak typeof(self)weakSelf = self;
    [self saveLivePhotoToPhotoLibraryWithLivePhotoMovieURL:outputFileURL completitionHandler:^(BOOL success, NSError *error) {
        
        if (weakSelf.photoSampleBuffer) {
            CFRelease(weakSelf.photoSampleBuffer);
        }
        
        if (weakSelf.previewPhotoSampleBuffer) {
            CFRelease(weakSelf.previewPhotoSampleBuffer);
        }
        
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

//This method would be called last from the AVCapturePhotoCaptureDelegate methods
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishCaptureForResolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings error:(nullable NSError *)error {
    
    BOOL success = error? NO : YES;
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(didEndCapturingLivePhotoWithSuccess:)]) {
            [weakSelf.delegate didEndCapturingLivePhotoWithSuccess:success];
        }
    });
}

#pragma mark - Utilities



- (void)checkPhotoLibraryAuthorizationWithCompletitionHandler:(void(^)(BOOL authorized))completionHandler {
    
    switch ([PHPhotoLibrary authorizationStatus]) {
            
        case PHAuthorizationStatusAuthorized: {
            // The user has previously granted access to the photo library.
            completionHandler(YES);
            break;
        }
        case PHAuthorizationStatusNotDetermined: {
            // The user has not yet been presented with the option to grant photo library access so request access.
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                completionHandler((status == PHAuthorizationStatusAuthorized));
                
            }];
            break;
        }
        case PHAuthorizationStatusDenied: {
            // The user has previously denied access.
            completionHandler(NO);
            break;
        }
        case PHAuthorizationStatusRestricted: {
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(NO);
            break;
        }
            
        default:
            break;
    }
}

- (void)saveLivePhotoToPhotoLibraryWithLivePhotoMovieURL:(NSURL *)livePhotoMovieURL completitionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    
    __weak typeof(self)weakSelf = self;
    [self checkPhotoLibraryAuthorizationWithCompletitionHandler:^(BOOL authorized) {
        
        if (!authorized) {
            NSLog(@"Permission to access photo library denied.");
            completionHandler(NO, nil);
            return;
        }
        
        NSData *jpegData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:weakSelf.photoSampleBuffer
                                                                       previewPhotoSampleBuffer:weakSelf.previewPhotoSampleBuffer];
        if (!jpegData) {
            NSLog(@"Unable to create JPEG data.");
            completionHandler(NO, nil);
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

            PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
            PHAssetResourceCreationOptions *creationOptions = [[PHAssetResourceCreationOptions alloc] init];
            creationOptions.shouldMoveFile = YES;
            [creationRequest addResourceWithType:PHAssetResourceTypePhoto data:jpegData options:nil];
            [creationRequest addResourceWithType:PHAssetResourceTypePairedVideo fileURL:livePhotoMovieURL options:creationOptions];
            
        } completionHandler: completionHandler];
    }];
}


@end
