//
//  HomeTabViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "HomeTabViewController.h"
#import "TubeNavigationUITool.h"
#import "CKMacros.h"
#import "UIIndicatorView.h"
#import "Masonry.h"
#import "UINavigationBar+CustomHeight.h"
#import "UITubeSearchView.h"
#import "UITubeNavigationView.h"

@interface HomeTabViewController ()

@property (nonatomic, strong) UIIndicatorView *indicatorView;

@end

@implementation HomeTabViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
       // self.tabBarItem = [UITabBarItem alloc] initWithTitle:@"主页" image:<#(nullable UIImage *)#> selectedImage:<#(nullable UIImage *)#>
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigation];
    UITubeNavigationView *tubeNavigationView = [[UITubeNavigationView alloc] init];
    [self.view addSubview:tubeNavigationView];
    [tubeNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo([tubeNavigationView.searchView getUITubeSearchViewHeight]+[tubeNavigationView.indicatorView getUIHeight]+12);
    }];
//[tubeNavigationView setBackgroundColor:[UIColor blueColor]];
//     self.navigationItem.titleView = [TubeNavigationUITool itemTitleWithLableTitle:@"主页" titleColoe:kTUBEBOOK_THEME_NORMAL_COLOR];
//    // Do any additional setup after loading the view.
//    UIButton *bt = [[UIButton alloc] init];
//    [bt setTitle:@"主页" forState:UIControlStateNormal];
//    [bt setBackgroundColor:[UIColor blueColor]];
//    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
//    attrDict[NSFontAttributeName] = bt.titleLabel.font;
//    //attrDict[NSFontAttributeName] = self.bt
//    bt.frame = CGRectMake(60, 72, [@"主页" sizeWithAttributes:attrDict].width+8*2, [@"主页" sizeWithAttributes:attrDict].height+4*2);
//    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bt];
//
//
//    _indicatorView = [[UIIndicatorView alloc] initUIIndicatorView:[UIColor blueColor] font:Font(14)];
//    [self.view addSubview:_indicatorView];
//    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(0);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.height.mas_equalTo([_indicatorView getUIHeight]);
//    }];
//   // [_indicatorView setBackgroundColor:[UIColor grayColor]];
//     [_indicatorView addIndicatorItemByString:@"konA"];
//     [_indicatorView addIndicatorItemByString:@"kesionWEWE"];
//     [_indicatorView addIndicatorItemByString:@"konEQWW"];
//     [_indicatorView addIndicatorItemByString:@"kesion"];
//    [_indicatorView addIndicatorItemByString:@"kesionWEWE"];
//    [_indicatorView addIndicatorItemByString:@"koEQEEQEQWW"];
//    [_indicatorView addIndicatorItemByString:@"kesion"];
//    [_indicatorView addIndicatorItemByString:@"konA"];
//    [_indicatorView addIndicatorItemByString:@"kesionWEWE"];
//
//    UITubeSearchView *searchView = [[UITubeSearchView alloc] initUITubeSearchView:@"在Tube上搜索你喜欢的内容吧"];
//    [self.view addSubview:searchView];
//    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@300);
//        make.left.equalTo(@64);
//        make.right.equalTo(@-32);
//        make.height.equalTo(@28);
//    }];
//    [searchView setNeedsLayout];
//    [searchView layoutIfNeeded];
//    NSLog(@"%f",searchView.bounds.size.height);
//    searchView.layer.cornerRadius = searchView.bounds.size.height/2;
}

- (IBAction)click:(id)sender
{
//    [_indicatorView addIndicatorItemByString:@"kesDWDWion"];
}

- (void)configNavigation
{
    if (!self.navigationController.navigationBar.isHidden) {
       // [self.tabBarController.navigationController setNavigationBarHidden:YES animated:YES];
         self.navigationController.navigationBar.hidden = YES;
    }
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configNavigation];
//    if (self.navigationController.navigationBar.isHidden) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
//
//    self.tabBarController.navigationItem.titleView = [TubeNavigationUITool itemTitleWithLableTitle:@"主页" titleColoe:kTUBEBOOK_THEME_NORMAL_COLOR];
//    NSLog(@"%@",self.navigationItem);

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}



@end
