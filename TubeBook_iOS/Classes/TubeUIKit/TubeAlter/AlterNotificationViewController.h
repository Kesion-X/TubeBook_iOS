//
//  AlterNotificationViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AlterBaseViewController.h"

@interface AlterNotificationViewController : AlterBaseViewController

@property (nonatomic, strong) NSString *contentTitle;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;

- (instancetype)initAlterNotificationViewControllerWithContentTitle:(NSString *)contentTitle content:(NSString *)content time:(NSString *)time;

@end
