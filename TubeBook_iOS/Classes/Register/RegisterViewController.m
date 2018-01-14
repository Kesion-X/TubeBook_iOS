//
//  RegisterViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "RegisterViewController.h"
#import "CKMacros.h"
#import "TubeNavigationUITool.h"

@interface RegisterViewController ()



@end

@implementation RegisterViewController

- (instancetype)initRegisterViewController:(registerStatus )registerStatus
{
    self = [super init];
    if (self) {
        self.registerStatus = registerStatus;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigation];
    
}

- (void)initNavigation
{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:HEXCOLOR(0xffffff)];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTEXTCOLOR target:self action:@selector(pop)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [TubeNavigationUITool itemTitleWithLableTitle:@"账号注册" titleColoe:kTUBEBOOK_THEME_NORMAL_COLOR];
}

- (void)pop
{
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{

   // [self.navigationController setNavigationBarHidden:YES animated:NO];
 
}

- (void)dealloc
{
    //self.didBlock();
}

@end
