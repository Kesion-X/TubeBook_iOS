//
//  AlterBaseViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AlterBaseViewController.h"

@interface AlterBaseViewController ()

@end

@implementation AlterBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
}

@end
