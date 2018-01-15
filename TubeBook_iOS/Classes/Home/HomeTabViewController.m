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

@interface HomeTabViewController ()

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
     self.navigationItem.titleView = [TubeNavigationUITool itemTitleWithLableTitle:@"主页" titleColoe:kTUBEBOOK_THEME_NORMAL_COLOR];
    // Do any additional setup after loading the view.
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(32, 64, 80, 42)];
    [bt setTitle:@"主页" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.titleView = [TubeNavigationUITool itemTitleWithLableTitle:@"主页" titleColoe:kTUBEBOOK_THEME_NORMAL_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
