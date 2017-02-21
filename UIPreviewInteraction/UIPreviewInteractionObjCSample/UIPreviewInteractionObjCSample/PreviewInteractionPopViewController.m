//
//  PreviewInteractionPopViewController.m
//  UIPreviewInteractionObjCSample
//
//  Created by nikolay.andonov on 10/17/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "PreviewInteractionPopViewController.h"

@interface PreviewInteractionPopViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *sampleImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;

@end

@implementation PreviewInteractionPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.progressLabel.text = @"";
    self.statusLabel.text = @"";
    
    __weak typeof(self) weakSelf = self;
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:0 curve:UIViewAnimationCurveLinear animations:^{
        weakSelf.effectView.effect = nil;
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    [self.sampleImageView addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.animator.fractionComplete = 0;
}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)recognizer {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
