//
//  DescoverRecommendViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DescoverRecommendViewController.h"
#import "SDCycleScrollView.h"
#import "CycleContent.h"
#import "CycleTableCell.h"

@interface DescoverRecommendViewController () <RefreshTableViewControllerDelegate>

@end

@implementation DescoverRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[CycleTableCell class] forKeyContent:[CycleContent class]];
    for (int i=0; i<1; ++i) {
        [self.contentData addObject:[[CycleContent alloc] init]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
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
