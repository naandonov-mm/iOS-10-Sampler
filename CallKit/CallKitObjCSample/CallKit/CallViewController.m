//
//  CallViewController.m
//  CallKit
//
//  Created by Dobrinka Tabakova on 9/26/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import "CallViewController.h"
#import "CallManager.h"


@interface CallViewController () <CallManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *callerLabel;
@property (weak, nonatomic) IBOutlet UIButton *holdButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@property (nonatomic, strong) NSDateComponentsFormatter *timeFormatter;
@property (nonatomic, strong) NSTimer *callDurationTimer;

@property (nonatomic, assign) NSTimeInterval callDuration;
@property (nonatomic, assign) BOOL isOnHold;

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.callerLabel.text = self.phoneNumber;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.phoneNumber) {
        [CallManager sharedInstance].delegate = self;
        if (self.isIncoming) {
            [self performSelector:@selector(performCall) withObject:nil afterDelay:2.f];
        } else {
            [[CallManager sharedInstance] startCallWithPhoneNumber:self.phoneNumber];
        }
    }
}

#pragma mark - Getters

- (NSDateComponentsFormatter*)timeFormatter {
    if (!_timeFormatter) {
        _timeFormatter = [[NSDateComponentsFormatter alloc] init];
        _timeFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
        _timeFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
        _timeFormatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    }
    return _timeFormatter;
}

#pragma mark - Actions

- (IBAction)endButtonTapped:(id)sender {
    [[CallManager sharedInstance] endCall];
}

- (IBAction)holdButtonTapped:(UIButton*)sender {
    self.isOnHold = !self.isOnHold;
    [self.holdButton setTitle:(self.isOnHold ? @"RESUME" : @"HOLD") forState:UIControlStateNormal];
    [[CallManager sharedInstance] holdCall:self.isOnHold];
}

#pragma mark - CallManagerDelegate

- (void)callDidAnswer {
    self.timeLabel.hidden = NO;
    self.holdButton.hidden = NO;
    self.endButton.hidden = NO;
    self.infoLabel.text = @"Active";
    [self startTimer];
}

- (void)callDidEnd {
    [self.callDurationTimer invalidate];
    self.callDurationTimer = nil;
    self.holdButton.hidden = YES;
    self.endButton.hidden = YES;
    self.infoLabel.text = @"Ended";
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.f];
}

- (void)callDidHold:(BOOL)isOnHold {
    if (isOnHold) {
        [self.callDurationTimer invalidate];
        self.callDurationTimer = nil;
        [self.holdButton setTitle:@"RESUME" forState:UIControlStateNormal];
        self.infoLabel.text = @"On Hold";
    } else {
        [self startTimer];
        [self.holdButton setTitle:@"HOLD" forState:UIControlStateNormal];
        self.infoLabel.text = @"Active";
    }
}

- (void)callDidFail {
    [self.callDurationTimer invalidate];
    self.callDurationTimer = nil;
    self.infoLabel.text = @"Failed";
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.f];
}

#pragma mark - Utilities

- (void)performCall {
    [[CallManager sharedInstance] reportIncomingCallForUUID:self.uuid phoneNumber:self.phoneNumber];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startTimer {
    __weak CallViewController *weakSelf = self;
    self.callDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.timeLabel.text = [weakSelf.timeFormatter stringFromTimeInterval:weakSelf.callDuration++];
    }];
}

@end


