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
#import "Masonry.h"
#import "TubeWebViewViewController.h"
#import "ShowArticleUIViewController.h"
#import "DetailSerialArticleTableViewCell.h"
#import "DetailSerialArticleContent.h"
#import "TubeNavigationUITool.h"

@interface DetialArticleListViewController () <RefreshTableViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLable;

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

- (instancetype)initDetialArticleListViewControllerWithDetailType:(TubeDetailType)type uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self.type = type;
        self.uid = uid;
    }
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    NSLog(@"%s uid:%@ type:%lu",__func__,self.uid ,self.type);
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
        case TubeDetailTypeUser:{
            [self registerCell:[DetailTopicArticleTableViewCell class] forKeyContent:[DetailSerialArticleContent class]];
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
        case TubeDetailTypeUser:{
            @weakify(self);
            [[TubeSDK sharedInstance].tubeUserSDK fetchedSelfArticleListWithIndex:index uid:self.uid articleType:UserArticleTypeSerial|UserArticleTypeTopic|UserArticleTypeMornal  callback:^(DataCallBackStatus status, BaseSocketPackage *page) {
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
            [self.refreshTableView reloadData];
        }
    }];
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    NSLog(@"%s select item %@",__func__, c);
    [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:c.userUid] animated:YES];
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
