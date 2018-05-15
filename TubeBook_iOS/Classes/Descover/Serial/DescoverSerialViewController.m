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
#import "DetailViewController.h"
#import "TubeRootViewController.h"

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
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
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
            NSString *name = [userinfo objectForKey:@"nick"];
            if ( name && name.length>0) {
                (content).userName = [userinfo objectForKey:@"nick"];
            }
            (content).motto = [userinfo objectForKey:@"description"];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *content = self.contentData[indexPath.row];
    NSLog(@"%s didSelectItem %@",__func__, content);
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        TubeRootViewController *vc = [[TubeRootViewController alloc] initWithRootViewController:[[DetailViewController alloc] initSerialDetailViewControllerWithTabid:content.id uid:content.userUid]];
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    });
}

- (void)refreshData
{
    index = 0;
    [self requestData];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    [self requestData];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

@end
