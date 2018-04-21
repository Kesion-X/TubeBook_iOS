//
//  DetialArticleListViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DetialArticleListViewController.h"
#import "DetailTopicArticleContent.h"
#import "DetailTopicArticleTableViewCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeWebViewViewController.h"
#import "ShowArticleUIViewController.h"
#import "DetailSerialArticleTableViewCell.h"
#import "DetailSerialArticleContent.h"

@interface DetialArticleListViewController () <RefreshTableViewControllerDelegate>

@end

@implementation DetialArticleListViewController
{
    NSInteger index;
}

- (instancetype)initDetialArticleListViewControllerWithDetailType:(TubeDetailType)type tabid:(NSInteger)tabid
{
    self = [super init];
    if (self) {
        self.type = type;
        self.tabid = tabid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    switch (self.type) {
        case TubeDetailTypeTopic:
        {
            [self registerCell:[DetailTopicArticleTableViewCell class] forKeyContent:[DetailTopicArticleContent class]];
            break;
        }
        case TubeDetailTypeSerial:
        {
            [self registerCell:[DetailSerialArticleTableViewCell class] forKeyContent:[DetailSerialArticleContent class]];
            break;
        }
        default:
            break;
    }
    [self requestData];
}

- (void)requestData
{
    switch (self.type) {
        case TubeDetailTypeTopic:
        {
            @weakify(self);
            [[TubeSDK sharedInstance].tubeArticleSDK fetchedNewArticleListWithIndex:index uid:nil articleType:ArticleTypeTopic tabid:self.tabid conditionDic:nil callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
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
                        
                        DetailTopicArticleContent *content = [[DetailTopicArticleContent alloc] init];
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
                        //                [self requestTopicInfo:tabid content:content];
                        [self.contentData addObject:content];
                    }
                    if (list.count>0) {
                        [self.refreshTableView reloadData];
                        index ++;
                    }
                }
            }];
            break;
        }
        case TubeDetailTypeSerial:
        {
            @weakify(self);
            [[TubeSDK sharedInstance].tubeArticleSDK fetchedNewArticleListWithIndex:index uid:nil articleType:ArticleTypeSerial tabid:self.tabid conditionDic:nil callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
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
                        
                        DetailSerialArticleContent *content = [[DetailSerialArticleContent alloc] init];
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
                        content.dataType.articleKind = ArticleTypeSerial;
                        //[self requestUserinfo:userid content:content];
                        //                [self requestTopicInfo:tabid content:content];
                        [self.contentData addObject:content];
                    }
                     if (list.count>0) {
                        [self.refreshTableView reloadData];
                        index ++;
                    }
                }
            }];
            break;
        }
        default:
            break;
    }

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
            //[self.refreshTableView reload]
            for (int i=0 ; i < self.contentData.count; ++i) {
                if ([self.contentData objectAtIndex:i] == content) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.refreshTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }];
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:@"" uid:@"" body:c.body]];
    // TubeWebViewViewController *vc = [[TubeWebViewViewController alloc] initTubeWebViewViewControllerWithHtml:c.body];
    // [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]] animated:YES];
}

- (void)refreshData
{
    index = 0;
    [self requestData];
}

- (void)loadMoreData
{
    [self requestData];
}


@end
