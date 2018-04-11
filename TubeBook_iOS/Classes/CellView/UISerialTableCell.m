//
//  UISerialTableCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UISerialTableCell.h"
#import "CKMacros.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UISerialTableCell

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
    [self.contentView addSubview:self.serialImageView];
    [self.contentView addSubview:self.serialTitleLable];
    [self.contentView addSubview:self.serialDescriptionLable];
    [self.contentView addSubview:self.serialRightImageView];
    
    [self.serialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kCELL_MARGIN);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(54);
    }];
    [self.serialTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serialImageView.mas_right).offset(16);
        make.top.equalTo(self.serialImageView);
    }];
    [self.serialRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kCELL_MARGIN);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [self.serialDescriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serialImageView.mas_right).offset(16);
        make.top.equalTo(self.serialTitleLable.mas_bottom).offset(8);
        make.right.equalTo(self.serialRightImageView.mas_left).offset(-32);
    }];
    UIView *spaceportBottom = [[UIView alloc] init];
    [self.contentView addSubview:spaceportBottom];
    [spaceportBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-0.5);
        make.left.equalTo(self.serialDescriptionLable);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [spaceportBottom setBackgroundColor:kTAB_TEXT_COLOR];
}

- (CGFloat)getCellHeight
{
    return 70;
}

+ (CGFloat)getCellHeight:(CKContent *)content
{
    return 70;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - set

- (void)setContent:(CKContent *)content
{
    SerialTagContent *serialContent = (SerialTagContent *)content;
    if (serialContent) {
        self.serialTitleLable.text = serialContent.serialTitle;
        self.serialDescriptionLable.text = serialContent.serialDescription;
        [self.serialImageView sd_setImageWithURL:[NSURL URLWithString:serialContent.serialImageUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
    }
}

#pragma mark - get
- (UIImageView *)serialImageView
{
    if (!_serialImageView) {
        _serialImageView = [[UIImageView alloc] init];
        _serialImageView.layer.cornerRadius = 4;
        _serialImageView.layer.borderWidth = 0.5;
        _serialImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
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
        _serialDescriptionLable.textColor = HEXCOLOR(0xcdcdcd);
        _serialDescriptionLable.font = Font(12);
        _serialDescriptionLable.text = @"serialDescription";
    }
    return _serialDescriptionLable;
}

- (UIImageView *)serialRightImageView
{
    if (!_serialRightImageView) {
        _serialRightImageView = [[UIImageView alloc] init];
        _serialRightImageView.image = [UIImage imageNamed:@"icon_right"];
    }
    return _serialRightImageView;
}

@end
