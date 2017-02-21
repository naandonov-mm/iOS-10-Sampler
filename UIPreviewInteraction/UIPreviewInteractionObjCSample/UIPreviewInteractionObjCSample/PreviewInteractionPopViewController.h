//
//  PreviewInteractionPopViewController.h
//  UIPreviewInteractionObjCSample
//
//  Created by nikolay.andonov on 10/17/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewInteractionPopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) UIViewPropertyAnimator *animator;

@end
