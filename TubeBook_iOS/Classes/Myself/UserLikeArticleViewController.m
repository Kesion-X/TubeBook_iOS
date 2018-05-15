//
//  UserLikeArticleViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/8.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UserLikeArticleViewController.h"
#import "CycleContent.h"
#import "CycleTableCell.h"
#import "DescoverRecommendContent.h"
#import "UIDescoverRecommendCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeWebViewViewController.h"
#import "ShowArticleUIViewController.h"
#import "TubeNavigationUITool.h"

@interface UserLikeArticleViewController () <RefreshTableViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation UserLikeArticleViewController
{
    NSInteger index;
}

- (instancetype)initUserLikeArticleViewControllerWithUid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self.uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s uid:%@",__func__, self.uid);
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[CycleTableCell class] forKeyContent:[CycleContent class]];
    [self registerCell:[UIDescoverRecommendCell class] forKeyContent:[DescoverRecommendContent class]];
    [self requestLikeArticleList];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s ",__func__);
    [self.titleLable removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    if (self.navigationController.viewControllers.count > 1){
        self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
        
        [self.navigationController.navigationBar addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navigationController.navigationBar);
            make.centerY.equalTo(self.navigationController.navigationBar);
        }];
    }
}

- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        NSLog(@"%s pop view controller",__func__);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"%s dismiss view controller",__func__);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - request
- (void)requestLikeArticleList
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedLikeArticleListWithIndex:index uid:self.uid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
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
    index = 0;
    [self requestLikeArticleList];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    [self requestLikeArticleList];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    NSString *userid = c.userUid;
    NSLog(@"%s select item %@",__func__, c);
    [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:userid] animated:YES];
}


#pragma mark - get
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        _titleLable.text = self.title;
    }
    return _titleLable;
}


@end
