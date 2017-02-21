//
//  UserNotificationsHandler.h
//  UserNotificationsObjCSample
//
//  Created by Nikolay Andonov on 11/9/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNotificationsHandler : NSObject

+ (instancetype)sharedHandler;
- (void)userNotificationsInitialSetup;
- (void)scheduleNotificationAtDate:(NSDate *)date;

@end
