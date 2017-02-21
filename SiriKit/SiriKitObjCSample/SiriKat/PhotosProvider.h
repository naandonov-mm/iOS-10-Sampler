//
//  PhotosProvider.h
//  SiriKat
//
//  Created by Dobrinka Tabakova on 12/5/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PhotosProvider : NSObject

+ (instancetype)sharedInstance;
- (NSArray*)allPhotos;
- (UIImage*)photoForSearchTerm:(NSString*)term;
- (BOOL)containsPhotoForSearchTerm:(NSString*)term;

@end
