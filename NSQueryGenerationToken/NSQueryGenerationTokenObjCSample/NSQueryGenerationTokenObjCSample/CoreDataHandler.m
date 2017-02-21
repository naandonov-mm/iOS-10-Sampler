//
//  CoreDataHandler.m
//  NSPersistentContainerObjCSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "CoreDataHandler.h"

@interface CoreDataHandler()

@property (nonatomic, strong) NSQueryGenerationToken *firstGenerationToken;

@end

@implementation CoreDataHandler

+ (instancetype)sharedHandler {
    
    static CoreDataHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataHandler alloc] init];
    });
    
    return sharedInstance;
}

- (void)loadHardcodedDatabase{
    
    CoreDataStack *sharedDataStack = [CoreDataStack sharedInstance];
    NSManagedObjectContext *context = sharedDataStack.persistentContainer.viewContext;
    
    NSArray<SampleEntity *> *allSamples = [self fetchAllSamplesWithContext:context];
    for (SampleEntity *sampleEntity in allSamples) {
        [context deleteObject:sampleEntity];
    }
    
    for (NSInteger i = 1; i < 10; i++) {
        NSString *name = [NSString stringWithFormat:@"Entity #%ld",(long)i];
        [self insertSampleEntityWithName:name context:context];
    }
    
    [context performBlockAndWait:^{
        
        [sharedDataStack saveContext];
    }];
}

- (void)insertSampleEntityWithName:(NSString *)name context:(NSManagedObjectContext *)context {
    
    SampleEntity *sampleEntity = [[SampleEntity alloc] initWithContext:context];
    sampleEntity.name = name;
}

- (NSArray<SampleEntity *> *)fetchAllSamplesWithContext:(NSManagedObjectContext *)context {
    
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
    
    if (!self.firstGenerationToken) {
         //New NSQueryGenerationToken object is created and assigned to the context during each database transaction
        self.firstGenerationToken = context.queryGenerationToken;
    }
    
    return result;
}

- (void)setFirstGenerationTokenOnMainContext{
    
    if (self.firstGenerationToken) {
        CoreDataStack *sharedDataStack = [CoreDataStack sharedInstance];
        NSManagedObjectContext *context = sharedDataStack.persistentContainer.viewContext;
        
        __weak typeof(self)weakSelf = self;
        [context performBlockAndWait:^{
           
            NSError *error = nil;
            [context setQueryGenerationFromToken:weakSelf.firstGenerationToken error:&error];
            //NSQueryGenerationToken tells the context to lazily retrieve the most recent version on its next read operation (fetching or faulting)
            //So in order to retrive the updated data from already fired properties we are refreshing all the objects in the context
            [context refreshAllObjects];
        }];
        
    }
}

- (void)setCurrentGenerationTokenOnMainContext{
    
        CoreDataStack *sharedDataStack = [CoreDataStack sharedInstance];
        NSManagedObjectContext *context = sharedDataStack.persistentContainer.viewContext;
        
        [context performBlockAndWait:^{
            
            NSError *error = nil;
            [context setQueryGenerationFromToken:[NSQueryGenerationToken currentQueryGenerationToken] error:&error];
            //NSQueryGenerationToken tells the context to lazily retrieve the most recent version on its next read operation (fetching or faulting)
            //So in order to retrive the updated data from already fired properties we are refreshing all the objects in the context
            [context refreshAllObjects];
        }];
}

- (void)generateDataUpdate {
    
    //Updating the persitent data on a background context
    CoreDataStack *sharedDataStack = [CoreDataStack sharedInstance];
    NSManagedObjectContext *backgroundManagedObjectContext = sharedDataStack.persistentContainer.newBackgroundContext;
    
    [backgroundManagedObjectContext performBlockAndWait:^{
       
        NSBatchUpdateRequest *update = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:NSStringFromClass([SampleEntity class])];
        update.propertiesToUpdate = @{@"name" : [NSExpression expressionForConstantValue:@"New Cell"]};
        NSError *error = nil;
        [backgroundManagedObjectContext executeRequest:update error:&error];
        
        if (error) {
            NSLog(@"Error executing update: %@",error);
        }
        
        
    }];
}


@end
