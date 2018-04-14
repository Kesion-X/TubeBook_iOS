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
#import "TubeSDK.h"
#import "ReactiveObjC.h"

@interface DescoverSerialViewController () <RefreshTableViewControllerDelegate>

@end

@implementation DescoverSerialViewController
{
    NSInteger index ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[SerialCollectionViewCell class] forKeyContent:[DescoverSerialContent class]];
    [self registerClass:[SerialCollectionViewCell class] forCellWithReuseIdentifier:[SerialCollectionViewCell getDequeueId:nil]];
//    DescoverSerialContent *c = [[DescoverSerialContent alloc] init];
//    c.serialTitle = @"KEKKKEKKEEEKKEKEKKbkwabdkjwadbkawbdkjawbdkjbawkdjbawkdadnwaldnlwawdaw";
//    [self.contentData addObject:c];
//    for (int i=0; i<10; ++i) {
//        DescoverSerialContent *c = [[DescoverSerialContent alloc] init];
//        c.userName = @"kesion";
//        c.serialTitle = @"adnwaldnlwawdaw";
//        [self.contentData addObject:c];
//    }
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleSerialTitleListWithIndex:index
                                                                                uid:nil
                                                                          fouseType:FouseTypeAll
                                                                       conditionDic:nil
                                                                           callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
                                                                               
                                                                               if ( index==0 && weakSelf.contentData.count>0) {
                                                                                   [weakSelf.contentData removeAllObjects];
                                                                                   [weakSelf.collectionView reloadData];
                                                                               }
                                                                               
                                                                               if ( status==DataCallBackStatusSuccess ) {
                                                                                   NSDictionary *content = page.content.contentData;
                                                                                   NSArray *array = [content objectForKey:@"tabTapList"];
                                                                                   if (array.count == 0) {
                                                                                       return ;
                                                                                   }
                                                                                   for (NSDictionary *dic in array) {
                                                                                       NSString *time = [dic objectForKey:@"create_time"];
                                                                                       NSString *create_uid = [dic objectForKey:@"create_userid"];
                                                                                       NSString *description = [dic objectForKey:@"description"];
                                                                                       NSString *pic = [dic objectForKey:@"pic"];
                                                                                       NSString *title = [dic objectForKey:@"title"];
                                                                                       NSInteger id = [[dic objectForKey:@"id"] integerValue];
                                                                                       CKContent *ckContent = nil;
                                                                                       ckContent = [[DescoverSerialContent alloc] init];
                                                                                       ckContent.serialTitle = title;
                                                                                       ckContent.serialImageUrl = pic;
                                                                                       ckContent.serialDescription = description;
                                                                                       ckContent.userUid = create_uid;
                                                                                       ckContent.time = time;
                                                                                       ckContent.id = id;
                                                                                       [weakSelf.contentData addObject:ckContent];
                                                                                       [self requestUserinfo:create_uid content:ckContent];
                                                                                   }
                                                                                   index ++;
                                                                                   [weakSelf.collectionView reloadData];
                                                                               }
                                                                           }];
}

- (void)requestUserinfo:(NSString *)uid content:(CKContent *)content
{
    @weakify(self);
    [[TubeSDK sharedInstance].tubeUserSDK fetchedUserInfoWithUid:uid isSelf:NO callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        @strongify(self);
        if ( status==DataCallBackStatusSuccess ) {
            NSDictionary *contentDic = page.content.contentData;
            NSDictionary *userinfo = [contentDic objectForKey:@"userinfo"];
            (content).avatarUrl = [userinfo objectForKey:@"avatar"];
            (content).userName = (content).userUid;
            if (![userinfo objectForKey:@"nick"]) {
                (content).userName = [userinfo objectForKey:@"nick"];
            }
            (content).motto = [userinfo objectForKey:@"description"];
            //[self.refreshTableView reload]
//            for (int i=0 ; i < self.contentData.count; ++i) {
//                if ([self.contentData objectAtIndex:i] == content) {
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [UIView performWithoutAnimation:^{
//                        [self.collectionView reloadItemsAtIndexPaths:indexPath];
//                    }];
//                }
//            }
        }
    }];
}

#pragma mark - delegate
- (void)refreshData
{
    index = 0;
    [self requestData];
    NSLog(@"refreshData");
}

- (void)loadMoreData
{
    [self requestData];
    NSLog(@"loadMoreData");
}

@end
