//
//  TopicViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicTagContent.h"
#import "UITopicTableCell.h"

@interface TopicViewController () <RefreshTableViewControllerDelegate>

@end

@implementation TopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UITopicTableCell class] forKeyContent:[TopicTagContent class]];
    for (int i=0; i<10; ++i) {
        [self.contentData addObject:[[TopicTagContent alloc] init]];
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
