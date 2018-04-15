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
#import "Masonry.h"

@interface DetailViewController ()

@property (nonatomic, strong) InfoDescriptionView *infoView;
//@property (nonatomic, strong) UIIndicatorView *indicatorView;
@property (nonatomic, strong) DetailMemberViewController *memberViewController;
@property (nonatomic, strong) DetialArticleListViewController *articleListViewControll;
@property (nonatomic, strong) CommentUIViewController *commentViewController;



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
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    switch (self.tubeDetailType) {
        case TubeDetailTypeTopic:
        {
            self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
            UILabel *titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
            titleLable.text = @"专题";
            [self.navigationController.navigationBar addSubview:titleLable];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.navigationController.navigationBar);
                make.centerY.equalTo(self.navigationController.navigationBar);
            }];
            self.navigationController.navigationItem.titleView = titleLable;
            break;
        }
        case TubeDetailTypeSerial:
        {
            self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
            UILabel *titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
            titleLable.text = @"连载";
            [self.navigationController.navigationBar addSubview:titleLable];
            [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.navigationController.navigationBar);
                make.centerY.equalTo(self.navigationController.navigationBar);
            }];
            self.navigationController.navigationItem.titleView = titleLable;
            break;
        }
        case TubeDetailTypeUser:
        {
            break;
        }
        default:
            break;
    }
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
    self.infoView = [[InfoDescriptionView alloc] initInfoDescriptionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeTopic]) infoType:InfoDescriptionTypeTopic];
    [self.view addSubview:self.infoView];
    [self.infoView setDetailBackImage:[UIImage imageNamed:@"detail_back3.jpg"]];
    [self.infoView setSpaceColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
    [self.infoView setAllTitleLableWithColor:[UIColor whiteColor]];
    
    self.indicatorView = [[UIIndicatorView alloc] initUIIndicatorViewWithFrame:CGRectMake(0, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeTopic] + 0, SCREEN_WIDTH, SCREEN_HEIGHT - [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeTopic]) style:UIIndicatorViewLineStyle arrays:[NSMutableArray arrayWithObjects:@"文章列表", @"评论", nil]];
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
    [self configPageView:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y) arrayControllers:[NSMutableArray arrayWithObjects:self.articleListViewControll,self.commentViewController, nil]];
}

#pragma mark - action

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - get

- (DetialArticleListViewController *)articleListViewControll
{
    if (!_articleListViewControll) {
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


@end
