//
//  AuthorViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AuthorViewController.h"
#import "UserContent.h"
#import "UIUserTableCell.h"


@interface AuthorViewController () <RefreshTableViewControllerDelegate>

@end

@implementation AuthorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UIUserTableCell class] forKeyContent:[UserContent class]];
    for (int i=0; i<10; ++i) {
        [self.contentData addObject:[[UserContent alloc] init]];
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
