//
//  MainTableViewController.m
//  NSQueryGenerationTokenObjCSample
//
//  Created by nikolay.andonov on 10/31/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

#import "MainTableViewController.h"
#import "CoreDataHandler.h"

@interface MainTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *firstGenButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentGenButton;
@property (strong, nonatomic) NSArray<SampleEntity *> *samplesArray;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTableView];
    
    NSManagedObjectContext *context = [CoreDataStack sharedInstance].persistentContainer.viewContext;
    [[CoreDataHandler sharedHandler] setCurrentGenerationTokenOnMainContext];
    //The initial fetch would create and save a token associated with the first generation
    self.samplesArray = [[CoreDataHandler sharedHandler] fetchAllSamplesWithContext:context];
    
}

- (void)configureTableView {
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.samplesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    SampleEntity *sampleEntity = self.samplesArray[indexPath.row];
    cell.textLabel.text = sampleEntity.name;
    
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Button Actions

- (IBAction)firstGenButtonAction:(id)sender {
    
    self.currentGenButton.enabled = YES;
    self.firstGenButton.enabled = NO;
    [[CoreDataHandler sharedHandler] setFirstGenerationTokenOnMainContext];
    [self.tableView reloadData];
}

- (IBAction)currentGenButtonAction:(id)sender {
    
    //Performing data modification specific for the current generation
    [[CoreDataHandler sharedHandler] generateDataUpdate];
    
    self.currentGenButton.enabled = NO;
    self.firstGenButton.enabled = YES;
    [[CoreDataHandler sharedHandler] setCurrentGenerationTokenOnMainContext];
    [self.tableView reloadData];
}

@end
