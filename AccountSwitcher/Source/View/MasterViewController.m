//
//  MasterViewController.m
//  AccountSwitcher
//
//  Created by Jonah Grant on 2/14/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "MasterViewController.h"
#import "HeaderView.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInterface];
    
    self.title = @"Me";
    
    HeaderView *headerView = [[HeaderView alloc] initWithScrollView:self.tableView
                                                       profileImage:[UIImage imageNamed:@"profileImage"]];
    
    [self.tableView addSubview:headerView];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame))]];
}

- (void)setInterface {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.321569 green:0.674510 blue:0.933333 alpha:1.0000];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; // this sets the navigation and status bar's text to white
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = @"Cell";

    return cell;
}

@end
