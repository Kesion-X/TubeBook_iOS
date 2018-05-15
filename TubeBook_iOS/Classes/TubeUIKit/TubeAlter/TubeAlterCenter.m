//
//  TubeAlterCenter.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeAlterCenter.h"
#import "AlterMessageViewController.h"
#import "AlterIndicatorMessageViewController.h"
#import "AlterNotificationViewController.h"

@interface TubeAlterCenter ()

@property (nonatomic, strong) UIViewController *postViewController;

@end

@implementation TubeAlterCenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static TubeAlterCenter *tubeAlterCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tubeAlterCenter = [[TubeAlterCenter alloc] init];
    });
    return tubeAlterCenter;
}

#pragma mark - alter notification
- (void)postAlterNotificationWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time duration:(CGFloat)duration
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        AlterNotificationViewController *vc = [[AlterNotificationViewController alloc] initAlterNotificationViewControllerWithContentTitle:title content:content time:time];
        weakSelf.postViewController = vc;
        [[self getRootVC] presentViewController:vc animated:NO completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:NO completion:nil];
            weakSelf.postViewController = nil;
        });
    });
}

#pragma mark - alter message
- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration fromeVC:(UIViewController *)sourceController
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        AlterMessageViewController *vc = [[AlterMessageViewController alloc] initAlterMessageViewControllerWithMessage:message];
        weakSelf.postViewController = vc;
        [sourceController presentViewController:vc animated:NO completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:NO completion:nil];
            weakSelf.postViewController = nil;
        });
        
    });
}

- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration fromeVC:(UIViewController *)sourceController completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0)
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        AlterMessageViewController *vc = [[AlterMessageViewController alloc] initAlterMessageViewControllerWithMessage:message];
        weakSelf.postViewController = vc;
        [sourceController presentViewController:vc animated:NO completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:NO completion:completion];
            weakSelf.postViewController = nil;
        });
        
    });
}

- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration completion: (void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0) {
    [self postAlterWithMessage:message duration:duration fromeVC:[self getRootVC] completion:completion];
}

- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration {
    [self postAlterWithMessage:message duration:duration fromeVC:[self getRootVC]];
}

#pragma mark - alter indicator
- (void)showAlterIndicatorWithMessage:(NSString *)message fromeVC:(UIViewController *)sourceController
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        AlterIndicatorMessageViewController *vc = [[AlterIndicatorMessageViewController alloc] initAlterIndicatorMessageViewControllerWithMessage:message];
        [sourceController presentViewController:vc animated:NO completion:nil];
        weakSelf.postViewController = vc;
    });
}

- (void)dismissAlterIndicatorViewController
{
   __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.postViewController dismissViewControllerAnimated:NO completion:nil];
            weakSelf.postViewController = nil;
        });
    });
}

- (UIViewController *)getRootVC
{
//    UIViewController *result = nil;
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    return  window.rootViewController;
    return [self currentViewController];
}

- (UIViewController*)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }

        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
 
    }
    return vc;
}



- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];

    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow * tmpWin in windows)
    {
        if (tmpWin.windowLevel > window.windowLevel)
        {
            window = tmpWin;
        }
    }

    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    result = nextResponder;
    else
    result = window.rootViewController;
    
    return result;
}

- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
        
        return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

@end
