//
//  MainCollectionViewCell.m
//  UICollectionViewDataSourcePrefetchingObjCSample
//
//  Created by Nikolay Andonov on 10/19/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import "MainCollectionViewCell.h"

@implementation MainCollectionViewCell

- (void)prepareForReuse {
    [self.activityIndicator startAnimating];
    self.imageView.image = nil;
}

@end
