//
//  OutgoingCallViewController.m
//  CallKit
//
//  Created by Dobrinka Tabakova on 9/26/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import "OutgoingCallViewController.h"
#import "CallViewController.h"


static NSString *const kTitle = @"Dial Call";

@interface OutgoingCallViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dialButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end

@implementation OutgoingCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kTitle;
}

#pragma mark - Actions

- (IBAction)phoneNumberValueChanged:(UITextField*)sender {
    NSString *phoneNumber = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.dialButton.enabled = (phoneNumber.length);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowDial"]) {
        CallViewController* callViewController = [segue destinationViewController];
        callViewController.phoneNumber = self.phoneNumberTextField.text;
    }
}

@end

