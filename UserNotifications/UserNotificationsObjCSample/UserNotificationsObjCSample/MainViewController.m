//
//  MainViewController.m
//  UserNotificationsObjCSample
//
//  Created by Nikolay Andonov on 11/9/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import "MainViewController.h"
#import "UserNotificationsHandler.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)scheduleButtonAction:(id)sender {
    
    NSDate *selectedDate = self.datePicker.date;
    NSLog(@"Selected date: %@",selectedDate);
    [[UserNotificationsHandler sharedHandler] scheduleNotificationAtDate:selectedDate];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"The reminder was scheduled!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
