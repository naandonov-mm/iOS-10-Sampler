//
//  CoreDataHandler.m
//  NSPersistentContainerObjCSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "CoreDataHandler.h"

@implementation CoreDataHandler

+ (void)loadHardcodedDatabaseIfNeccessary {
    
    CoreDataStack *sharedDataStack = [CoreDataStack sharedInstance];
    NSManagedObjectContext *context = sharedDataStack.persistentContainer.viewContext;
    
    NSArray<SampleEntity *> *allSamples = [self fetchAllSamplesWithContext:context];
    if (allSamples && allSamples.count > 0) {
        return;
    }
    
    for (NSInteger i = 1; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"Entity #%ld",(long)i];
        [self insertSampleEntityWithName:name context:context];
    }
    
    [context performBlockAndWait:^{
        
        [sharedDataStack saveContext];
    }];
}

+ (void)insertSampleEntityWithName:(NSString *)name context:(NSManagedObjectContext *)context {
    
    SampleEntity *sampleEntity = [[SampleEntity alloc] initWithContext:context];
    sampleEntity.name = name;
}

+ (NSArray<SampleEntity *> *)fetchAllSamplesWithContext:(NSManagedObjectContext *)context {
    
    __block NSArray<SampleEntity *> *result = nil;
    [context performBlockAndWait:^{
        
        NSFetchRequest *request = [SampleEntity fetchRequest];
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        request.sortDescriptors = @[nameSortDescriptor];
        NSError *error = nil;
        
        result = [context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"Unresolved Error: %@", error);
        }
    }];
    return result;
}

@end
