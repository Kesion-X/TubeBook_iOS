//
//  AuthorViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AuthorViewController.h"
#import "UserContent.h"
#import "TubeSDK.h"
#import "UIUserTableCell.h"
#import "DetailViewController.h"
#import "TubeRootViewController.h"
#import "TubeNavigationUITool.h"
#import "Masonry.h"


@interface AuthorViewController () <RefreshTableViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation AuthorViewController
{
    NSInteger index;
}

- (instancetype)initAuthorViewControllerWithAutorType:(AuthorType)autorType
{
    self = [super init];
    if (self) {
        self.autorType = autorType;
        NSLog(@" init author type:%lu",autorType);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UIUserTableCell class] forKeyContent:[UserContent class]];
    [self requestLoadData];
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

#pragma mark request
- (void)requestLoadData
{
    if (self.autorType == AuthorTypeAttent) {
        [self requestAutorAttentData];
    } else {
        [self requestAutorFansData];
    }
}

- (void)requestAutorFansData
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedFansListWithIndex:index uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if ( status == DataCallBackStatusSuccess ) {
            NSDictionary *contentDic = page.content.contentData;
            if ( index == 0 && self.contentData.count > 0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
            NSArray *list = [contentDic objectForKey:@"userinfoList"];
            for (NSDictionary * userinfo in list) {
                NSString *userid = [userinfo objectForKey:@"attention_userid"];
                NSString *avatar = [userinfo objectForKey:@"avatar"];
                NSString *description = [userinfo objectForKey:@"description"];
                NSString *nick = [userinfo objectForKey:@"nick"];
                UserContent *userContent = [[UserContent alloc] init];
                userContent.userUid = userid;
                userContent.userName = userid;
                if (nick && nick.length>0) {
                    userContent.userName = nick;
                }
                if (description.length == 0) {
                    description = @"暂无简介";
                }
                userContent.avatarUrl = avatar;
                userContent.motto = description;
                [self.contentData addObject:userContent];
            }
            if (list.count>0) {
                [self.refreshTableView reloadData];
                index ++;
            }
        }
    }];
}

- (void)requestAutorAttentData
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedAttentedUserListWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] index:index callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if ( status == DataCallBackStatusSuccess ) {
            NSDictionary *contentDic = page.content.contentData;
            if ( index == 0 && self.contentData.count > 0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
            NSArray *list = [contentDic objectForKey:@"userinfoList"];
            for (NSDictionary * userinfo in list) {
                NSString *userid = [userinfo objectForKey:@"attentioned_userid"];
                NSString *avatar = [userinfo objectForKey:@"avatar"];
                NSString *description = [userinfo objectForKey:@"description"];
                NSString *nick = [userinfo objectForKey:@"nick"];
                UserContent *userContent = [[UserContent alloc] init];
                userContent.userUid = userid;
                userContent.userName = userid;
                if (nick && nick.length>0) {
                    userContent.userName = nick;
                }
                if (description.length == 0) {
                    description = @"暂无简介";
                }
                userContent.avatarUrl = avatar;
                userContent.motto = description;
                [self.contentData addObject:userContent];
            }
            if (list.count>0) {
                [self.refreshTableView reloadData];
                index ++;
            }
        }
    }];
}

#pragma mark - delegate
- (void)refreshData
{
    index = 0;
    [self requestLoadData];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    [self requestLoadData];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s select item %@",__func__, c);
        TubeRootViewController *vc = [[TubeRootViewController alloc] initWithRootViewController:[[DetailViewController alloc] initUserDetailViewControllerWithUid:c.userUid]];
        [self presentViewController:vc animated:YES completion:nil];
    });
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
