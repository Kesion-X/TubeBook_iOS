//
//  NewestViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "NewestViewController.h"
#import "UIRefreshTableView.h"
#import "Masonry.h"
#import "UIHomeCellItemHeadView.h"
#import "UIHomeCellItemFootView.h"
#import "UIHomeCellItemContentView.h"
#import "NormalArticleContent.h"
#import "UINormalArticleCell.h"
#import "CKTableCell.h"
#import "UISerialArticleCell.h"
#import "TopicArticleContent.h"
#import "SerialArticleContent.h"
#import "TopicArticleContent.h"
#import "UITopicArticleCell.h"

@interface NewestViewController () <RefreshTableViewControllerDelegate>

@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UINormalArticleCell class] forKeyContent:[NormalArticleContent class]];
    [self registerCell:[UISerialArticleCell class] forKeyContent:[SerialArticleContent class]];
    [self registerCell:[UITopicArticleCell class] forKeyContent:[TopicArticleContent class]];
    for (int i=0; i<10; ++i) {
        CKContent *content = [[NormalArticleContent alloc] init];
        content.dataType.userState = i%2;
        content.dataType.isHaveImage = i%2;
        [self.contentData addObject:content];
        CKContent *content2 = [[SerialArticleContent alloc] init];
        content2.dataType.userState = i%2;
        content2.dataType.isHaveImage = i%2;
        [self.contentData addObject:content2];
        CKContent *content3 = [[TopicArticleContent alloc] init];
        content3.dataType.userState = i%2;
        content3.dataType.isHaveImage = i%2;
        [self.contentData addObject:content3];
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
