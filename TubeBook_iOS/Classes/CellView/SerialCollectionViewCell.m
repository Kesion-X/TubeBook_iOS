//
//  SerialCollectionViewCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/27.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "SerialCollectionViewCell.h"
#import "Masonry.h"
#import "CKMacros.h"
#import "NSString+StringKit.h"
#define colMargin 16

@implementation SerialCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        self.layer.masksToBounds = YES;
        [self addViewAndConstraints];
    }
    return self;
}

- (void)addViewAndConstraints{
    [self.contentView addSubview:self.serialImageView];
    [self.contentView addSubview:self.serialTitleLable];
    [self.contentView addSubview:self.userTitleLable];
    [self.contentView addSubview:self.userImageView];
    
    [self.serialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(200);
    }];
    UIView *v = [[UIView alloc] init];
    [self.contentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.serialImageView);
        make.height.mas_equalTo(80);
    }];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = v.bounds;
    gradient.startPoint = CGPointMake(0, 1);
    gradient.endPoint = CGPointMake(0, 0);
    gradient.colors = [NSArray arrayWithObjects:
                       (id)HEXACOLOR(0x000000, 0.3).CGColor,
                        (id)HEXACOLOR(0x000000, 0.1).CGColor,
                       (id)HEXACOLOR(0x000000, 0.05), nil];
    [v.layer addSublayer:gradient];
    [v addSubview:self.serialDescriptionLable];
    [self.serialDescriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v).offset(4);
        make.right.equalTo(v).offset(-4);
        make.bottom.equalTo(v).offset(-4);
        make.height.mas_equalTo(16);
    }];
    [self.serialTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serialImageView.mas_bottom);
        make.left.equalTo(self.contentView).offset(4);
        make.right.equalTo(self.contentView).offset(-4);
    }];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serialTitleLable.mas_bottom).offset(4);
        make.left.equalTo(self.contentView).offset(4);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    [self.userTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(4);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.userImageView);
    }];

}

- (CGFloat)getCellHeight
{
    return 200+16+8+[NSString getSizeWithAttributes:self.serialTitle font:self.serialTitleLable.font].height+20;
}
+ (CGFloat)getCellHeight:(CKContent *)content
{
    return 200+16+8+[NSString getSizeWithAttributes:content.serialTitle width:([UIScreen mainScreen].bounds.size.width-3*colMargin)/2 font:Font(14)].height;
}

#pragma mark - get
- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.layer.cornerRadius = 8;
        _userImageView.layer.borderWidth = 0.5;
        _userImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
    }
    return _userImageView;
}

- (UILabel *)userTitleLable
{
    if (!_userTitleLable) {
        _userTitleLable = [[UILabel alloc] init];
        _userTitleLable.textColor = kTAB_TEXT_COLOR;
        _userTitleLable.font = Font(9);
        _userTitleLable.text = @"title";
    }
    return _userTitleLable;
}

- (UIImageView *)serialImageView
{
    if (!_serialImageView) {
        _serialImageView = [[UIImageView alloc] init];
        [_serialImageView setBackgroundColor:kTAB_TEXT_COLOR];
    }
    return _serialImageView;
}

- (UILabel *)serialTitleLable
{
    if (!_serialTitleLable) {
        _serialTitleLable = [[UILabel alloc] init];
        _serialTitleLable.textColor = kTEXTCOLOR;
        _serialTitleLable.font = Font(14);
        _serialTitleLable.text = @"title";
    }
    return _serialTitleLable;
}

- (UILabel *)serialDescriptionLable
{
    if (!_serialDescriptionLable) {
        _serialDescriptionLable = [[UILabel alloc] init];
        _serialDescriptionLable.textColor = HEXCOLOR(0xffffff);
        _serialDescriptionLable.font = Font(10);
        _serialDescriptionLable.text = @"serialDescription";
    }
    return _serialDescriptionLable;
}
@end
