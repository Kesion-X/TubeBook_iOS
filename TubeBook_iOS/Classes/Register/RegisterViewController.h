//
//  RegisterViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ registerStatus) (BOOL isSuccess,NSString *account,NSString *pass);

@interface RegisterViewController : UIViewController

@property (nonatomic, copy) registerStatus registerStatus;

- (instancetype)initRegisterViewController:(registerStatus )registerStatus;

@end
