//
//  CoreDataHandler.h
//  NSPersistentContainerObjCSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SampleEntity+CoreDataProperties.h"
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

@interface CoreDataHandler : NSObject

+ (void)loadHardcodedDatabaseIfNeccessary;
+ (void)insertSampleEntityWithName:(NSString *)name context:(NSManagedObjectContext *)context;
+ (NSArray<SampleEntity *> *)fetchAllSamplesWithContext:(NSManagedObjectContext *)context;

@end
