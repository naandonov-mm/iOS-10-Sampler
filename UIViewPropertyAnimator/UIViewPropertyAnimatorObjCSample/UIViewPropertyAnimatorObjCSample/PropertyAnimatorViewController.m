//
//  ViewController.m
//  UIViewPropertyAnimatorObjCSample
//
//  Created by nikolay.andonov on 10/3/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "PropertyAnimatorViewController.h"

@interface PropertyAnimatorViewController ()

@property (weak, nonatomic) IBOutlet UIView *objectView;

@property (strong, nonatomic) UIViewPropertyAnimator *animator;
@property (assign, nonatomic) CGPoint targetLocation;

@end

@implementation PropertyAnimatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.objectView.backgroundColor = [self colorAtLocation:self.objectView.center];
    self.view.userInteractionEnabled = YES;
    self.targetLocation = self.objectView.center;
}

#pragma mark - Utilities

- (UIColor *)colorAtLocation:(CGPoint)location {
    
    CGFloat hue = (location.x / CGRectGetWidth([UIScreen mainScreen].bounds) + location.y / CGRectGetHeight([UIScreen mainScreen].bounds)) / 2;
    return [UIColor colorWithHue:hue saturation:0.78 brightness:0.75 alpha:1];
}

- (void)processTouches:(NSSet<UITouch *> *)touches {
    
    UITouch *touch = [touches anyObject];
    if (!touch) {
        return;
    }
    
    CGPoint loc = [touch locationInView:self.view];
    if (CGPointEqualToPoint(loc, self.targetLocation)) {
        return;
    }
    
    [self animateToLocation:loc];
}

- (void)animateToLocation:(CGPoint)location {
    
    NSTimeInterval duration = 0.6;
    id<UITimingCurveProvider> timing = [[UISpringTimingParameters alloc] initWithDampingRatio:0.5];
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration timingParameters:timing];
    
    __weak typeof(self) weakSelf = self;
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:duration dampingRatio:0.5 animations:^{
        weakSelf.objectView.center = location;
        weakSelf.objectView.backgroundColor = [weakSelf colorAtLocation:location];
    }];
    [self.animator startAnimation];
    
    self.targetLocation = location;
}

#pragma mark - Touch handlers

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self processTouches:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self processTouches:touches];
}





@end
