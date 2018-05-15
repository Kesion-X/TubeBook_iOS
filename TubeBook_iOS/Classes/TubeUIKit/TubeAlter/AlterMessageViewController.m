//
//  AlterMessageViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AlterMessageViewController.h"
#import "CKMacros.h"
#import "CKCenterView.h"



@interface AlterMessageViewController ()

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) CKMessageCenterView *messageCenterView;
@end

@implementation AlterMessageViewController

- (instancetype)initAlterMessageViewControllerWithMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        self.message = message;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageCenterView = [[CKMessageCenterView alloc] initCKMessageCenterViewWithMessage:self.message frame:CGRectMake(0, SCREEN_HEIGHT, 0, 0)];
    [self.view addSubview:self.messageCenterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
  //  self.view.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, SCREEN_HEIGHT);
    CGRect frame = self.messageCenterView.frame;
    self.messageCenterView.frame = CGRectMake( -10, frame.origin.y-80, SCREEN_WIDTH+20, frame.size.height+160);
    //self.messageCenterView.frame = CGRectMake( SCREEN_WIDTH/2, SCREEN_HEIGHT/2 , 0, 0);
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.1f animations:^{
      //  [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]];
        self.messageCenterView.frame = frame;
    //    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view layoutIfNeeded];
    }];
}

@end
