//
//  UITopicTableCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UITopicTableCell.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "TopicTagContent.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UITopicTableCell

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
    [self.contentView addSubview:self.topicImageView];
    [self.contentView addSubview:self.topicTitleLable];
    [self.contentView addSubview:self.topicDescriptionLable];
    [self.contentView addSubview:self.topicRightImageView];
    
    [self.topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kCELL_MARGIN);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
    }];
    [self.topicTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topicImageView.mas_right).offset(16);
        make.top.equalTo(self.topicImageView);
        make.width.mas_equalTo(200);
    }];
    [self.topicRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kCELL_MARGIN);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [self.topicDescriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topicImageView.mas_right).offset(16);
        make.top.equalTo(self.topicTitleLable.mas_bottom).offset(8);
        make.right.equalTo(self.topicRightImageView.mas_left).offset(-32);
    }];
    UIView *spaceportBottom = [[UIView alloc] init];
    [self.contentView addSubview:spaceportBottom];
    [spaceportBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-0.5);
        make.left.equalTo(self.topicTitleLable);
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

#pragma mark - set

- (void)setContent:(CKContent *)content
{
    TopicTagContent *topicContent = (TopicTagContent *)content;
    if (topicContent) {
        self.topicTitleLable.text = topicContent.topicTitle;
        self.topicDescriptionLable.text = topicContent.topicDescription;
        [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:topicContent.topicImageUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
    }
}

#pragma mark - get
- (UIImageView *)topicImageView
{
    if (!_topicImageView) {
        _topicImageView = [[UIImageView alloc] init];
        _topicImageView.layer.cornerRadius = 4;
        _topicImageView.layer.borderWidth = 0.5;
        _topicImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
    }
    return _topicImageView;
}

- (UILabel *)topicTitleLable
{
    if (!_topicTitleLable) {
        _topicTitleLable = [[UILabel alloc] init];
        _topicTitleLable.textColor = kTEXTCOLOR;
        _topicTitleLable.font = Font(14);
        _topicTitleLable.text = @"title";
    }
    return _topicTitleLable;
}

- (UILabel *)topicDescriptionLable
{
    if (!_topicDescriptionLable) {
        _topicDescriptionLable = [[UILabel alloc] init];
        _topicDescriptionLable.textColor = HEXCOLOR(0xcdcdcd);
        _topicDescriptionLable.font = Font(12);
        _topicDescriptionLable.text = @"topicDescription";
    }
    return _topicDescriptionLable;
}

- (UIImageView *)topicRightImageView
{
    if (!_topicRightImageView) {
        _topicRightImageView = [[UIImageView alloc] init];
        _topicRightImageView.image = [UIImage imageNamed:@"icon_right"];
    }
    return _topicRightImageView;
}

@end
