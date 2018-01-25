//
//  DescoverTabViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DescoverTabViewController.h"
#import "TubeNavigationUITool.h"
#import "CKMacros.h"
#import "UIIndicatorView.h"
#import "Masonry.h"
#import "UIRingScrollView.h"
#import "SDCycleScrollView.h"
#import "DescoverRecommendViewController.h"
#import "DescoverTopicViewController.h"
#import "DescoverSerialViewController.h"

@interface DescoverTabViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIIndicatorView *indicator;
@property (nonatomic, strong) DescoverRecommendViewController *descoverRecommendViewController;
@property (nonatomic, strong) DescoverTopicViewController *descoverTopicViewController;
@property (nonatomic, strong) DescoverSerialViewController *descoverSerialViewController;

@end

@implementation DescoverTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createIndicator];
    [self configIndicator:self.indicator];
    [self configPageView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) arrayControllers:[NSMutableArray arrayWithObjects:self.descoverRecommendViewController, self.descoverTopicViewController, self.descoverSerialViewController, nil]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigation];
    [self configIndicator:self.indicator];//刷新布局
    [self configPageView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) arrayControllers:[NSMutableArray arrayWithObjects:self.descoverRecommendViewController, self.descoverTopicViewController, self.descoverSerialViewController, nil]];//刷新布局
}

- (void)configNavigation
{
    if (self.navigationController.navigationBar.isHidden) {
        self.navigationController.navigationBar.hidden = NO;
        [self.tabBarController.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)createIndicator
{
    if (!self.indicator) {
        self.indicator = [[UIIndicatorView alloc] initUIIndicatorView:kTUBEBOOK_THEME_NORMAL_COLOR
                                                                style:UIIndicatorViewLineStyle
                                                               arrays:[NSMutableArray arrayWithObjects:@"推荐",@"专题",@"连载", nil]
                                                                 font:Font(18)
                                                      textNormalColor:kTEXTCOLOR
                                                       textLightColor:kTUBEBOOK_THEME_NORMAL_COLOR
                                                   isEnableAutoScroll:NO];
        [self.navigationController.navigationBar addSubview:self.indicator];
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navigationController.navigationBar);
            make.centerY.equalTo(self.navigationController.navigationBar);
            make.width.mas_equalTo([self.indicator getUIWidth]);
            make.height.mas_equalTo([self.indicator getUIHeight]);
        }];
        [self.indicator setShowIndicatorItem:0];
        self.tabBarController.navigationItem.titleView = self.indicator;
    }
}

#pragma mark -get
- (DescoverRecommendViewController *)descoverRecommendViewController
{
    if (!_descoverRecommendViewController) {
        _descoverRecommendViewController = [[DescoverRecommendViewController alloc] init];
    }
    return _descoverRecommendViewController;
}

- (DescoverTopicViewController *)descoverTopicViewController
{
    if (!_descoverTopicViewController) {
        _descoverTopicViewController = [[DescoverTopicViewController alloc] init];
    }
    return _descoverTopicViewController;
}

- (DescoverSerialViewController *)descoverSerialViewController
{
    if (!_descoverSerialViewController) {
        _descoverSerialViewController = [[DescoverSerialViewController alloc] init];
    }
    return _descoverSerialViewController;
}

@end
