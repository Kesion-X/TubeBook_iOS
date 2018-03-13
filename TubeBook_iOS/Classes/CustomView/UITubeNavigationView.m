//
//  UITubeNavigationView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/8.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UITubeNavigationView.h"
#import "CKMacros.h"
#define MormalColor [UIColor whiteColor]
#define LightColor kTUBEBOOK_THEME_NORMAL_COLOR

@interface UITubeNavigationView ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIViewController *sourceViewController;
@property (nonatomic, weak) leftBtCallback leftCallback;
@property (nonatomic, weak) rightBtCallback rightCallback;
@property (nonatomic, strong) NSString *leftTitle;
@property (nonatomic, strong) NSString *rightTitle;
@property (nonatomic, strong) NSString *centerTitle;

@end

@implementation UITubeNavigationView

- (instancetype) initUITubeNavigationView:(UIViewController *)sourceViewController leftTitle:(NSString *)leftTitle leftBtCallback:(leftBtCallback)leftCallback rightTitle:(NSString *)rightTitle rightBtCallback:(rightBtCallback)rightCallback centerTitle:(NSString *)centerTitle;
{
    self = [super init];
    if (self) {
        self.sourceViewController = sourceViewController;
        self.leftCallback = leftCallback;
        self.rightCallback = rightCallback;
        self.leftTitle = leftTitle;
        self.rightTitle = rightTitle;
        self.centerTitle = centerTitle;
        [self addViewAndLayout];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 64);
    self = [super initWithFrame:frame];
    if (self) {
        [self addViewAndLayout];
    }
    return self;
}

- (void)addViewAndLayout
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 64)];
    [self addSubview:topView];
    
    //
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 80, 44)];
    [topView addSubview:backView];
    UIImage *backImage = [UIImage imageNamed:@"icon_back"];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 30, 44-5)];
    [backImageView  setImage:[backImage imageWithRenderingMode:UIImageRenderingModeAutomatic]];

    [backView addSubview:backImageView];
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 50, 44-5)];
    [self.backButton setTitle:self.leftTitle forState:UIControlStateNormal];
    [self.backButton setTitleColor:LightColor forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.backButton];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 20, 80, 44)];
    [topView addSubview:rightView];
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, 50, 44-5)];
    [self.rightButton setTitle:self.rightTitle forState:UIControlStateNormal];
    [self.rightButton setTitleColor:LightColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.rightButton];
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(80, 20, [UIScreen mainScreen].bounds.size.width - 80*2, 44)];
    [topView addSubview:centerView];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 80*2, 44)];
    [centerView addSubview:self.titleLable];
    self.titleLable.font = Font(18);
    [self.titleLable setText:self.centerTitle];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    
    UIView *bottomInterspace = [[UIView alloc] initWithFrame:CGRectMake(0, 44-0.5f, [UIScreen mainScreen].bounds.size.width, 0.5f)];
    [bottomInterspace setBackgroundColor:HEXCOLOR(0xdddddd)];
    [backView addSubview:bottomInterspace];
}

- (IBAction)back:(id)sender
{
    if (self.leftCallback) {
        self.leftCallback();
    }
    [self.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rightClick:(id)sender
{
    NSLog(@"RIGHT ");
    if (self.rightCallback) {
        self.rightCallback();
    }
}

@end
