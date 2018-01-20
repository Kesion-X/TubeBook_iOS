//
//  ReleaseViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "ReleaseViewController.h"

@interface ReleaseViewController ()

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    // Do any additional setup after loading the view.
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(32, 64, 80, 42)];
    [bt setTitle:@"back" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

- (IBAction)click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
