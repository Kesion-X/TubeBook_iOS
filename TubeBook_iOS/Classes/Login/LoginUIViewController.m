//
//  LoginUIViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "LoginUIViewController.h"
#import "UIImageFieldView.h"
#import "Masonry.h"
#import "UITubeButton.h"
#import "CKMacros.h"
#import "ReactiveObjC.h"
#import "RegisterViewController.h"
#import "TubeSDK.h"
#import "TubeLink.h"
#import "TubeRootViewController.h"
#import "TubeMainTabBarController.h"
#import "AltertControllerUtil.h"
#import "UserInfoUtil.h"

@interface LoginUIViewController () <TubeLoginDelegate>

@property (nonatomic, strong) UIImageFieldView *accountField;
@property (nonatomic, strong) UIImageFieldView *passField;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UITubeButton *loginButton;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *forgetButton;
@property (nonatomic, strong) UILabel *myCopyRightLabel;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *pass;
    
@end

@implementation LoginUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSelfView];
    [self addSubViews];
    [self addConstraint];
    [self loadData];
    
}
    
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma -mark private
- (void)setupSelfView
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addSubViews
{
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.loginView];
    [self.loginView addSubview:self.accountField];
    [self.loginView addSubview:self.passField];
    [self.loginView addSubview:self.loginButton];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.myCopyRightLabel];
}

- (void)addConstraint
{
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(CK_WIDTH(30));
        make.right.equalTo(self.view.mas_right).offset(CK_WIDTH(-8));
    }];
    
    UIView *titleView = [[UIView alloc] init];
    [self.view addSubview:titleView];
    [titleView addSubview:self.logoImage];
    [titleView addSubview:self.titleLabel];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(titleView);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImage.mas_right).offset(8);
        make.bottom.equalTo(self.logoImage);
    }];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
        attrDict[NSFontAttributeName] = self.titleLabel.font;
        make.width.mas_equalTo(48+[self.titleLabel.text sizeWithAttributes:attrDict].width);
        make.centerX.equalTo(self.view).offset(0);
        make.height.equalTo(@48);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(32);
        make.centerX.equalTo(self.view).offset(0);
    }];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(28);
        make.left.equalTo(self.view.mas_left).offset(32);
        make.right.equalTo(self.view.mas_right).offset(-32);
        make.height.equalTo(@200);
    }];
    UILabel *loginLable = [[UILabel alloc] init];
    loginLable.text = @"登录";
    loginLable.font = Font(18);
    loginLable.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    [self.loginView addSubview:loginLable];
    [loginLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView).offset(8);
        make.centerX.equalTo(self.loginView);
    }];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginLable.mas_bottom).offset(16);
        make.left.equalTo(self.loginView).offset(8);
        make.right.equalTo(self.loginView).offset(-8);
        make.height.equalTo(@40);
    }];
    [self.passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountField.mas_bottom).offset(8);
        make.left.equalTo(self.loginView).offset(8);
        make.right.equalTo(self.loginView).offset(-8);
        make.height.equalTo(@40);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passField.mas_bottom).offset(16);
        make.left.equalTo(self.loginView).offset(16);
        make.right.equalTo(self.loginView).offset(-16);
        make.height.equalTo(@36);
    }];
    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView.mas_bottom).offset(16);
        make.right.equalTo(self.loginView.mas_right).offset(-8);
    }];
    [self.myCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
        make.centerX.equalTo(self.view);
    }];
}

- (void)loadData
{
    [[TubeSDK sharedInstance].tubeLoginSDK addListener:self];
    NSString *a = [[NSUserDefaults standardUserDefaults] objectForKey:kAccountKey];
    NSString *p = [[NSUserDefaults standardUserDefaults] objectForKey:kPass];
    if ( a && p ) {
        self.account = a;
        self.pass = p;
        [[TubeSDK sharedInstance].tubeLoginSDK login:a pass:p];
    }
   // weakify(self);
    __block LoginUIViewController *blockSelf = self;
    [self.accountField setFieldBlock:^(NSString *text) {
        blockSelf.account = text;
    }];
    [self.passField setFieldBlock:^(NSString *text) {
        blockSelf.pass = text;
    }];
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerViewController animated:YES];
    }];
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[TubeSDK sharedInstance].tubeLoginSDK login:self.account pass:self.pass];
        [[NSUserDefaults standardUserDefaults] setObject:self.account forKey:kAccountKey];
        [[NSUserDefaults standardUserDefaults] setObject:self.pass forKey:kPass];
        //[UIApplication sharedApplication].keyWindow.rootViewController = [[TubeRootViewController alloc] initWithRootViewController:[[TubeMainTabBarController alloc] init]];
    }];
}

#pragma mark - TubeLoginDelegate
- (void)loginSuccess:(NSDictionary *)message
{
    [[UserInfoUtil sharedInstance].userInfo setObject:self.account forKey:kAccountKey];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TubeRootViewController alloc] initWithRootViewController:[[TubeMainTabBarController alloc] init]];
}
    
- (void)loginFail:(NSDictionary *)message
{
    [AltertControllerUtil showAlertTitle:nil
                                 message:@"账号或密码错误!"
                            confirmTitle:@"确定"
                            confirmBlock:nil
                             cancelTitle:nil
                             cancelBlock:nil
                           fromControler:self];
}
    
#pragma mark - get
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

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitleColor:kTEXTCOLOR forState:UIControlStateNormal];
        [_registerButton setTitleColor:kTEXT_ALPHA_COLOR forState:UIControlStateHighlighted];
        [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
        _registerButton.titleLabel.font = Font(14);
    }
    return _registerButton;
}

- (UITubeButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UITubeButton alloc] initUITubeButton:@"登录" normalColor:kTUBEBOOK_THEME_NORMAL_COLOR lightColor:kTUBEBOOK_THEME_ALPHA_COLOR];
        _loginButton.titleLabel.font = Font(16);
        _loginButton.titleLabel.textColor = [UIColor whiteColor];
    }
    return _loginButton;
}

- (UIView *)loginView
{
    if (!_loginView) {
        _loginView = [[UIView alloc] init];
        _loginView.backgroundColor = HEXACOLOR(0xdddddd, 0.4);
        _loginView.layer.cornerRadius = 5;
        _loginView.layer.masksToBounds = YES;
        _loginView.layer.borderWidth = 0.5;
        _loginView.layer.borderColor = kTEXTCOLOR.CGColor;
    }
    return _loginView;
}

- (UIImageView *)logoImage
{
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] init];
        [_logoImage setImage:[CKMacros createImageWithColor:[UIColor grayColor]]];
    }
    return _logoImage;
}

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

- (UIButton *)forgetButton
{
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc] init];
        [_forgetButton setTitleColor:kTEXTCOLOR forState:UIControlStateNormal];
        [_forgetButton setTitleColor:kTEXT_ALPHA_COLOR forState:UIControlStateHighlighted];
        [_forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = Font(12);
    }
    return _forgetButton;
}

- (UILabel *)myCopyRightLabel
{
    if (!_myCopyRightLabel) {
        _myCopyRightLabel = [[UILabel alloc] init];
        _myCopyRightLabel.text = @"Copyright © 2017-2018 Kesion. All Right Reserved.";
        _myCopyRightLabel.font = Font(12);
        _myCopyRightLabel.textColor = kTEXTCOLOR;
    }
    return _myCopyRightLabel;
}

@end
