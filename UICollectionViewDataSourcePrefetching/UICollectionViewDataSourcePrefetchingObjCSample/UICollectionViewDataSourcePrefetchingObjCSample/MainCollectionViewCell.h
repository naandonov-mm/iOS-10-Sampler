//
//  MainCollectionViewCell.h
//  UICollectionViewDataSourcePrefetchingObjCSample
//
//  Created by Nikolay Andonov on 10/19/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
