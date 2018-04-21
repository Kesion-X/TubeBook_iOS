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
    [self.contentData addObject:[[CycleContent alloc] init]];

    [self requestData];
}

- (void)viewDidAppear:(BOOL)animated
{

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
            }
            NSDictionary *contentDicary = page.content.contentData;
            NSArray *list = [contentDicary objectForKey:@"list"];
            for ( NSDictionary *contentDic in list ) {
                
                ArticleType articleType = [[contentDic objectForKey:@"tabtype"] integerValue];
                NSString *articlepic = [contentDic objectForKey:@"articlepic"];
                NSString *atid = [contentDic objectForKey:@"atid"];
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
- (void)refreshData
{
    index = 0 ;
    [self requestData];
    NSLog(@"refreshData");
}

- (void)loadMoreData
{
    
    [self requestData];
    NSLog(@"loadMoreData");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    //UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:@"" uid:@"" body:c.body]];
    // TubeWebViewViewController *vc = [[TubeWebViewViewController alloc] initTubeWebViewViewControllerWithHtml:c.body];
    // [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]] animated:YES];
}


@end
