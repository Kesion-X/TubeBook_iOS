//
//  NewestViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "NewestViewController.h"
#import "UIRefreshTableView.h"
#import "Masonry.h"
#import "UIHomeCellItemHeadView.h"
#import "UIHomeCellItemFootView.h"
#import "UIHomeCellItemContentView.h"

@interface NewestViewController ()

@property(nonatomic, strong)UIRefreshTableView *refreshTableView;

@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewAndConstraint];
    UIHomeCellItemHeadView *v = [[UIHomeCellItemHeadView alloc] init];
    [self.view addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo([v getUIHeight]);
    }];
    
    
    UIHomeCellItemFootView *f = [[UIHomeCellItemFootView alloc] initUIHomeCellItemFootView:nil commentCount:0 likeCount:0];
    [self.view addSubview:f];
    [f mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(45);
        make.height.mas_equalTo([f getUIHeight]);
    }];
    
    UIHomeCellItemContentView *u = [[UIHomeCellItemContentView alloc] initUIHomeCellItemContentView:nil title:nil contentDescription:nil isHaveImage:YES];
    [self.view addSubview:u];
    [u mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(100);
        make.height.mas_equalTo([u getUIHeight]);
    }];
}

- (void)addViewAndConstraint
{
//    [self.view addSubview:self.refreshTableView];
//    [self.refreshTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(self.view);
//    }];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"new appear");
}

#pragma mark - get

- (UIRefreshTableView *)refreshTableView
{
    if (!_refreshTableView) {
        _refreshTableView = [[UIRefreshTableView alloc] init];
    }
    return _refreshTableView;
}


@end
