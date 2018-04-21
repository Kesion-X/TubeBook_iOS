//
//  TubeRootViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRootViewController.h"
#import "CKMacros.h"
#import "ReactiveObjC.h"
#import "Masonry.h"

@interface TubeRootViewController ()

@end

@implementation TubeRootViewController

- (void)dealloc
{
    self.delegate = nil;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    _rootViewController = rootViewController;
   // [self.navigationBar setBarTintColor:HEXCOLOR(0xf8f9f9)];//默认导航背景颜色
    [self.navigationBar setBarTintColor:HEXCOLOR(0xffffff)];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont systemFontOfSize:18]
                                                 }];
    [self.navigationBar setTintColor:HEXCOLOR(0xf8f9f9)];
    [self.navigationBar setTranslucent:NO];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationBar setNeedsLayout];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.navigationBar layoutIfNeeded];
        }];
    }];
    return self;
}

- (void)setNavigationControllerTitleView:(UIView *)view
{
    [self.navigationController.navigationBar addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationController.navigationBar);
        make.centerY.equalTo(self.navigationController.navigationBar);
    }];
    self.navigationController.navigationItem.titleView = view;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController.view.backgroundColor) { // 未设置背景色，则使用默认背景色#ffffff
        viewController.view.backgroundColor = HEXCOLOR(0xffffff);
    }
}



@end
