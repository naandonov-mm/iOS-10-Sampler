//
//  SampleEntity+CoreDataProperties.h
//  NSQueryGenerationTokenObjCSample
//
//  Created by nikolay.andonov on 11/1/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SampleEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SampleEntity (CoreDataProperties)

+ (NSFetchRequest<SampleEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
