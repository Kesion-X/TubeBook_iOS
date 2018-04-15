//
//  InfoDescriptionView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "InfoDescriptionView.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface InfoDescriptionView ()

@property (nonatomic, strong) UIView *spaceV;

@end

@implementation InfoDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
        [self addConstraint];
    }
    return self;
}

- (instancetype)initInfoDescriptionViewWithFrame:(CGRect)frame infoType:(InfoDescriptionType)infoType
{
    self = [self initWithFrame:frame];
    if ( self ) {
        self.infoType = infoType;
//        self.spaceV.frame = frame;
//        self.backImageView.frame = frame;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)addView
{
    [self addSubview:self.backImageView];
    [self addSubview:self.spaceV];
    [self addSubview:self.infoImageView];
    [self addSubview:self.infoDescriptionLable];
    [self addSubview:self.infoTimeLable];
    [self addSubview:self.infoMottoLable];
    [self addSubview:self.infoNameLable];
    [self addSubview:self.infoTitleLable];
}

- (void)addConstraint
{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.spaceV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];

    [self.infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    [self.infoNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoImageView.mas_right).offset(8);
        make.top.equalTo(self);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    [self.infoMottoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoImageView.mas_right).offset(8);
        make.top.equalTo(self.infoNameLable.mas_bottom);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
    }];
    [self.infoTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.top.equalTo(self.infoMottoLable);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    [self.infoTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoImageView.mas_bottom).offset(8);
        make.left.equalTo(self).offset(8);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    if ( self.infoType == InfoDescriptionTypeArticle ) {
        
    } else if ( self.infoType == InfoDescriptionTypeTopic ) {
        [self.infoDescriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoTitleLable.mas_bottom).offset(4);
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.height.mas_equalTo(50);
        }];
    }

}

+ (CGFloat)getViewHeightWithInfotype:(InfoDescriptionType)infoType;
{
    CGFloat height = 0;
    switch (infoType) {
        case InfoDescriptionTypeArticle:
        {
            height = 8 + 50 + 8 + 30 + 4;
            break;
        }
        case InfoDescriptionTypeTopic:
        {
            height = 8 + 50 + 8 + 30 + 4 + 50 +4;
        }
        default:
            break;
    }
    return height;
}

- (void)setSpaceColor:(UIColor *)color
{
    [self.spaceV setBackgroundColor:color];
}

#pragma mark - publilc

- (void)setDetailBackImage:(UIImage *)image
{
    [self.backImageView sd_setImageWithURL:nil placeholderImage:image];
}

- (void)setAllTitleLableWithColor:(UIColor *)color
{
    self.infoTitleLable.textColor = color;
    self.infoMottoLable.textColor = color;
    self.infoDescriptionLable.textColor = color;
    self.infoTimeLable.textColor = color;
    self.infoNameLable.textColor = color;
}


#pragma mark - set

- (void)setInfoName:(NSString *)infoName
{
    [self.infoNameLable setText:infoName];
}

- (void)setInfoTime:(NSString *)infoTime
{
    [self.infoTimeLable setText:infoTime];
}

- (void)setInfomotto:(NSString *)infomotto
{
    [self.infoMottoLable setText:infomotto];
}

- (void)setInfoTitle:(NSString *)infoTitle
{
    [self.infoTitleLable setText:infoTitle];
}

- (void)setInfoDescription:(NSString *)infoDescription
{
    [self.infoDescriptionLable setText:infoDescription];
}

- (void)setInfoImageUrl:(NSString *)infoImageUrl
{
    [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:infoImageUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
}

#pragma  mark - get

- (UIImageView *)infoImageView
{
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc] init];
        _infoImageView.layer.cornerRadius = 5;
        _infoImageView.layer.borderWidth = 0.5;
        _infoImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _infoImageView.layer.masksToBounds = YES;
    }
    return _infoImageView;
}

- (UILabel *)infoNameLable
{
    if (!_infoNameLable) {
        _infoNameLable = [[UILabel alloc] init];
        _infoNameLable.textColor = kTEXTCOLOR;
        _infoNameLable.font = Font(14);
        _infoNameLable.text = @"infoName";
    }
    return _infoNameLable;
}

- (UILabel *)infoMottoLable
{
    if (!_infoMottoLable) {
        _infoMottoLable = [[UILabel alloc] init];
        _infoMottoLable.textColor = HEXCOLOR(0xcdcdcd);
        _infoMottoLable.font = Font(12);
        _infoMottoLable.text = @"infoMotto";
    }
    return _infoMottoLable;
}

- (UILabel *)infoTimeLable
{
    if (!_infoTimeLable) {
        _infoTimeLable = [[UILabel alloc] init];
        _infoTimeLable.textColor = HEXCOLOR(0xcdcdcd);
        _infoTimeLable.font = Font(12);
        _infoTimeLable.text = @"infoTime";
        _infoNameLable.textAlignment = NSTextAlignmentRight;
    }
    return _infoTimeLable;
}

- (UILabel *)infoTitleLable
{
    if (!_infoTitleLable) {
        _infoTitleLable = [[UILabel alloc] init];
        _infoTitleLable.textColor = kTEXTCOLOR;
        _infoTitleLable.font = Font(16);
        _infoTitleLable.text = @"_infoTitle";
    }
    return _infoTitleLable;
}

- (UILabel *)infoDescriptionLable
{
    if (!_infoDescriptionLable) {
        _infoDescriptionLable = [[UILabel alloc] init];
        _infoDescriptionLable.textColor = HEXCOLOR(0xcdcdcd);
        _infoDescriptionLable.font = Font(12);
        _infoDescriptionLable.text = @"_infoDescription";
        _infoDescriptionLable.numberOfLines = 0;
        _infoDescriptionLable.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _infoDescriptionLable;
}

- (UIView *)spaceV
{
    if (!_spaceV) {
        _spaceV = [[UIView alloc] init];
    }
    return _spaceV;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
}

@end
