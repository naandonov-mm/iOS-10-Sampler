//
//  CoreDataStack.m
//  NSPersistentContainerObjCSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack()

@property (strong, nonatomic, readwrite) NSPersistentContainer *persistentContainer;

@end

@implementation CoreDataStack

+ (instancetype)sharedInstance {
    
    static CoreDataStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataStack alloc] init];
    });
    return sharedInstance;
}

- (NSPersistentContainer *)persistentContainer {
    
    @synchronized (self) {
        if (_persistentContainer) {
            return _persistentContainer;
        }
        
        NSPersistentContainer *persistentContainer = [NSPersistentContainer persistentContainerWithName:@"NSPersistentContainerObjCsSampleModel"];
        [persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
            if (error) {
                NSLog(@"Unresolved Error %@", error);
            }
        }];
        _persistentContainer = persistentContainer;
        return persistentContainer;
    }
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    if (context.hasChanges) {
        NSError *error = nil;
        [context save:&error];
        if (error) {
            NSLog(@"Unresolved error %@", error);
        }
    }
    
    
}


@end
