//
//  PreviewInteractionMainViewController.m
//  UIPreviewInteractionObjCSample
//
//  Created by nikolay.andonov on 10/17/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "PreviewInteractionMainViewController.h"
#import "PreviewInteractionPopViewController.h"

@interface PreviewInteractionMainViewController () <UIPreviewInteractionDelegate>
@property (weak, nonatomic) PreviewInteractionPopViewController *popViewController;
@property (strong, nonatomic) UIPreviewInteraction *previewInteraction;

@end

@implementation PreviewInteractionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previewInteraction = [[UIPreviewInteraction alloc] initWithView: self.view];
    self.previewInteraction.delegate = self;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[PreviewInteractionPopViewController class]]) {
        self.popViewController = segue.destinationViewController;
    }
}

#pragma mark - UIPreviewInteractionDelegate

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdatePreviewTransition:(CGFloat)transitionProgress ended:(BOOL)ended {
    
    if (!self.popViewController) {
        [self performSegueWithIdentifier:@"InteractionSegue" sender:nil];
    }
    self.popViewController.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", transitionProgress * 100];
    
    if (ended) {
        self.popViewController.statusLabel.text = @"Peek!";
    }
}

- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdateCommitTransition:(CGFloat)transitionProgress ended:(BOOL)ended {
    
    self.popViewController.animator.fractionComplete = transitionProgress;
    self.popViewController.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", transitionProgress * 100];
    if (ended) {
        self.popViewController.statusLabel.text = @"Pop!";
    }
}

- (void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction {
    
    self.popViewController.statusLabel.text = @"";
    [self.popViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
