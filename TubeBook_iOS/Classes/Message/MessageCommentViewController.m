//
//  MessageCommentViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "MessageCommentViewController.h"
#import "UserCommentContent.h"
#import "UserReveiveCommentTableViewCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeWebViewViewController.h"
#import "ShowArticleUIViewController.h"
#import "TubeAlterCenter.h"
#import "TubeRootViewController.h"
#import "DetailViewController.h"
#import "TubeNavigationUITool.h"
#import "ShowArticleUIViewController.h"
#import "MessageCommentToUserViewController.h"

@interface MessageCommentViewController () <RefreshTableViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation MessageCommentViewController
{
    NSInteger index ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCell:[UserReveiveCommentTableViewCell class] forKeyContent:[UserCommentContent class]];
    
    [self registerActionKey:kUserReveiveCommentTableViewCellAvatarImageViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *c = self.contentData[indexPath.row];
        [self.navigationController pushViewController:[[DetailViewController alloc] initUserDetailViewControllerWithUid:c.userUid] animated:YES];
    }];
    [self registerActionKey:kUserReveiveCommentTableViewCellArtilceTitleLableViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *c = self.contentData[indexPath.row];
        [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:c.userUid] animated:YES];
    }];
    
    
    [self requestCommentList];
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
- (void)requestCommentList
{
    @weakify(self);
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedReceiveCommentListWithIndex:index uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        @strongify(self);
        if (status == DataCallBackStatusSuccess) {
            if ( index == 0 && self.contentData.count>0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
        }
        NSDictionary *contentDicary = page.content.contentData;
        NSArray *list = [contentDicary objectForKey:@"list"];
        if (list) {
            for (NSDictionary *dic in list) {
                NSInteger id = [[dic objectForKey:@"id"] integerValue];
                NSInteger cid = [[dic objectForKey:@"cid"] integerValue];
                NSInteger commentId = [[dic objectForKey:@"comment_id"] integerValue];
                NSString *atid = [dic objectForKey:@"atid"];
                NSString *sendUid = [dic objectForKey:@"send_userid"];
                NSString *receiveUid = [dic objectForKey:@"receive_userid"];
                NSString *time = [dic objectForKey:@"comment_time"];
                NSInteger t_time = [[dic objectForKey:@"t_comment_time"] integerValue];
                BOOL isReview = [[dic objectForKey:@"ishaved_review"] boolValue];
                CommentFromType fromType = [[dic objectForKey:@"comment_from_type"] integerValue];
                NSString *articleTitle = [dic objectForKey:@"article_title"];
                NSString *comment = [dic objectForKey:@"comment"];
                
                UserCommentContent *content = [[UserCommentContent alloc] init];
                content.id = id;
                content.atid = atid;
                content.cid = cid;
                content.commentId = commentId;
                content.userUid = sendUid;
                content.toUid = receiveUid;
                content.time = time;
                content.t_time = t_time;
                content.isReview = isReview;
                content.commentFromType = fromType;
                content.articleTitle = articleTitle;
                content.comment = comment;
                [self.contentData addObject:content];
                [self requestUserinfo:content.userUid content:content];
            }
        }
        if (list.count>0) {
            [self.refreshTableView reloadData];
            index ++;
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
    [self requestCommentList];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    [self requestCommentList];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *c = [self.contentData objectAtIndex:indexPath.row];
    MessageCommentToUserViewController *vc = [[MessageCommentToUserViewController alloc] initMessageCommentToUserViewControllerWithContent:(UserCommentContent *)c] ;
    [vc setDismissCompletionBlock:^{
        index = 0;
        NSLog(@"%s MessageCommentToUserViewController set block",__func__);
        [self requestCommentList];
    }];
    NSLog(@"%s select item %@",__func__, c);
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - get
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        _titleLable.text = @"评论消息";
    }
    return _titleLable;
}


@end
