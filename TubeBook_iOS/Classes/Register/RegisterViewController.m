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
#import "UIRectangleView.h"
#import "UIImageFieldView.h"
#import "UITubeButton.h"
#import "Masonry.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIRectangleView *registerView;
@property (nonatomic, strong) UIImageFieldView *nickField;
@property (nonatomic, strong) UIImageFieldView *accountField;
@property (nonatomic, strong) UIImageFieldView *passField;
@property (nonatomic, strong) UIImageFieldView *passAgainField;
@property (nonatomic, strong) UITubeButton *registerButton;

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
    [self addSubViews];
    [self addConstraint];
}

#pragma -mark private
- (void)addSubViews
{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.registerView];
    [self.registerView addSubview:self.accountField];
    [self.registerView addSubview:self.nickField];
    [self.registerView addSubview:self.passAgainField];
    [self.registerView addSubview:self.passField];
    [self.view addSubview:self.registerButton];
}

- (void)addConstraint
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(16);
        make.left.equalTo(self.view).offset(16);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(16);
    }];
    
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(28);
        make.left.equalTo(self.view.mas_left).offset(32);
        make.right.equalTo(self.view.mas_right).offset(-32);
        make.height.equalTo(@296);
    }];
    UILabel *registerLable = [[UILabel alloc] init];
    registerLable.text = @"注册账号";
    registerLable.font = Font(18);
    registerLable.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    [self.registerView addSubview:registerLable];
    [registerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.registerView).offset(8);
        make.centerX.equalTo(self.registerView);
    }];
    [self.nickField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerLable.mas_bottom).offset(16);
        make.left.equalTo(self.registerView).offset(8);
        make.right.equalTo(self.registerView).offset(-8);
        make.height.equalTo(@40);
    }];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickField.mas_bottom).offset(8);
        make.left.equalTo(self.registerView).offset(8);
        make.right.equalTo(self.registerView).offset(-8);
        make.height.equalTo(@40);
    }];
    [self.passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountField.mas_bottom).offset(8);
        make.left.equalTo(self.registerView).offset(8);
        make.right.equalTo(self.registerView).offset(-8);
        make.height.equalTo(@40);
    }];
    [self.passAgainField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passField.mas_bottom).offset(8);
        make.left.equalTo(self.registerView).offset(8);
        make.right.equalTo(self.registerView).offset(-8);
        make.height.equalTo(@40);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passAgainField.mas_bottom).offset(16);
        make.left.equalTo(self.registerView).offset(16);
        make.right.equalTo(self.registerView).offset(-16);
        make.height.equalTo(@36);
    }];
    
}

- (void)initNavigation
{
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:HEXCOLOR(0xffffff)];
    [self.navigationController.navigationBar setTranslucent:NO];
    UINavigationBar *bar = self.navigationController.navigationBar;
    NSLog(@"%f",bar.bounds.size.height);
    self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTEXTCOLOR target:self action:@selector(pop)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [TubeNavigationUITool itemTitleWithLableTitle:@"账号注册" titleColoe:kTUBEBOOK_THEME_NORMAL_COLOR];
}

- (void)pop
{
        [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark get
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"TubeBook";
        _titleLabel.font = FontBold(26);
        _titleLabel.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.textColor = kTEXTCOLOR;
        _descriptionLabel.text = @"TubeBook 倾听故事，分享你的生活";
        _descriptionLabel.font = Font(14);
    }
    return _descriptionLabel;
}

- (UIRectangleView *)registerView
{
    if (!_registerView) {
        _registerView = [[UIRectangleView alloc] initUIRectangleView:HEXACOLOR(0xdddddd, 0.4)];
    }
    return _registerView;
}

- (UIImageFieldView *)accountField
{
    if (!_accountField) {
        _accountField = [[UIImageFieldView alloc] initUIImageFieldView:@"icon_user" placeholder:@"请输入账号" isSecret:NO];
    }
    return _accountField;
}

- (UIImageFieldView *)passField
{
    if (!_passField) {
        _passField = [[UIImageFieldView alloc] initUIImageFieldView:@"icon_lock" placeholder:@"请输入密码" isSecret:YES];
    }
    return _passField;
}

- (UIImageFieldView *)passAgainField
{
    if (!_passAgainField) {
        _passAgainField = [[UIImageFieldView alloc] initUIImageFieldView:@"icon_lock" placeholder:@"请再次输入密码" isSecret:YES];
    }
    return _passAgainField;
}

- (UIImageFieldView *)nickField
{
    if (!_nickField) {
        _nickField = [[UIImageFieldView alloc] initUIImageFieldView:@"icon_nick" placeholder:@"请输入昵称" isSecret:YES];
    }
    return _nickField;
}

- (UITubeButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[UITubeButton alloc] initUITubeButton:@"注册" normalColor:kTUBEBOOK_THEME_NORMAL_COLOR lightColor:kTUBEBOOK_THEME_ALPHA_COLOR];
        _registerButton.titleLabel.font = Font(16);
        _registerButton.titleLabel.textColor = [UIColor whiteColor];
    }
    return _registerButton;
}

@end
