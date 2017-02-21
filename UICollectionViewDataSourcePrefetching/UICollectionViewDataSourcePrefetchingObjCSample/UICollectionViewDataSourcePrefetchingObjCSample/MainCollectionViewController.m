//
//  MainCollectionViewController.m
//  UICollectionViewDataSourcePrefetchingObjCSample
//
//  Created by Nikolay Andonov on 10/19/16.
//  Copyright © 2016 Mentormate. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "MainCollectionViewCell.h"

static CGFloat const CollectionViewCellPadding = 10;
static NSInteger const NumberOfCellsPerRow = 2;

@interface MainCollectionViewController () <UICollectionViewDataSourcePrefetching>

@property (assign, nonatomic) CGFloat collectionViewCellSize;

@property (strong, nonatomic) NSMutableArray<NSURL *> *imageURLs;
@property (strong, nonatomic) NSOperationQueue *downloadImageOperationQueue;
@property (strong, nonatomic) NSMutableDictionary<NSURL *, NSBlockOperation *> *operations;
@property (strong, nonatomic) NSMutableDictionary<NSURL *, UIImage *> *images;


@end

@implementation MainCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    [self populateModels];
    
    [self.collectionView reloadData];
}

- (void)configureCollectionView {
    
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    CGFloat cellsAreaOnSingleRow = screenWidth - ((NumberOfCellsPerRow + 1) * CollectionViewCellPadding);
    self.collectionViewCellSize = cellsAreaOnSingleRow / NumberOfCellsPerRow;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(CollectionViewCellPadding, CollectionViewCellPadding, CollectionViewCellPadding, CollectionViewCellPadding);
    
    self.collectionView.prefetchDataSource = self;
}

- (void)populateModels {
    
    self.downloadImageOperationQueue = [[NSOperationQueue alloc] init];

    self.imageURLs = [NSMutableArray array];
    self.operations = [NSMutableDictionary dictionary];
    self.images = [NSMutableDictionary dictionary];
    
    //Simulating initial load of content
    for (NSInteger counter = 0; counter < 50; counter++) {
        
        //Simulating slow download using large images
        NSString *imageStringAdress = [NSString stringWithFormat:@"http://placehold.it/2000x2000&text=SampleImage%ld",(long)(counter + 1)];
        NSURL *imageURL = [NSURL URLWithString:imageStringAdress];
        [self.imageURLs addObject:imageURL];
    }
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSURL *imageURL = self.imageURLs[indexPath.row];
    if (self.images[imageURL]) {
        cell.imageView.image = self.images[imageURL];
        [cell.activityIndicator stopAnimating];
    }
    else {
        [self executeDownloadImageOperationBlockForIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionViewCellSize, self.collectionViewCellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self cancelDowloandImageOperationBlockForIndexPath:indexPath];
}


#pragma mark <UICollectionViewDataSourcePrefetching>

// indexPaths are ordered ascending by geometric distance from the collection view
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
    for (NSIndexPath *indexPath in indexPaths) {
        
        // Updating upcoming CollectionView's data source. Not assiging any direct value
        // as this operation is expensive it is performed on a private queue
        NSURL *imageURL = self.imageURLs[indexPath.row];
        if (!self.images[imageURL]) {
            [self executeDownloadImageOperationBlockForIndexPath:indexPath];
            NSLog(@"Prefetching data for indexPath: %@", indexPath);
        }
    }
}

// indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -collectionView:prefetchItemsAtIndexPaths:
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
    for (NSIndexPath *indexPath in indexPaths) {
        
        //Unloading or data load operation cancellations should happend here
        NSURL *imageURL = self.imageURLs[indexPath.row];
        if (self.operations[imageURL]) {
            [self cancelDowloandImageOperationBlockForIndexPath:indexPath];
            NSLog(@"Unloading data fetch in progress for indexPath: %@", indexPath);
        }
    }
    
}

#pragma mark - Utilities

- (void)executeDownloadImageOperationBlockForIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *url = self.imageURLs[indexPath.row];
    NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakBlockOperation = blockOperation;
    __weak typeof(self) weakSelf = self;
    
    [blockOperation addExecutionBlock:^{
        if (weakBlockOperation.isCancelled) {
            weakSelf.operations[url] = nil;
            return;
        }
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        weakSelf.images [url] = image;
        weakSelf.operations[url] = nil;
        
        NSArray *visibleCellIndexPaths = [weakSelf.collectionView indexPathsForVisibleItems];
        if ([visibleCellIndexPaths containsObject:indexPath]) {
            
            MainCollectionViewCell *cell = (MainCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
                [cell.activityIndicator stopAnimating];
            });
        }
    }];
    [self.downloadImageOperationQueue addOperation:blockOperation];
    self.operations[url] = blockOperation;
    
}

- (void)cancelDowloandImageOperationBlockForIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *imageURL = self.imageURLs[indexPath.row];
    if (self.operations[imageURL]) {
        NSBlockOperation *blockOperation = self.operations[imageURL];
        [blockOperation cancel];
        self.operations[imageURL] = nil;
    }
}

@end
