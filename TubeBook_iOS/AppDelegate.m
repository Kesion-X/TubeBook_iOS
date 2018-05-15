//
//  AppDelegate.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginUIViewController.h"
#import "HomeTabViewController.h"
#import "DescoverTabViewController.h"
#import "MessageTabViewController.h"
#import "MyselfTabViewController.h"
#import "TubeMainTabBarController.h"
#import "TubeRootViewController.h"
#import "TubeSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    self.window.backgroundColor = [UIColor whiteColor];

    UIViewController *rootViewController = [self getRootViewController];
    
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    [[TubeSDK sharedInstance] connect]; // 连接服务端
    return YES;
}
    
- (UIViewController *)getRootViewController{
    
    NSLog(@"%s  choose root controller",__func__);
    UIViewController *root = [[UINavigationController alloc] initWithRootViewController:[[LoginUIViewController alloc] init]];
    return root;
}

- (void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

@end
