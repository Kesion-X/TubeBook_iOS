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

- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration {
    [self postAlterWithMessage:message duration:duration fromeVC:[self getRootVC]];
}

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
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    return  window.rootViewController;;
}

@end
