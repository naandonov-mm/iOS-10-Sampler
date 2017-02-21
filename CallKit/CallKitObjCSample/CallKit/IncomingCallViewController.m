//
//  IncomingCallViewController.m
//  CallKit
//
//  Created by Dobrinka Tabakova on 9/26/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import "IncomingCallViewController.h"
#import "CallViewController.h"


static NSString *const kTitle = @"Incoming Call";

@interface IncomingCallViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *simulateCallButton;

@end


@implementation IncomingCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kTitle;
}

#pragma mark - Actions

- (IBAction)phoneNumberValueChanged:(UITextField*)sender {
    NSString *phoneNumber = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.simulateCallButton.enabled = (phoneNumber.length);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowCall"]) {
        CallViewController* callViewController = [segue destinationViewController];
        callViewController.phoneNumber = self.phoneNumberTextField.text;
        callViewController.isIncoming = YES;
        callViewController.uuid = [NSUUID new];
    }
}

@end

