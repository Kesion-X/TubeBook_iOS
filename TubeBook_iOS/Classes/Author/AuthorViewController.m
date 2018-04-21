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


@interface AuthorViewController () <RefreshTableViewControllerDelegate>

@end

@implementation AuthorViewController
{
    NSInteger index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UIUserTableCell class] forKeyContent:[UserContent class]];
//    for (int i=0; i<10; ++i) {
//        [self.contentData addObject:[[UserContent alloc] init]];
//    }
    [self requestData];
}

- (void)requestData
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
                userContent.userName = userid;
                if (nick) {
                    userContent.userName = nick;
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
