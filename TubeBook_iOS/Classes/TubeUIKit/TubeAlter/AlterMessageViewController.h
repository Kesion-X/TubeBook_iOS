//
//  AlterMessageViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCenterView.h"
#import "CKMessageCenterView.h"
#import "AlterBaseViewController.h"

@interface AlterMessageViewController : AlterBaseViewController

- (instancetype)initAlterMessageViewControllerWithMessage:(NSString *)message;
- (instancetype)initAlterMessageViewControllerWithMessage:(NSString *)message duration:(CGFloat)duration;

@end
