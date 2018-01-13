//
//  LoginUIViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "LoginUIViewController.h"
#import "UIImageFileldView.h"
#import "Masonry.h"

@interface LoginUIViewController ()

@end

@implementation LoginUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // UIImageFileldView *view = [[UIImageFileldView alloc] initWithFrame:CGRectMake(8, 22, [UIScreen mainScreen].bounds.size.width-16, 80) rightImage:@"icon_lock" isSecret:YES];
    self.view.backgroundColor = [UIColor yellowColor];
    UIImageFileldView *view = [[UIImageFileldView alloc] initUIImageFileldView:@"icon_lock" placeholder:@"请输入密码" isSecret:NO];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(22);
        make.height.mas_equalTo(40);
    }];
    [view setFieldBlock:^(NSString *text) {
        NSLog(@"%@",text);
    }];
    
}





@end
