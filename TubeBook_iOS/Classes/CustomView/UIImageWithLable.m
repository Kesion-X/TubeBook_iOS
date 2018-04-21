//
//  UIImageWithLable.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/18.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIImageWithLable.h"
#import "Masonry.h"
#import "CKMacros.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#define kUIImageWithLableWith
//#define kUIImageWithLableHeight

@implementation UIImageWithLable

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initUIImageWithLableWithWidth:(CGFloat)width height:(CGFloat)height
{
    self = [self initWithFrame:CGRectMake(0, 0, width, height)];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load
{
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLable];
    [self addSubview:self.countLable];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18);
        make.right.equalTo(self).offset(-18);
        make.top.equalTo(self).offset(18);
        make.bottom.equalTo(self).mas_equalTo(-(kIconMarginBottom+18));
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-8);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kIconMarginBottom);
    }];
    [self.countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLable.text = title;
}

- (void)setCountNotReview:(NSInteger)countNotReview
{
    _countNotReview = countNotReview;
    if ( countNotReview==0 ) {
        self.countLable.hidden = YES;
    } else {
        self.countLable.hidden = NO;
        self.countLable.text = [NSString stringWithFormat:@"%lu",countNotReview];
    }
}

- (void)setIconUrl:(NSString *)iconUrl
{
    _iconUrl = iconUrl;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
}

- (void)setIconByImageName:(NSString *)imageName
{
    [self.iconImageView setImage:[UIImage imageNamed:imageName]];
}

#pragma mark - get
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = kTEXTCOLOR;
        _titleLable.font = Font(14);
        _titleLable.text = @"title";
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UILabel *)countLable
{
    if (!_countLable) {
        _countLable = [[UILabel alloc] init];
        _countLable.textColor = HEXCOLOR(0xffffff);
        _countLable.font = Font(9);
        _countLable.layer.cornerRadius = 9;
        _countLable.layer.borderWidth = 0.5;
        _countLable.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _countLable.layer.masksToBounds = YES;
        _countLable.backgroundColor = HEXCOLOR(0xff6b6b);//红
        _countLable.text = @"0";
        _countLable.textAlignment = NSTextAlignmentCenter;
        _countLable.hidden = YES;
    }
    return _countLable;
}

@end
