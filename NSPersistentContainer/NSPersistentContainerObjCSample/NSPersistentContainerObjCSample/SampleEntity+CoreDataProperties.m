//
//  SampleEntity+CoreDataProperties.m
//  NSPersistentContainerObjCSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "SampleEntity+CoreDataProperties.h"

@implementation SampleEntity (CoreDataProperties)

+ (NSFetchRequest<SampleEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SampleEntity"];
}

@dynamic name;

@end
