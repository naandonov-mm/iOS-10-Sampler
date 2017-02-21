//
//  SampleEntity+CoreDataProperties.m
//  NSQueryGenerationTokenObjCSample
//
//  Created by nikolay.andonov on 11/1/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SampleEntity+CoreDataProperties.h"

@implementation SampleEntity (CoreDataProperties)

+ (NSFetchRequest<SampleEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SampleEntity"];
}

@dynamic name;

@end
