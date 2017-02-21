//
//  ViewController.m
//  SiriKat
//
//  Created by Dobrinka Tabakova on 12/5/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

#import "ViewController.h"
#import "PhotosProvider.h"
#import "DetailViewController.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PhotosProvider *provider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.provider = [PhotosProvider sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.provider.allPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.provider.allPhotos[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *imageName = self.provider.allPhotos[indexPath.row];
    [self performSegueWithIdentifier:@"Show" sender:imageName];
}

#pragma mark - Public

- (void)showPhotoForSearchTerm:(NSString*)searchTerm {
    if ([[PhotosProvider sharedInstance] containsPhotoForSearchTerm:searchTerm]) {
        [self performSegueWithIdentifier:@"Show" sender:searchTerm];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class]] && [sender isKindOfClass:[NSString class]]) {
        DetailViewController *detailViewController = (DetailViewController*)segue.destinationViewController;
        NSString *imageName = (NSString*)sender;
        detailViewController.image = [self.provider photoForSearchTerm:imageName];
    }
}


@end
