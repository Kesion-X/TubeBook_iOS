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
#import "DescoverRecommendContent.h"
#import "UIDescoverRecommendCell.h"
#import "TubeSDK.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeWebViewViewController.h"
#import "ShowArticleUIViewController.h"

@interface DescoverRecommendViewController () <RefreshTableViewControllerDelegate>

@property (nonatomic, strong) CycleContent *topCycContent;

@end

@implementation DescoverRecommendViewController
{
    NSInteger index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[CycleTableCell class] forKeyContent:[CycleContent class]];
    [self registerCell:[UIDescoverRecommendCell class] forKeyContent:[DescoverRecommendContent class]];
    self.topCycContent = [[CycleContent alloc] init];
    [self.contentData addObject:self.topCycContent];
    [self requestTop5];
    [self requestData];
    [self registertapBlockKey:kCycleTableCellCycleImageTap forKeyBlock:^(NSIndexPath *indexPath, NSDictionary *dic) {
        NSInteger index = [[dic objectForKey:@"index"] integerValue];
        NSString *atid = [self.topCycContent.atidList objectAtIndex:index];
        NSString *uid = [self.topCycContent.userIdList objectAtIndex:index];
        [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:atid uid:uid] animated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
}

#pragma mark - request

- (void)requestTop5
{
    NSLog(@"%s requestTop5",__func__);
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedRecommendByHotArticleListtWithIndex:0 uid:nil articleType:ArticleTypeTopic|ArticleTypeMornal|ArticleTypeSerial fouseType:FouseTypeAll callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *contentDicary = page.content.contentData;
            NSArray *list = [contentDicary objectForKey:@"list"];
            NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
            NSMutableArray *titles = [[NSMutableArray alloc] init];
            NSMutableArray *atids = [[NSMutableArray alloc] init];
            NSMutableArray *useridList = [[NSMutableArray alloc] init];
            for ( NSDictionary *contentDic in list ) {
                ArticleType articleType = [[contentDic objectForKey:@"tabtype"] integerValue];
                NSString *articlepic = [contentDic objectForKey:@"articlepic"];
                NSString *atid = [contentDic objectForKey:@"atid"];
                NSString *userid = [contentDic objectForKey:@"userid"];
                NSString *title = [contentDic objectForKey:@"title"];
                NSInteger tabid = [[contentDic objectForKey:@"tabid"] integerValue];
                if (articlepic && articlepic.length > 0) {
                    [imageUrls addObject:articlepic];
                    [titles addObject:title];
                    [atids addObject:atid];
                    [useridList addObject:userid];
                }
            }
            self.topCycContent.titles = titles;
            self.topCycContent.imageUrls = imageUrls;
            self.topCycContent.atidList = atids;
            self.topCycContent.userIdList = useridList;
            [self.refreshTableView reloadData];
        }
    }];
}


- (void)requestData
{
    @weakify(self);
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedRecommendByUserCFArticleListtWithIndex:index uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] articleType:ArticleTypeMornal|ArticleTypeTopic|ArticleTypeSerial callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        @strongify(self);
        if ( status==DataCallBackStatusSuccess ) {
            if ( index == 0 && self.contentData.count>1 ) {
                NSRange rang = NSMakeRange(1, self.contentData.count - 1);
                [self.contentData removeObjectsInRange:(rang)];
                [self.refreshTableView reloadData];
                [self requestTop5];
            }
            NSDictionary *contentDicary = page.content.contentData;
            NSArray *list = [contentDicary objectForKey:@"list"];
            for ( NSDictionary *contentDic in list ) {
                NSString *atid = [contentDic objectForKey:@"atid"];
                
                BOOL ishave = NO;
                for (CKContent *c in self.contentData) {
                    if ([c.atid isEqualToString:atid]) {
                        ishave = YES;
                        break;
                    }
                }
                if (ishave) {
                    continue;
                }
                ArticleType articleType = [[contentDic objectForKey:@"tabtype"] integerValue];
                NSString *articlepic = [contentDic objectForKey:@"articlepic"];
                NSInteger time = [[contentDic objectForKey:@"createtime"] integerValue];
                NSString *description = [contentDic objectForKey:@"description"];
                NSString *userid = [contentDic objectForKey:@"userid"];
                NSString *title = [contentDic objectForKey:@"title"];
                NSInteger tabtype = [[contentDic objectForKey:@"tabtype"] integerValue];
                NSInteger tabid = [[contentDic objectForKey:@"tabid"] integerValue];
                switch (articleType) {
                    case ArticleTypeMornal:
                    {
                        DescoverRecommendContent *content = [[DescoverRecommendContent alloc] init];
                        content.articlePic = articlepic;
                        content.atid = atid;
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
                        content.dataType.articleKind = NormalArticle;
                        [self requestUserinfo:userid content:content];
                        [self.contentData addObject:content];
                        break;
                    }
                    case ArticleTypeTopic:
                    {
                        DescoverRecommendContent *content = [[DescoverRecommendContent alloc] init];
                        content.articlePic = articlepic;
                        content.atid = atid;
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
                        [self.contentData addObject:content];
                        break;
                    }
                    case ArticleTypeSerial:
                    {
                        DescoverRecommendContent *content = [[DescoverRecommendContent alloc] init];
                        content.articlePic = articlepic;
                        content.atid = atid;
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
            NSString *nick = [userinfo objectForKey:@"nick"];
            if ( nick && nick.length>0 ) {
                content.userName = [userinfo objectForKey:@"nick"];
            }
            (content).motto = [userinfo objectForKey:@"description"];
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
    NSString *userid = c.userUid;
    NSLog(@"%s select item %@",__func__, c);
    [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:userid] animated:YES];
}


@end
