//
//  SerialViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "SerialViewController.h"
#import "SerialTagContent.h"
#import "UISerialTableCell.h"

@interface SerialViewController () <RefreshTableViewControllerDelegate>

@end

@implementation SerialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UISerialTableCell class] forKeyContent:[SerialTagContent class]];
    for (int i=0; i<10; ++i) {
        [self.contentData addObject:[[SerialTagContent alloc] init]];
    }
}

- (void)refreshData
{
    NSLog(@"refreshData");
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

@end
