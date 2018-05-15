//
//  RecommendViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "RecommendViewController.h"
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
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeWebViewViewController.h"
#import "ShowArticleUIViewController.h"
#import "TubeSDK.h"
#import "TubeRootViewController.h"
#import "DetailViewController.h"

@interface RecommendViewController () <RefreshTableViewControllerDelegate>

@end

@implementation RecommendViewController
{
    NSInteger index ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UINormalArticleCell class] forKeyContent:[NormalArticleContent class]];
    [self registerCell:[UISerialArticleCell class] forKeyContent:[SerialArticleContent class]];
    [self registerCell:[UITopicArticleCell class] forKeyContent:[TopicArticleContent class]];
    [self registerActionKey:kSerialTabViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *content = self.contentData[indexPath.row];
        TubeRootViewController *vc = [[TubeRootViewController alloc] initWithRootViewController:[[DetailViewController alloc] initSerialDetailViewControllerWithTabid:content.tabid uid:content.userUid]];
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }];
    [self registerActionKey:kTopicTabViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *content = self.contentData[indexPath.row];
        TubeRootViewController *vc = [[TubeRootViewController alloc] initWithRootViewController:[[DetailViewController alloc] initTopicDetailViewControllerWithTabid:content.tabid uid:content.userUid]];
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    }];
    [self requestData];
}

- (void)requestData
{
    @weakify(self);
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedRecommendByHotArticleListtWithIndex:index uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] articleType:ArticleTypeMornal|ArticleTypeTopic|ArticleTypeSerial fouseType:FouseTypeAttrent callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        @strongify(self);
        if ( status==DataCallBackStatusSuccess ) {
            if ( index == 0 && self.contentData.count>0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
            NSDictionary *contentDicary = page.content.contentData;
            NSArray *list = [contentDicary objectForKey:@"list"];
            for ( NSDictionary *contentDic in list ) {
                
                ArticleType articleType = [[contentDic objectForKey:@"tabtype"] integerValue];
                NSString *articlepic = [contentDic objectForKey:@"articlepic"];
                NSString *atid = [contentDic objectForKey:@"atid"];
                NSString *body = [contentDic objectForKey:@"body"];
                NSInteger time = [[contentDic objectForKey:@"createtime"] integerValue];
                NSString *description = [contentDic objectForKey:@"description"];
                NSString *userid = [contentDic objectForKey:@"userid"];
                NSString *title = [contentDic objectForKey:@"title"];
                
                NSInteger tabtype = [[contentDic objectForKey:@"tabtype"] integerValue];
                NSInteger tabid = [[contentDic objectForKey:@"tabid"] integerValue];
                switch (articleType) {
                    case ArticleTypeMornal:
                    {
                        NormalArticleContent *content = [[NormalArticleContent alloc] init];
                        content.contentUrl = articlepic;
                        content.atid = atid;
                        content.body = body;
                        content.time = [TimeUtil getDateWithTime:time];
                        content.contentDescription = description;
                        content.userUid = userid;
                        content.title = title;
                        content.tabType = tabtype;
                        content.tabid = tabid;
                        if (articlepic && articlepic.length>1 ) {
                            content.dataType.isHaveImage = YES;
                        }
                        content.dataType.userState = UserPublishArticle;
                        content.dataType.articleKind = NormalArticle;
                        [self requestUserinfo:userid content:content];
                        [self.contentData addObject:content];
                        break;
                    }
                    case ArticleTypeTopic:
                    {
                        TopicArticleContent *content = [[TopicArticleContent alloc] init];
                        content.articlePic = articlepic;
                        content.atid = atid;
                        content.body = body;
                        content.time = [TimeUtil getDateWithTime:time];
                        content.articleDescription = description;
                        content.userUid = userid;
                        content.articleTitle = title;
                        content.tabType = tabtype;
                        content.tabid = tabid;
                        if (articlepic && articlepic.length>1 ) {
                            content.dataType.isHaveImage = YES;
                        }
                        content.dataType.userState = UserPublishArticle;
                        content.dataType.articleKind = TopicArticle;
                        [self requestUserinfo:userid content:content];
                        [self requestTopicInfo:tabid content:content];
                        [self.contentData addObject:content];
                        break;
                    }
                    case ArticleTypeSerial:
                    {
                        SerialArticleContent *content = [[SerialArticleContent alloc] init];
                        content.articlePic = articlepic;
                        content.atid = atid;
                        content.body = body;
                        content.time = [TimeUtil getDateWithTime:time];
                        content.articleDescription = description;
                        content.userUid = userid;
                        content.articleTitle = title;
                        content.tabType = tabtype;
                        content.tabid = tabid;
                        if (articlepic && articlepic.length>1 ) {
                            content.dataType.isHaveImage = YES;
                        }
                        content.dataType.userState = UserPublishArticle;
                        content.dataType.articleKind = SerialArticle;
                        [self requestUserinfo:userid content:content];
                        [self requestSerialInfo:tabid content:content];
                        [self.contentData addObject:content];
                        break;
                    }
                        
                    default:
                        
                        break;
                }
                
            }
            if (list.count>0) {
                [self.refreshTableView reloadData];
                index ++;
            }
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
            if ([userinfo objectForKey:@"nick"]) {
                (content).userName = [userinfo objectForKey:@"nick"];
            }
            (content).motto = [userinfo objectForKey:@"description"];
            [self.refreshTableView reloadData];
        }
    }];
}

- (void)requestSerialInfo:(NSInteger)tabid content:(CKContent *)content
{
    @weakify(self);
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleSerialDetailWithTabid:tabid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        @strongify(self);
        if ( status==DataCallBackStatusSuccess ) {
            NSDictionary *contentDic = page.content.contentData;
            NSDictionary *detailInfo = [contentDic objectForKey:@"detailInfo"];
            NSString *topicTitle = [detailInfo objectForKey:@"title"];
            NSString *pic = [detailInfo objectForKey:@"pic"];
            NSString *description = [detailInfo objectForKey:@"description"];
            content.serialTitle = topicTitle;
            content.serialImageUrl = pic;
            content.serialDescription  = description;
            [self.refreshTableView reloadData];
        }
    }];
}

- (void)requestTopicInfo:(NSInteger)tabid content:(CKContent *)content
{
    @weakify(self);
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleTopicDetailWithTabid:tabid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        @strongify(self);
        if ( status==DataCallBackStatusSuccess ) {
            NSDictionary *contentDic = page.content.contentData;
            NSDictionary *detailInfo = [contentDic objectForKey:@"detailInfo"];
            NSString *topicTitle = [detailInfo objectForKey:@"title"];
            NSString *pic = [detailInfo objectForKey:@"pic"];
            NSString *description = [detailInfo objectForKey:@"description"];
            content.topicTitle = topicTitle;
            content.topicImageUrl = pic;
            content.topicDescription  = description;
            [self.refreshTableView reloadData];
        }
    }];
}


#pragma mark - delegate
- (void)refreshData
{
    index = 0 ;
    [self requestData];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    
    [self requestData];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    NSLog(@"%s select item %@",__func__, c);
    [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:c.userUid] animated:YES];
}

@end
