//
//  TubeAlterCenter.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TubeAlterCenter : NSObject

+ (instancetype)sharedInstance;

- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration fromeVC:(UIViewController *)sourceController;
- (void)showAlterIndicatorWithMessage:(NSString *)message fromeVC:(UIViewController *)sourceController;
- (void)dismissAlterIndicatorViewController;
- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration;
- (void)postAlterNotificationWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time duration:(CGFloat)duration;
- (void)postAlterWithMessage:(NSString *)message duration:(CGFloat)duration completion: (void (^ __nullable)(void))completion;

@end
