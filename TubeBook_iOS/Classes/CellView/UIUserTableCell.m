//
//  UIUserTableCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIUserTableCell.h"
#import "CKMacros.h"
#import "Masonry.h"

@implementation UIUserTableCell


- (instancetype)initWithDateType:(CKDataType *)type
{
    self = [super initWithDateType:type];
    if (self) {
        [self addViewAndConstraint];
    }
    return self;
}

- (void)addViewAndConstraint
{
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.userTitleLable];
    [self.contentView addSubview:self.userDescriptionLable];
    [self.contentView addSubview:self.userRightImageView];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kCELL_MARGIN);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
    }];
    [self.userTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(16);
        make.top.equalTo(self.userImageView);
    }];
    [self.userRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kCELL_MARGIN);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [self.userDescriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(16);
        make.top.equalTo(self.userTitleLable.mas_bottom).offset(8);
        make.right.equalTo(self.userRightImageView.mas_left).offset(-32);
    }];
    UIView *spaceportBottom = [[UIView alloc] init];
    [self.contentView addSubview:spaceportBottom];
    [spaceportBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-0.5);
        make.left.equalTo(self.userTitleLable);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [spaceportBottom setBackgroundColor:kTAB_TEXT_COLOR];
}

- (CGFloat)getCellHeight
{
    return 62;
}

+ (CGFloat)getCellHeight:(CKContent *)content
{
    return 62;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - get
- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.layer.cornerRadius = 24;
        _userImageView.layer.borderWidth = 0.5;
        _userImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
    }
    return _userImageView;
}

- (UILabel *)userTitleLable
{
    if (!_userTitleLable) {
        _userTitleLable = [[UILabel alloc] init];
        _userTitleLable.textColor = kTEXTCOLOR;
        _userTitleLable.font = Font(14);
        _userTitleLable.text = @"title";
    }
    return _userTitleLable;
}

- (UILabel *)userDescriptionLable
{
    if (!_userDescriptionLable) {
        _userDescriptionLable = [[UILabel alloc] init];
        _userDescriptionLable.textColor = HEXCOLOR(0xcdcdcd);
        _userDescriptionLable.font = Font(12);
        _userDescriptionLable.text = @"userDescription";
    }
    return _userDescriptionLable;
}

- (UIImageView *)userRightImageView
{
    if (!_userRightImageView) {
        _userRightImageView = [[UIImageView alloc] init];
        _userRightImageView.image = [UIImage imageNamed:@"icon_right"];
    }
    return _userRightImageView;
}


@end
