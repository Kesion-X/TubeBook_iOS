//
//  RecommendViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "RecommendViewController.h"
#import "UserContent.h"
#import "UIUserTableCell.h"
#import "SerialTagContent.h"
#import "UISerialTableCell.h"
#import "TopicTagContent.h"
#import "UITopicTableCell.h"

@interface RecommendViewController () <RefreshTableViewControllerDelegate>

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UITopicTableCell class] forKeyContent:[TopicTagContent class]];
    [self registerCell:[UISerialTableCell class] forKeyContent:[SerialTagContent class]];
    [self registerCell:[UIUserTableCell class] forKeyContent:[UserContent class]];
    for (int i=0; i<10; ++i) {
        [self.contentData addObject:[[SerialTagContent alloc] init]];
        [self.contentData addObject:[[UserContent alloc] init]];
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
