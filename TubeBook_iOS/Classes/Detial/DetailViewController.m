//
//  DetailViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DetailViewController.h"
#import "InfoDescriptionView.h"
#import "TubeNavigationUITool.h"
#import "UIIndicatorView.h"
#import "DetailMemberViewController.h"
#import "DetialArticleListViewController.h"
#import "CommentUIViewController.h"
#import "SerialViewController.h"
#import "Masonry.h"
#import "TubeSDK.h"
#import "TubeAlterCenter.h"

@interface DetailViewController ()

@property (nonatomic, strong) InfoDescriptionView *infoView;
//@property (nonatomic, strong) UIIndicatorView *indicatorView;
@property (nonatomic, strong) DetailMemberViewController *memberViewController;
@property (nonatomic, strong) DetialArticleListViewController *articleListViewControll;
@property (nonatomic, strong) CommentUIViewController *commentViewController;
@property (nonatomic, strong) SerialViewController *userSerialViewController;
@property (nonatomic, strong) UILabel *titleLable;


@end

@implementation DetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initTopicDetailViewControllerWithTabid:(NSInteger)tabid uid:(NSString *)uid
{
    self = [self init];
    if (self) {
        self.tabid = tabid;
        self.uid = uid;
        self.tubeDetailType = TubeDetailTypeTopic;
    }
    return self;
}

- (instancetype)initSerialDetailViewControllerWithTabid:(NSInteger)tabid uid:(NSString *)uid
{
    self = [self init];
    if (self) {
        self.tabid = tabid;
        self.uid = uid;
        self.tubeDetailType = TubeDetailTypeSerial;
    }
    return self;
}

- (instancetype)initUserDetailViewControllerWithUid:(NSString *)uid
{
    self = [self init];
    if (self) {
        self.uid = uid;
        self.tubeDetailType = TubeDetailTypeUser;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    switch (self.tubeDetailType) {
        case TubeDetailTypeTopic:
        {
            [self loadTopicView];
            break;
        }
        case TubeDetailTypeSerial:
        {
            [self loadSerialView];
            break;
        }
        case TubeDetailTypeUser:
        {
            [self loadUserView];
            break;
        }
        default:
            break;
    }
    [self.infoView setActionForLikeButtonWithTarget:self action:@selector(setLikeStatus:)];
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
    switch (self.tubeDetailType) {
        case TubeDetailTypeTopic:
        {
            self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
            if (!self.titleLable) {
                self.titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
                self.titleLable.text = @"专题";
            }
            [self.navigationController.navigationBar addSubview:self.titleLable];
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.navigationController.navigationBar);
                make.centerY.equalTo(self.navigationController.navigationBar);
            }];
            self.infoView.infoMottoLable.hidden = YES;
            self.infoView.infoNameLable.hidden = YES;
            [self requestTopicInfo];
            [self requestTabLikeStatus];
            break;
        }
        case TubeDetailTypeSerial:
        {
            self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
            if (!self.titleLable) {
                self.titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
                self.titleLable.text = @"连载";
            }
            [self.navigationController.navigationBar addSubview:self.titleLable];
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.navigationController.navigationBar);
                make.centerY.equalTo(self.navigationController.navigationBar);
            }];
            self.infoView.infoMottoLable.hidden = YES;
            self.infoView.infoNameLable.hidden = YES;
            [self requestSerialInfo];
            [self requestTabLikeStatus];
            break;
        }
        case TubeDetailTypeUser:
        {
            self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
            if (!self.titleLable) {
                self.titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
                self.titleLable.text = @"用户信息";
            }
            [self.navigationController.navigationBar addSubview:self.titleLable];
            [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.navigationController.navigationBar);
                make.centerY.equalTo(self.navigationController.navigationBar);
            }];
            self.infoView.infoTimeLable.hidden = YES;
            self.infoView.infoTitleLable.hidden = YES;
            self.infoView.infoDescriptionLable.hidden = YES;
            [self requestUserInfo];
            [self requestUserLikeStatus];
            break;
        }
        default:
            break;
    }

}

- (IBAction)setLikeStatus:(id)sender
{
    if (self.tubeDetailType == TubeDetailTypeTopic) {
        [[TubeSDK sharedInstance].tubeArticleSDK setArticleTabWithLikeStatus:!self.infoView.isLike tabid:self.tabid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] articleType:ArticleTypeTopic callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
            if (status == DataCallBackStatusSuccess) {
                [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f fromeVC:self];
                [self requestTabLikeStatus];
            }
        }];
    } else if (self.tubeDetailType == TubeDetailTypeSerial) {
        [[TubeSDK sharedInstance].tubeArticleSDK setArticleTabWithLikeStatus:!self.infoView.isLike tabid:self.tabid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] articleType:ArticleTypeSerial callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
            if (status == DataCallBackStatusSuccess) {
                [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f fromeVC:self];
                [self requestTabLikeStatus];
            }
        }];
    } else {
        [[TubeSDK sharedInstance].tubeUserSDK setUserAttentWithStatus:!self.infoView.isLike uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] attentUid:self.uid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
            if (status == DataCallBackStatusSuccess) {
                [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f fromeVC:self];
                [self requestUserLikeStatus];
            }
        }];
    }
}

- (void)requestUserLikeStatus
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedUserAttentStatusWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] attentUid:self.uid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            BOOL isLike = [[content objectForKey:@"isAttent"] boolValue];
            [self.infoView setIsLike:isLike];
        }
    }];
}

- (void)requestUserInfo
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedUserInfoWithUid:self.uid isSelf:NO callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *contentDic = page.content.contentData;
            NSDictionary *userinfo = [contentDic objectForKey:@"userinfo"];
            NSString *avatar = [userinfo objectForKey:@"avatar"];
            NSString *userName = [userinfo objectForKey:@"account"];
            NSString *nick = [userinfo objectForKey:@"nick"];
            if ( nick && nick.length>0 ) {
                userName = [userinfo objectForKey:@"nick"];
            }
            NSString *motto = [userinfo objectForKey:@"description"];
            if (!motto || motto.length==0) {
                motto = @"暂无简介";
            }
            [self.infoView setInfoName:userName];
            [self.infoView setInfomotto:motto];
            [self.infoView setInfoImageUrl:avatar];
        }
    }];
}

- (void)requestTabLikeStatus
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedTabLikeStatusWithTabid:self.tabid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            BOOL isLike = [[content objectForKey:@"isLike"] boolValue];
            [self.infoView setIsLike:isLike];
        }
    }];
}

- (void)requestTopicInfo
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleTopicDetailWithTabid:self.tabid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            NSDictionary *detailInfo = [content objectForKey:@"detailInfo"];
            NSString *title = [detailInfo objectForKey:@"title"];
            NSString *description = [detailInfo objectForKey:@"description"];
            NSString *picUrl = [detailInfo objectForKey:@"pic"];
            NSInteger time = [[detailInfo objectForKey:@"create_time"] integerValue];
            [self.infoView setInfoTitle:[@"标题：" stringByAppendingString:title]];
            [self.infoView setInfoDescription:[@"简介："stringByAppendingString:description]];
            [self.infoView setInfoTime:[TimeUtil getDateWithTime:time]];
            [self.infoView setInfoImageUrl:picUrl];
        }
    }];
}

- (void)requestSerialInfo
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleSerialDetailWithTabid:self.tabid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            NSDictionary *detailInfo = [content objectForKey:@"detailInfo"];
            NSString *title = [detailInfo objectForKey:@"title"];
            NSString *description = [detailInfo objectForKey:@"description"];
            NSString *picUrl = [detailInfo objectForKey:@"pic"];
            NSInteger time = [[detailInfo objectForKey:@"create_time"] integerValue];
            [self.infoView setInfoTitle:[@"标题：" stringByAppendingString:title]];
            [self.infoView setInfoDescription:[@"简介："stringByAppendingString:description]];
            [self.infoView setInfoTime:[TimeUtil getDateWithTime:time]];
            [self.infoView setInfoImageUrl:picUrl];
        }
    }];
}

- (void)loadTopicView
{
    self.infoView = [[InfoDescriptionView alloc] initInfoDescriptionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeTopic]) infoType:InfoDescriptionTypeTopic];
    [self.view addSubview:self.infoView];
    [self.infoView setDetailBackImage:[UIImage imageNamed:@"detail_back3.jpg"]];
    [self.infoView setSpaceColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
    [self.infoView setAllTitleLableWithColor:[UIColor whiteColor]];
    
    self.indicatorView = [[UIIndicatorView alloc] initUIIndicatorViewWithFrame:CGRectMake(0, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeTopic] + 0, SCREEN_WIDTH, SCREEN_HEIGHT - [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeTopic]) style:UIIndicatorViewLineStyle arrays:[NSMutableArray arrayWithObjects:@"文章列表", @"成员", nil]];
    [self.view addSubview:self.indicatorView];
    self.indicatorView.delegate = self;
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo([self.indicatorView getUIWidth]);
        make.height.mas_equalTo([self.indicatorView getUIHeight]);
    }];
    
    UIView * spaceLine = [[UIView alloc] init];
    [self.view addSubview:spaceLine];
    [spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indicatorView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    [spaceLine setBackgroundColor:kTEXTCOLOR];
    CGFloat y = [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeTopic]  + [self.indicatorView getUIHeight] + 1;
    [self configPageView:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y) arrayControllers:[NSMutableArray arrayWithObjects:self.articleListViewControll,self.memberViewController, nil]];
}

- (void)loadSerialView
{
    self.infoView = [[InfoDescriptionView alloc] initInfoDescriptionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeSerial]) infoType:InfoDescriptionTypeSerial];
    [self.view addSubview:self.infoView];
    [self.infoView setDetailBackImage:[UIImage imageNamed:@"detail_back2.jpg"]];
    [self.infoView setSpaceColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
    [self.infoView setAllTitleLableWithColor:[UIColor whiteColor]];
    
    self.indicatorView = [[UIIndicatorView alloc] initUIIndicatorViewWithFrame:CGRectMake(0, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeSerial] + 0, SCREEN_WIDTH, SCREEN_HEIGHT - [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeSerial]) style:UIIndicatorViewLineStyle arrays:[NSMutableArray arrayWithObjects:@"文章列表", @"评论", nil]];
    [self.view addSubview:self.indicatorView];
    self.indicatorView.delegate = self;
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo([self.indicatorView getUIWidth]);
        make.height.mas_equalTo([self.indicatorView getUIHeight]);
    }];
    
    UIView * spaceLine = [[UIView alloc] init];
    [self.view addSubview:spaceLine];
    [spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indicatorView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    [spaceLine setBackgroundColor:kTEXTCOLOR];
    CGFloat y = [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeSerial]  + [self.indicatorView getUIHeight] + 1;
    [self configPageView:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y) arrayControllers:[NSMutableArray arrayWithObjects:self.articleListViewControll,self.commentViewController, nil]];
}

- (void)loadUserView
{
    self.infoView = [[InfoDescriptionView alloc] initInfoDescriptionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeUser]) infoType:InfoDescriptionTypeUser];
    [self.view addSubview:self.infoView];
    
    self.indicatorView = [[UIIndicatorView alloc] initUIIndicatorViewWithFrame:CGRectMake(0, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeUser] + 0, SCREEN_WIDTH, SCREEN_HEIGHT - [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeUser]) style:UIIndicatorViewLineStyle arrays:[NSMutableArray arrayWithObjects:@"文章列表", @"他的连载", nil]];
    [self.view addSubview:self.indicatorView];
    self.indicatorView.delegate = self;
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo([self.indicatorView getUIWidth]);
        make.height.mas_equalTo([self.indicatorView getUIHeight]);
    }];
    
    UIView * spaceLine = [[UIView alloc] init];
    [self.view addSubview:spaceLine];
    [spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indicatorView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    [spaceLine setBackgroundColor:kTEXTCOLOR];
    CGFloat y = [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeUser]  + [self.indicatorView getUIHeight] + 1;
    [self configPageView:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y) arrayControllers:[NSMutableArray arrayWithObjects:self.articleListViewControll,self.userSerialViewController, nil]];
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
}

#pragma mark - get

- (DetialArticleListViewController *)articleListViewControll
{
    if (!_articleListViewControll) {
        if (self.tubeDetailType == TubeDetailTypeUser) {
            _articleListViewControll = [[DetialArticleListViewController alloc] initDetialArticleListViewControllerWithDetailType:self.tubeDetailType uid:self.uid];
            return _articleListViewControll;
        }
        _articleListViewControll = [[DetialArticleListViewController alloc] initDetialArticleListViewControllerWithDetailType:self.tubeDetailType tabid:self.tabid];
//        switch (self.tubeDetailType) {
//            case TubeDetailTypeTopic:
//            {
//                _articleListViewControll = [[DetialArticleListViewController alloc] initDetialArticleListViewControllerWithDetailType:self.tubeDetailType tabid:self.tabid];
//                break;
//            }
//            case TubeDetailTypeSerial:
//            {
//                _articleListViewControll = [[DetialArticleListViewController alloc] initDetialArticleListViewControllerWithDetailType:self.tubeDetailType tabid:self.tabid];
//                break;
//            }
//                
//            default:
//                break;
//        }

    }
    return _articleListViewControll;
}

- (DetailMemberViewController *)memberViewController
{
    if (!_memberViewController){
        _memberViewController = [[DetailMemberViewController alloc] init];
    }
    return _memberViewController;
}

- (CommentUIViewController *)commentViewController
{
    if (!_commentViewController) {
        _commentViewController = [[CommentUIViewController alloc] init];
    }
    return _commentViewController;
}

- (SerialViewController *)userSerialViewController
{
    if (!_userSerialViewController) {
        _userSerialViewController = [[SerialViewController alloc] initSerialViewControllerWithFouseType:FouseTypeCreate uid:self.uid];
    }
    return _userSerialViewController;
}

@end
