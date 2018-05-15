//
//  AlterNotificationViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AlterNotificationViewController.h"
#import "Masonry.h"
#import "CKMacros.h"

@interface AlterNotificationViewController ()

@property (nonatomic, strong) UIView *spaceView;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *contentLable;

@end

@implementation AlterNotificationViewController

- (instancetype)initAlterNotificationViewControllerWithContentTitle:(NSString *)contentTitle content:(NSString *)content time:(NSString *)time
{
    self = [super init];
    if (self) {
        self.contentTitle = contentTitle;
        self.content = content;
        self.time = time;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.spaceView];
//    [self.spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_top);
//        make.left.equalTo(self.view).offset(8);
//        make.right.equalTo(self.view).offset(-8);
//        make.height.mas_equalTo(100);
//    }];
    [self.spaceView addSubview:self.titleLable];
    [self.spaceView addSubview:self.timeLable];
    [self.spaceView addSubview:self.contentLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spaceView).offset(16);
        make.top.equalTo(self.spaceView).offset(8);
    }];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.spaceView).offset(8);
        make.right.equalTo(self.spaceView).offset(-16);
    }];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spaceView).offset(16);
        make.top.equalTo(self.titleLable.mas_bottom).offset(8);
    }];
    self.titleLable.text = self.contentTitle;
    self.timeLable.text = self.time;
    self.contentLable.text = self.content;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s ",__func__);
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2f animations:^{
        self.spaceView.frame = CGRectMake(8, -100, SCREEN_WIDTH - 8*2 , 100);
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2f animations:^{
        self.spaceView.frame = CGRectMake(8, 8, SCREEN_WIDTH - 8*2 , 100);
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - get
- (UIView *)spaceView
{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] initWithFrame:CGRectMake(8, -100, SCREEN_WIDTH - 8*2 , 100)];
        _spaceView.layer.cornerRadius = 20;
        _spaceView.layer.masksToBounds = YES;
        _spaceView.backgroundColor = HEXACOLOR(0xdfdfdf, 0.8);
    }
    return _spaceView;
}

- (UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.textAlignment = NSTextAlignmentRight;
        _timeLable.font = Font(12);
    }
    return _timeLable;
}

- (UILabel *)contentLable
{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc] init];
    }
    return _contentLable;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = FontBold(14);
    }
    return _titleLable;
}

@end
