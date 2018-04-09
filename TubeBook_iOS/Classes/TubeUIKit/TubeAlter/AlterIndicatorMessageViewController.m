//
//  AlterIndicatorMessageViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AlterIndicatorMessageViewController.h"

@interface AlterIndicatorMessageViewController ()

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) CKCenterView *centerView;

@end

@implementation AlterIndicatorMessageViewController

- (instancetype)initAlterIndicatorMessageViewControllerWithMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f]];
    self.centerView = [[CKIndicatorMessageCenterView alloc] initIndicatorMessageCenterViewWithMessage:self.message];
    [self.view addSubview:self.centerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    //  self.view.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT);
    CGRect frame = self.centerView.frame;
    self.centerView.frame = CGRectMake( -10, frame.origin.y-80, SCREEN_WIDTH+20, frame.size.height+160);
    //self.messageCenterView.frame = CGRectMake( SCREEN_WIDTH/2, SCREEN_HEIGHT/2 , 0, 0);
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.1f animations:^{
        //  [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]];
        self.centerView.frame = frame;
        //    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view layoutIfNeeded];
    }];
}


@end
