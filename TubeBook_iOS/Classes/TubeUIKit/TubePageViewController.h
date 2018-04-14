//
//  TubePageViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIIndicatorView.h"

@interface TubePageViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *arrayControllers;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIIndicatorView *indicatorView;

// 如果界面支持UIIndicatorView 需要调用
- (void)configIndicator:(UIIndicatorView *)indicator;
// 必须配置arrayControllers
- (void)configPageView:(CGRect)frame arrayControllers:(NSMutableArray *)arrayControllers;


- (NSUInteger)getCurrentPageIndex:(UIViewController *)controller;
- (UIScrollView *)findScrollView;


@end
