//
//  NewestViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "NewestViewController.h"

@interface NewestViewController ()

@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    NSLog(@"new load");
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"new appear");
}

@end
