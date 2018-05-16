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
    [self configPageView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) arrayControllers:[NSMutableArray arrayWithObjects:self.descoverRecommendViewController,self.descoverSerialViewController, self.descoverTopicViewController,  nil]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    [self configNavigation];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.indicator.hidden = YES;
    NSLog(@"%s ",__func__);
}

- (void)configNavigation
{
    if (self.navigationController.navigationBar.isHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    self.indicator.hidden = NO;
   // self.tabBarController.navigationItem.titleView = self.indicator;
}

- (void)createIndicator
{
    if (!self.indicator) {
        self.indicator = [[UIIndicatorView alloc] initUIIndicatorViewWithIndicatorColor:kTUBEBOOK_THEME_NORMAL_COLOR
                                                                                  style:UIIndicatorViewLineStyle
                                                                                 arrays:[NSMutableArray arrayWithObjects:@"推荐",@"连载",@"专题", nil]
                                                                                   font:Font(18)
                                                                        textNormalColor:kTEXTCOLOR
                                                                         textLightColor:kTUBEBOOK_THEME_NORMAL_COLOR
                                                                     isEnableAutoScroll:NO];
        [self.navigationController.navigationBar addSubview:self.indicator];
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navigationController.navigationBar);
            make.centerY.equalTo(self.navigationController.navigationBar);
            make.width.mas_equalTo([self.indicator getUIWidth]);
            make.height.mas_equalTo([self.indicator getUIHeight] - 2);
        }];
        [self.indicator setShowIndicatorItem:0];
        [self.tabBarController.navigationItem.titleView removeFromSuperview];
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
