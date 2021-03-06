//
//  CommentUIViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CommentUIViewController.h"
#import "UserCommentContent.h"
#import "UserCommentTableViewCell.h"
#import "Masonry.h"
#import "UITubeButton.h"
#import "NSString+StringKit.h"
#import "TubeAlterCenter.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeNavigationUITool.h"
#import "DetailViewController.h"

@interface CommentUIViewController () <UITextViewDelegate, RefreshTableViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextView *commentField;
@property (nonatomic, strong) UIView *spaceFieldView;
@property (nonatomic, strong) UITubeButton *commentButton;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSString *toUid;
@property (nonatomic, assign) BOOL checkKeyBoardStatus;
@property (nonatomic, strong) UILabel *placeholderLable;
@property (nonatomic, assign) NSInteger currentCid;
@property (nonatomic, assign) BOOL checkUserComment;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, assign) NSInteger commentId;

@end

@implementation CommentUIViewController
{
    NSInteger index;
}

- (instancetype)initCommentUIViewControllerWithAutorUid:(NSString *)uid atid:(NSString *)atid commentType:(CommentType)commentType;
{
    self = [super init];
    if (self) {
        self.autorUid = uid;
        self.atid = atid;
        self.toUid = self.autorUid;
        self.commentType = commentType;
        NSLog(@"%s autorUid:%@, atid:%@ commenType:%lu",__func__, uid, atid, commentType);
    }
    return self;
}

- (instancetype)initCommentUIViewControllerWithAutorUid:(NSString *)uid atid:(NSString *)atid commentType:(CommentType)commentType cid:(NSInteger)cid;
{
    self = [super init];
    if (self) {
        self.autorUid = uid;
        self.atid = atid;
        self.toUid = self.autorUid;
        self.commentType = commentType;
        self.currentCid = cid;
        NSLog(@"%s autorUid:%@, atid:%@ commenType:%lu cid:%lu",__func__, uid, atid, commentType, cid);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.autorUid) {
        return ;
    }
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
    tapGesturRecognizer.delegate = self;
    
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UserCommentTableViewCell class] forKeyContent:[UserCommentContent class]];
    
    if (self.commentType == CommentTypeArticle) {
        [self registerActionKey:kCountLableTap forKeyBlock:^(NSIndexPath *indexPath) {
            CKContent *c = self.contentData[indexPath.row];
            CommentUIViewController *vc = [[CommentUIViewController alloc] initCommentUIViewControllerWithAutorUid:c.userUid atid:self.atid commentType:CommentTypeUser cid:c.id];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    [self registerActionKey:kAvatarImageViewTap forKeyBlock:^(NSIndexPath *indexPath) {
        CKContent *c = self.contentData[indexPath.row];
        [self.navigationController pushViewController:[[DetailViewController alloc] initUserDetailViewControllerWithUid:c.userUid] animated:YES];
        
    }];
    [self requstCommentList];
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
    if (self.commentType == CommentTypeUser) {
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
- (void)requstCommentList
{
    if (self.commentType == CommentTypeArticle) {
        [self requestArticleCommentList];
    } else {
        [self requestUserCommentList];
    }
}

- (void)requestArticleCommentList
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleCommentListWithAtid:self.atid index:index allBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            if ( index == 0 && self.contentData.count>0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
            NSDictionary *contentDic = page.content.contentData;
            NSArray *list = [contentDic objectForKey:@"list"];
            for (NSDictionary *item in list) {
                NSInteger cid = [[item objectForKey:@"id"] integerValue];
                NSString *sendUserid = [item objectForKey:@"send_userid"];
                NSString *receiveUserid = [item objectForKey:@"receive_userid"];
                NSString *atid = [item objectForKey:@"atid"];
                NSInteger time = [[item objectForKey:@"comment_time"] integerValue];
                NSString *comment = [item objectForKey:@"comment"];
                NSInteger commentCount = [[item objectForKey:@"count(cid)"] integerValue];
                UserCommentContent *content = [[UserCommentContent alloc] init];
                content.commentCount = commentCount;
                content.id = cid;
                content.cid = content.id;
                content.userUid = sendUserid;
                content.toUid = receiveUserid;
                content.time = [TimeUtil getDateWithTime:time];
                content.comment = comment;
                [self.contentData addObject:content];
                [self requestUserinfo:sendUserid content:content];
            }
            
            if (list.count>0) {
                [self.refreshTableView reloadData];
                index ++;
            }
        }
    }];
}

- (void)requestUserCommentList
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedUserCommentToUserListWithCid:self.currentCid index:index allBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            if ( index == 0 && self.contentData.count>0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
            NSDictionary *contentDic = page.content.contentData;
            NSArray *list = [contentDic objectForKey:@"list"];
            for (NSDictionary *item in list) {
                NSInteger id = [[item objectForKey:@"id"] integerValue];
                NSInteger cid = [[item objectForKey:@"cid"] integerValue];
                NSInteger commentId = [[item objectForKey:@"comment_id"] integerValue];
                NSString *sendUserid = [item objectForKey:@"send_userid"];
                NSString *receiveUserid = [item objectForKey:@"receive_userid"];
                NSString *atid = [item objectForKey:@"atid"];
                NSInteger time = [[item objectForKey:@"comment_time"] integerValue];
                NSString *comment = [item objectForKey:@"comment"];
                UserCommentContent *content = [[UserCommentContent alloc] init];
                content.id = id;
                content.cid = cid;
                content.userUid = sendUserid;
                content.toUid = receiveUserid;
                content.time = [TimeUtil getDateWithTime:time];
                content.comment = comment;
                content.commentId = commentId;
                [self.contentData addObject:content];
                [self requestUserinfo:sendUserid content:content];
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
            [self.refreshTableView reloadData];
//            for (int i=0 ; i < self.contentData.count; ++i) {
//                if ([self.contentData objectAtIndex:i] == content) {
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [self.refreshTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }
        }
    }];
}

#pragma mark - action
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
    self.checkUserComment = NO;
    self.commentField.text = @"";
    if (self.commentField.text.length==0) {
        self.toUid = self.autorUid;
        self.placeholderLable.hidden = YES;
    }
    self.checkKeyBoardStatus = NO;
    // 获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    //self.board.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, height + 40);
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
   // self.spaceFieldView.frame = CGRectMake(0, SCREEN_HEIGHT - 56, SCREEN_WIDTH, 56);
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
        
        if (self.toUid == self.autorUid && self.commentType == CommentTypeArticle && !self.checkUserComment) {
            [self commentToArticle];
        } else if (self.toUid == self.autorUid && self.commentType == CommentTypeArticle && self.checkUserComment) {
            [self commentToUser:-1];
        }else if (self.toUid != self.autorUid && self.commentType == CommentTypeArticle){
            [self commentToUser:-1];
        } else if (self.commentType == CommentTypeUser) {
            [self commentToUser:self.commentId];
        }
    }
    
}

- (void)commentToArticle
{
    [[TubeSDK sharedInstance].tubeArticleSDK commentArticleWithAtid:self.atid fromUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] toUid:self.toUid message:self.commentField.text callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            self.commentField.text = @"";
            index = 0;
            [self requstCommentList];
            [self.commentField resignFirstResponder];
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f fromeVC:self];
        }
    }];
}

- (void)commentToUser:(NSInteger)commentId
{
    [[TubeSDK sharedInstance].tubeArticleSDK commmentUserWithAtid:self.atid cid:self.currentCid fromeUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] toUid:self.toUid message:[NSString stringWithFormat:@"@%@ : %@", self.toUid, self.commentField.text] commentId:commentId callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            self.commentField.text = @"";
            index = 0;
            [self requstCommentList];
            [self.commentField resignFirstResponder];
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f fromeVC:self];
        } else {
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作失败" duration:1.0f fromeVC:self];
        }
    }];
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

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _backView;
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

#pragma mark - delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.checkKeyBoardStatus) {
        return YES;
    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0) {
        self.placeholderLable.hidden = YES;
    } else {
        self.placeholderLable.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCommentContent *c = (UserCommentContent *)self.contentData[indexPath.row];
    self.toUid = c.userUid;
    self.checkUserComment = YES;
    if (self.commentType == CommentTypeUser) {
        self.commentId = c.id;
    }
    self.currentCid = c.cid;
    [self.commentField becomeFirstResponder];
    NSLog(@"%s select item %@",__func__, c);
}

- (void)refreshData
{

    index = 0;
    [self requstCommentList];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    
    [self requstCommentList];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

@end
