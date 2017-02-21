//
//  CapturePhotoHandler.h
//  AVCapturePhotoOutputObjectiveCSample
//
//  Created by Nikolay Andonov on 12/6/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CapturePhotoHandlerDelegate <NSObject>

- (void)didEndCapturingLivePhotoWithSuccess:(BOOL)success;

@end

@interface CapturePhotoHandler : NSObject

@property(nonatomic, weak) id<CapturePhotoHandlerDelegate> delegate;

+ (instancetype)sharedHandler;

- (BOOL)isLivePhotoSupported;
- (void)createCaptureSessionForView:(UIView *)view;
- (void)takeLivePhoto;

@end
