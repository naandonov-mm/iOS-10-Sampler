//
//  UserNotificationsHandler.m
//  UserNotificationsObjCSample
//
//  Created by Nikolay Andonov on 11/9/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import "UserNotificationsHandler.h"
#import <UserNotifications/UserNotifications.h>

static NSString *const RemindLaterActionIdentifier = @"remindLater";
static NSString *const LogoAttachmentIdentifier = @"logo";
static NSString *const NotificationCategoryIdentifier = @"myCategory";
static NSString *const NotificationRequestIdentifier = @"myNotificationRequest";

@interface UserNotificationsHandler() <UNUserNotificationCenterDelegate>

@end

@implementation UserNotificationsHandler

+ (instancetype)sharedHandler {
    
    static UserNotificationsHandler *userNotificationHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userNotificationHandler = [[UserNotificationsHandler alloc] init];
    });
    
    return userNotificationHandler;
}

- (void)userNotificationsInitialSetup {
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions: (UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"Notification access denied.");
        }
    }];
    
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:RemindLaterActionIdentifier title:@"Remind me later" options:0];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:NotificationCategoryIdentifier actions:@[action] intentIdentifiers:@[] options:0];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:category]];
}

- (void)scheduleNotificationAtDate:(NSDate *)date {

    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone localTimeZone] fromDate:date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone localTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    content.title = @"Reminder";
    content.body = @"Reminder to do some generic activity";
    content.sound = [UNNotificationSound defaultSound];
    content.categoryIdentifier = NotificationCategoryIdentifier;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType: @"png"];
    if (path) {
        
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *attachmentError = nil;
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:LogoAttachmentIdentifier URL:url options:nil error:&attachmentError];
        if (attachmentError) {
            NSLog(@"The attachment was not loaded.");
        }
        else {
            content.attachments = @[attachment];
        }
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:NotificationRequestIdentifier content:content trigger:trigger];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error occured: %@", error);
        }
    }];
    
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    completionHandler();
    if ([response.actionIdentifier isEqualToString: RemindLaterActionIdentifier]) {
        NSDate *newDate = [NSDate dateWithTimeInterval: 5 * 60 sinceDate:[NSDate date]];
        [self scheduleNotificationAtDate:newDate];
    }
}



@end
