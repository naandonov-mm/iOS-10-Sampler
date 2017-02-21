//
//  CallViewController.h
//  CallKit
//
//  Created by Dobrinka Tabakova on 9/26/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallViewController : UIViewController

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonnull, strong) NSUUID *uuid;
@property (nonatomic, assign) BOOL isIncoming;

@end
