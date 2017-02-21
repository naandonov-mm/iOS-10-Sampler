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

+ (instancetype)sharedHandler;

- (void)loadHardcodedDatabase;
- (NSArray<SampleEntity *> *)fetchAllSamplesWithContext:(NSManagedObjectContext *)context;
- (void)setFirstGenerationTokenOnMainContext;
- (void)setCurrentGenerationTokenOnMainContext;
- (void)generateDataUpdate;

@end
