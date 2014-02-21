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

@property (strong, nonatomic) HeaderView *headerView;
@property (nonatomic) BOOL isSwitchingAccounts;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInterface];
    
    self.title = @"Me";
    
    _headerView = [[HeaderView alloc] initWithScrollView:self.tableView
                                            profileImage:[UIImage imageNamed:@"profileImage"]];
    
    [self.view addSubview:_headerView];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_headerView.frame), CGRectGetHeight(_headerView.frame))]];
}

- (void)setInterface {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.321569 green:0.674510 blue:0.933333 alpha:1.0000];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; // this sets the navigation and status bar's text to white
}

- (void)switchAccountsWithState:(BOOL)openOrClosed {
    if (openOrClosed) {
        _isSwitchingAccounts = YES;
        [self.tableView reloadData];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [_headerView setFrame:CGRectMake(0, 0, 320, 400)];
        [self.view addSubview:_headerView];
    } else {
        _isSwitchingAccounts = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - UIScrollView

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_headerView.shouldSwitch) {
        [self switchAccountsWithState:YES];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isSwitchingAccounts ? 0 : 1;
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
