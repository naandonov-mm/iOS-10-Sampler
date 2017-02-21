//
//  CoreDataStack.h
//  NSPersistentContainerObjCSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedInstance;
- (void)saveContext;

@end
