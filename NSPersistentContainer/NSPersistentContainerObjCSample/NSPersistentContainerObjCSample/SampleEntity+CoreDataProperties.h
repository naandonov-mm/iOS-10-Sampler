//
//  SampleEntity+CoreDataProperties.h
//  NSPersistentContainerObjCSample
//
//  Created by nikolay.andonov on 10/10/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "SampleEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SampleEntity (CoreDataProperties)

+ (NSFetchRequest<SampleEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
