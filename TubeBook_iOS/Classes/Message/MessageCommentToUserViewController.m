//
//  MessageCommentToUserViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "MessageCommentToUserViewController.h"
#import "CKContent.h"
#import "UserCommentContent.h"
#import "UserReveiveCommentTableViewCell.h"
#import "UserCommentTableViewCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeWebViewViewController.h"
#import "ShowArticleUIViewController.h"
#import "TubeAlterCenter.h"
#import "TubeRootViewController.h"
#import "DetailViewController.h"
#import "TubeNavigationUITool.h"
#import "ShowArticleUIViewController.h"
#import "TubeNavigationUITool.h"
#import "UITubeButton.h"


@interface UserCommentTableViewCellContent : UserCommentContent

@end;

@implementation UserCommentTableViewCellContent

@end;

@interface MessageCommentToUserViewController () <RefreshTableViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITextView *commentField;
@property (nonatomic, strong) UIView *spaceFieldView;
@property (nonatomic, strong) UITubeButton *commentButton;
@property (nonatomic, strong) NSString *toUid;
@property (nonatomic, assign) BOOL checkKeyBoardStatus;
@property (nonatomic, strong) UILabel *placeholderLable;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, strong) NSString *selfUid;
@property (nonatomic, strong) NSString *atid;
@property (nonatomic, assign) NSInteger commentId;

@end

@implementation MessageCommentToUserViewController
{
    NSInteger index;
}

- (void)dealloc
{
    self.dismissCompletionBlock = nil;
}

- (instancetype)initMessageCommentToUserViewControllerWithContent:(UserCommentContent *)content
{
    self = [self init];
    if (self) {
        self.content = content;
        self.toUid =  self.content.userUid;
        self.cid = self.content.cid;
        self.atid = self.content.atid;
        self.commentId = self.content.commentId;
        self.selfUid = [[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableViewControllerDelegate = self;
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerCell:[UserReveiveCommentTableViewCell class] forKeyContent:[UserCommentContent class]];
    [self registerCell:[UserCommentTableViewCell class] forKeyContent:[UserCommentTableViewCellContent class]];
    
    [self.refreshTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-56);
    }];
    [self.view addSubview:self.spaceFieldView];
    [self.spaceFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(56);
    }];
    [self.spaceFieldView addSubview:self.commentField];
    [self.spaceFieldView addSubview:self.commentButton];
    UIView *spaceLine = [[UIView alloc] init];
    spaceLine.backgroundColor = kTAB_TEXT_COLOR;
    [self.spaceFieldView addSubview:spaceLine];
    [spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spaceFieldView);
        make.left.right.equalTo(self.spaceFieldView);
        make.height.mas_equalTo(0.5f);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.spaceFieldView).offset(-8);
        make.centerY.equalTo(self.spaceFieldView);
        make.width.mas_equalTo(80);
        make.top.equalTo(self.spaceFieldView).offset(8);
        make.bottom.equalTo(self.spaceFieldView).offset(-8);
    }];
    [self.commentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spaceFieldView).offset(8);
        make.top.equalTo(self.spaceFieldView).offset(8);
        make.bottom.equalTo(self.spaceFieldView).offset(-8);
        make.right.equalTo(self.commentButton.mas_left).offset(-8);
    }];
    [self.commentField addSubview:self.placeholderLable];
    [self.placeholderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.commentField).offset(8);
    }];
    self.commentField.delegate = self;
    
    [self notificationKeyBoard];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelfViewAction:)];
    [self.view addGestureRecognizer:tapGesturRecognizer];
    
    if ([self.content isKindOfClass:[UserCommentContent class]] && ((UserCommentContent *)self.content).commentFromType == CommentFromTypeArticle){
        
        [self requestCommentFromUidToUidList];
    } else if ([self.content isKindOfClass:[UserCommentContent class]] && ((UserCommentContent *)self.content).commentFromType == CommentFromTypeArticleUser) {
        [self requestArticleCommentByCid];
    }
    
    [self registerActionKey:kAvatarImageViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *c = self.contentData[indexPath.row];
        [self.navigationController pushViewController:[[DetailViewController alloc] initUserDetailViewControllerWithUid:c.userUid] animated:YES];
    }];
    [self registerActionKey:kUserReveiveCommentTableViewCellAvatarImageViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *c = self.contentData[indexPath.row];
        [self.navigationController pushViewController:[[DetailViewController alloc] initUserDetailViewControllerWithUid:c.userUid] animated:YES];
    }];
    
    [self registerActionKey:kUserReveiveCommentTableViewCellArtilceTitleLableViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *c = self.contentData[indexPath.row];
        [self.navigationController pushViewController:[[ShowArticleUIViewController alloc] initShowArticleUIViewControllerWithAtid:c.atid uid:c.userUid] animated:YES];
    }];
    
    [self requestSetCommentReviewStatus];
}

#pragma mark - configNavigation
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

#pragma mark - private
- (void)notificationKeyBoard
{
    //监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - request
- (void)requestSetCommentReviewStatus
{
    [[TubeSDK sharedInstance].tubeArticleSDK setCommentReviewStatusWithId:self.content.id commentType:self.content.commentFromType callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSLog(@"%s 设置为已查看",__func__);
            [self.refreshTableView reloadData];
        }
    }];
}

- (void)requestArticleCommentByCid
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleCommentByCid:self.cid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            [self.contentData removeAllObjects];
            [self.refreshTableView reloadData];
            NSDictionary *contentDic = page.content.contentData;
            NSDictionary *dic = [contentDic objectForKey:@"commentContent"];
            if (dic) {
                NSString *atid = [dic objectForKey:@"atid"];
                NSString *sendUid = [dic objectForKey:@"send_userid"];
                NSString *receiveUid = [dic objectForKey:@"receive_userid"];
                NSInteger t_time = [[dic objectForKey:@"comment_time"] integerValue];
                NSString *time = [TimeUtil getDateWithTime:t_time];
                BOOL isReview = [[dic objectForKey:@"ishaved_review"] boolValue];
                NSString *articleTitle = [dic objectForKey:@"title"];
                NSString *comment = [dic objectForKey:@"comment"];
                UserCommentContent *content = [[UserCommentContent alloc] init];
                content.atid = atid;
                content.userUid = sendUid;
                content.toUid = receiveUid;
                content.time = time;
                content.isReview = isReview;
                content.articleTitle = articleTitle;
                content.comment = comment;
                [self.contentData addObject:content];
                [self requestUserinfo:content.userUid content:content];
                [self requestCommentFromUidToUidList];
            }
        }
    }];
}

- (void)requestCommentFromUidToUidList
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedUserCommentToUserListWithCid:self.cid fromeUid:self.selfUid toUid:self.toUid tid:self.content.id commentId:self.content.commentId commentType:CommentFromTypeArticle allBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            
            if (self.content.commentFromType == CommentFromTypeArticle) {
                [self.contentData removeAllObjects];
                [self.contentData addObject:self.content];
                [self.refreshTableView reloadData];
            }
            
            NSDictionary *contentDic = page.content.contentData;
            NSArray *list = [contentDic objectForKey:@"list"];
            for (NSDictionary *item in list) {
                NSString *sendUserid = [item objectForKey:@"send_userid"];
                NSString *receiveUserid = [item objectForKey:@"receive_userid"];
                NSString *atid = [item objectForKey:@"atid"];
                NSInteger time = [[item objectForKey:@"comment_time"] integerValue];
                NSString *comment = [item objectForKey:@"comment"];
                UserCommentTableViewCellContent *content = [[UserCommentTableViewCellContent alloc] init];
                content.userUid = sendUserid;
                content.toUid = receiveUserid;
                content.time = [TimeUtil getDateWithTime:time];
                content.comment = comment;
                [self.contentData addObject:content];
                [self requestUserinfo:sendUserid content:content];
            }
            
            if (list.count>0) {
                [self.refreshTableView reloadData];
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

#pragma mark - action

- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        NSLog(@"%s pop view controller",__func__);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"%s dismiss view controller",__func__);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.dismissCompletionBlock) {
        self.dismissCompletionBlock();
    }
}

- (void)tapSelfViewAction:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.commentField resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.commentField.text.length==0) {
        if (self.toUid) {
            self.placeholderLable.text = [@"@" stringByAppendingString:[self.toUid stringByAppendingString:@" :"]];
            self.placeholderLable.hidden = NO;
        }
    }
    self.checkKeyBoardStatus = YES;
    // 获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    [self.view setNeedsUpdateConstraints]; // 通知系统视图中的约束需要更新
    [self.view updateConstraintsIfNeeded]; //
    [self.refreshTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(-height);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-56);
    }];
    [self.spaceFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-height);
        make.height.mas_equalTo(56);
    }];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

// 当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.commentField.text = @"";
    if (self.commentField.text.length==0) {
        self.placeholderLable.hidden = YES;
    }
    self.checkKeyBoardStatus = NO;
    [self.view setNeedsUpdateConstraints]; // 通知系统视图中的约束需要更新
    [self.view updateConstraintsIfNeeded]; //
    [self.spaceFieldView setNeedsUpdateConstraints]; // 通知系统视图中的约束需要更新
    [self.spaceFieldView updateConstraintsIfNeeded]; //
    [self.refreshTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-56);
    }];
    [self.spaceFieldView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(56);
    }];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
        [self.spaceFieldView layoutIfNeeded];
    }];
}

- (IBAction)commentClick:(id)sender
{
    if (self.commentField.text.length==0) {
        [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"评论不能为空！" duration:1.0f fromeVC:self];
    } else {
        [self commentToUser];
    }
    
}

- (void)commentToUser
{
    if ([self.content isKindOfClass:[UserCommentContent class]] && ((UserCommentContent *)self.content).commentFromType == CommentFromTypeArticle){
        
        [[TubeSDK sharedInstance].tubeArticleSDK commmentUserWithAtid:self.atid cid:self.cid fromeUid:self.selfUid toUid:self.toUid message:[NSString stringWithFormat:@"@%@ : %@", self.toUid, self.commentField.text] commentId:-1 callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
            if (status == DataCallBackStatusSuccess) {
                self.commentField.text = @"";
                [self requestCommentFromUidToUidList];
                [self.commentField resignFirstResponder];
                [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f fromeVC:self];
            }
        }];
    } else if ([self.content isKindOfClass:[UserCommentContent class]] && ((UserCommentContent *)self.content).commentFromType == CommentFromTypeArticleUser) {
        [[TubeSDK sharedInstance].tubeArticleSDK commmentUserWithAtid:self.atid cid:self.content.cid fromeUid:self.selfUid toUid:self.toUid message:[NSString stringWithFormat:@"@%@ : %@", self.toUid, self.commentField.text] commentId:self.content.id callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
            if (status == DataCallBackStatusSuccess) {
                self.commentField.text = @"";
                [self requestArticleCommentByCid];
                [self.commentField resignFirstResponder];
                [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f fromeVC:self];
            }
        }];
    }

}

#pragma mark - delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        self.placeholderLable.hidden = YES;
    } else {
        self.placeholderLable.hidden = NO;
    }
}


#pragma mark - get
- (UILabel *)placeholderLable
{
    if (!_placeholderLable) {
        _placeholderLable = [[UILabel alloc] init];
        _placeholderLable.font = Font(14);
        _placeholderLable.textColor = HEXCOLOR(0xecdcdcd);
        _placeholderLable.hidden = YES;
    }
    return _placeholderLable;
}

- (UITextView *)commentField
{
    if (!_commentField) {
        _commentField = [[UITextView alloc] init];
        _commentField.layer.cornerRadius = 5;
        _commentField.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _commentField.layer.borderWidth = 0.5f;
        _commentField.layer.masksToBounds = YES;
        _commentField.font = Font(14);
    }
    return _commentField;
}

- (UIView *)spaceFieldView
{
    if (!_spaceFieldView) {
        _spaceFieldView = [[UIView alloc] init];
    }
    return _spaceFieldView;
}

- (UITubeButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = [[UITubeButton alloc] initUITubeButton:@"评论" normalColor:kTUBEBOOK_THEME_NORMAL_COLOR lightColor:kTUBEBOOK_THEME_ALPHA_COLOR];
        [_commentButton addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        _titleLable.text = @"评论回复";
    }
    return _titleLable;
}

@end
