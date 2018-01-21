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

@interface NewestViewController ()

@property(nonatomic, strong)UIRefreshTableView *refreshTableView;

@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewAndConstraint];
}

- (void)addViewAndConstraint
{
    [self.view addSubview:self.refreshTableView];
    [self.refreshTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
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
