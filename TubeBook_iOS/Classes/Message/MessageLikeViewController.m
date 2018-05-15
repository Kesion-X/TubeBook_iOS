//
//  MessageLikeViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "MessageLikeViewController.h"
#import "UserLikeItemContent.h"
#import "UserLikeItemTableViewCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeNavigationUITool.h"
#import "DetailViewController.h"
#import "ShowArticleUIViewController.h"

@interface MessageLikeViewController () <RefreshTableViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation MessageLikeViewController
{
    NSInteger index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCell:[UserLikeItemTableViewCell class] forKeyContent:[UserLikeItemContent class]];
    [self registerActionKey:kUserLikeItemTableViewCellAvatarImageViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *c = self.contentData[indexPath.row];
        [self.navigationController pushViewController:[[DetailViewController alloc] initUserDetailViewControllerWithUid:c.userUid] animated:YES];
        
    }];
    [self requestReceiveUserLikeList];
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
    self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
    
    [self.navigationController.navigationBar addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationController.navigationBar);
        make.centerY.equalTo(self.navigationController.navigationBar);
    }];
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
- (void)requestReceiveUserLikeList
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedReceiveUserLikeArticleListWithIndex:index uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            if ( index == 0 && self.contentData.count>0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
            
            NSDictionary *contentDicary = page.content.contentData;
            NSArray *list = [contentDicary objectForKey:@"list"];
            
            if (list) {
                for (NSDictionary *dic in list) {
                    NSInteger id = [[dic objectForKey:@"id"] integerValue];
                    NSString *atid = [dic objectForKey:@"atid"];
                    NSString *userid = [dic objectForKey:@"userid"];
                    NSString *time = [dic objectForKey:@"time"];
                    BOOL isReview = [[dic objectForKey:@"ishaved_review"] boolValue];
                    NSString *articleTitle = [dic objectForKey:@"title"];
                    
                    UserLikeItemContent *content = [[UserLikeItemContent alloc] init];
                    content.id = id;
                    content.time = time;
                    content.atid = atid;
                    content.userUid = userid;
                    content.isReview = isReview;
                    content.articleTitle = articleTitle;
                    [self.contentData addObject:content];
                    [self requestUserinfo:content.userUid content:content];
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
    [self requestReceiveUserLikeList];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    [self requestReceiveUserLikeList];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:c.userUid] animated:YES];
}

#pragma mark - get
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        _titleLable.text = @"收到的喜欢";
    }
    return _titleLable;
}

@end
