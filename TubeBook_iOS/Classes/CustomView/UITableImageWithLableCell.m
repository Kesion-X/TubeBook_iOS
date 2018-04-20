//
//  UITableImageWithLableCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UITableImageWithLableCell.h"
#import "Masonry.h"

@implementation UITableImageWithLableCell

- (instancetype)initUITableImageWithLableCellWithFrame:(CGRect)frame title:(NSString *)title iconName:(NSString *)iconName
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.title = title;
        self.iconName= iconName;
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    [self addSubview:self.titleIconImageView];
    [self addSubview:self.titleLable];
    self.titleLable.text = self.title;
    self.titleIconImageView.image = [UIImage imageNamed:self.iconName];
    [self.titleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(self.frame.size.height - 8*2);
        make.height.mas_equalTo(self.frame.size.height - 8*2);
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleIconImageView.mas_right).offset(8);
        make.centerY.equalTo(self);
    }];
    UIImageView *gotoIcon = [[UIImageView alloc] init];
    gotoIcon.image = [UIImage imageNamed:@"icon_goto"];
    [self addSubview:gotoIcon];
    [gotoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
}

#pragma mark - get
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
    }
    return _titleLable;
}

- (UIImageView *)titleIconImageView
{
    if (!_titleIconImageView) {
        _titleIconImageView = [[UIImageView alloc] init];
    }
    return _titleIconImageView;
}

@end
