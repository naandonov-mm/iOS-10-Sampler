//
//  PhotosProvider.m
//  SiriKat
//
//  Created by Dobrinka Tabakova on 12/5/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import "PhotosProvider.h"


@interface PhotosProvider () {
    NSDictionary *photos;
}

@end

@implementation PhotosProvider

+ (instancetype)sharedInstance {
    static PhotosProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PhotosProvider alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *keys = @[@"cat", @"dog", @"duck", @"pig", @"seal"];
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        for (NSString *key in keys) {
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg", key];
            result[key] = [UIImage imageNamed:imageName];
        }
        photos = [[NSDictionary alloc] initWithDictionary:result];
    }
    return self;
}

- (NSArray*)allPhotos {
    return photos.allKeys;
}

- (UIImage*)photoForSearchTerm:(NSString*)term {
    return photos[term];
}

- (BOOL)containsPhotoForSearchTerm:(NSString*)term {
    return (photos[term] != nil);
}

@end

