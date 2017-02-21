//
//  MainViewController.m
//  AVCapturePhotoOutputObjectiveCSample
//
//  Created by Nikolay Andonov on 12/6/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import "MainViewController.h"
#import "CapturePhotoHandler.h"

@interface MainViewController () <CapturePhotoHandlerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIView *cameraOverlayView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CapturePhotoHandler sharedHandler] createCaptureSessionForView:self.cameraOverlayView];
    [CapturePhotoHandler sharedHandler].delegate = self;
}

- (void)dealloc {
    
    [CapturePhotoHandler sharedHandler].delegate = nil;
}

- (IBAction)takeLivePhotoButtonAction:(id)sender {
    
    if ([[CapturePhotoHandler sharedHandler] isLivePhotoSupported]) {
        
        [[CapturePhotoHandler sharedHandler] takeLivePhoto];
        self.takePhotoButton.enabled = NO;
    }
    else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Live Photo capture is not supported on this device" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - CapturePhotoHandlerDelegate

- (void)didEndCapturingLivePhotoWithSuccess:(BOOL)success {
    
    self.takePhotoButton.enabled = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Live Photo was captured" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


@end
