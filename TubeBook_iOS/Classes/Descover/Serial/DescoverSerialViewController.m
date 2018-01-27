//
//  DescoverSerialViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DescoverSerialViewController.h"
#import "DescoverSerialContent.h"
#import "SerialCollectionViewCell.h"

@interface DescoverSerialViewController () <RefreshTableViewControllerDelegate>

@end

@implementation DescoverSerialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[SerialCollectionViewCell class] forKeyContent:[DescoverSerialContent class]];
    [self registerClass:[SerialCollectionViewCell class] forCellWithReuseIdentifier:[SerialCollectionViewCell getDequeueId:nil]];
    DescoverSerialContent *c = [[DescoverSerialContent alloc] init];
    c.serialTitle = @"KEKKKEKKEEEKKEKEKKbkwabdkjwadbkawbdkjawbdkjbawkdjbawkdadnwaldnlwawdaw";
    [self.contentData addObject:c];
    for (int i=0; i<10; ++i) {
        DescoverSerialContent *c = [[DescoverSerialContent alloc] init];
        c.serialTitle = @"adnwaldnlwawdaw";
        [self.contentData addObject:c];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
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
