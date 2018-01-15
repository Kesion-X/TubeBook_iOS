//
//  TubeMainTabBarController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTabViewController.h"
#import "MessageTabViewController.h"
#import "MyselfTabViewController.h"
#import "DescoverTabViewController.h"

@interface TubeMainTabBarController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, strong) UIViewController *homeTabViewController;
@property (nonatomic, strong) UIViewController *descoverTabViewController;
@property (nonatomic, strong) UIViewController *messageTabViewController;
@property (nonatomic, strong) UIViewController *myselfTabViewController;

@end
