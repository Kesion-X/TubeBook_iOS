//
//  DetailTopicArticleTableViewCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DetailTopicArticleTableViewCell.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "DetailTopicArticleContent.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DetailTopicArticleTableViewCell

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
    [self.contentView addSubview:self.articleImageView];
    [self.contentView addSubview:self.articleTitleLable];
    [self.contentView addSubview:self.articleUserNameLable];
    [self.contentView addSubview:self.articleTimeLable];
    
    [self.articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kCELL_MARGIN);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
    }];
    [self.articleTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.articleImageView.mas_right).offset(16);
        make.top.equalTo(self.articleImageView);
        make.width.mas_equalTo(200);
    }];
    [self.articleTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kCELL_MARGIN);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.height.mas_equalTo(24);
    }];
    [self.articleUserNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.articleImageView.mas_right).offset(16);
        make.top.equalTo(self.articleTitleLable.mas_bottom).offset(8);

    }];
    UIView *spaceportBottom = [[UIView alloc] init];
    [self.contentView addSubview:spaceportBottom];
    [spaceportBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-0.5);
        make.left.equalTo(self.contentView);
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
    [super setContent:content];
    DetailTopicArticleContent *taContent = (DetailTopicArticleContent *)content;
    self.articleImageUrl = taContent.articlePic;
    self.articleTitle = taContent.articleTitle;
    self.articleUserName = taContent.userName;
    self.articleTime = taContent.time;
}

- (void)setArticleTime:(NSString *)articleTime
{
    [self.articleTimeLable setText:articleTime];
}

- (void)setArticleTitle:(NSString *)articleTitle
{
    [self.articleTitleLable setText:articleTitle];
}

- (void)setArticleUserName:(NSString *)articleUserName
{
    [self.articleUserNameLable setText:articleUserName];
}

- (void)setArticleImageUrl:(NSString *)articleImageUrl
{
    [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:articleImageUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
}

#pragma mark - get
- (UIImageView *)articleImageView
{
    if (!_articleImageView) {
        _articleImageView = [[UIImageView alloc] init];
        _articleImageView.layer.cornerRadius = 4;
        _articleImageView.layer.borderWidth = 0.5;
        _articleImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
    }
    return _articleImageView;
}

- (UILabel *)articleTitleLable
{
    if (!_articleTitleLable) {
        _articleTitleLable = [[UILabel alloc] init];
        _articleTitleLable.textColor = kTEXTCOLOR;
        _articleTitleLable.font = Font(14);
        _articleTitleLable.text = @"title";
    }
    return _articleTitleLable;
}

- (UILabel *)articleUserNameLable
{
    if (!_articleUserNameLable) {
        _articleUserNameLable = [[UILabel alloc] init];
        _articleUserNameLable.textColor = HEXCOLOR(0xcdcdcd);
        _articleUserNameLable.font = Font(12);
        _articleUserNameLable.text = @"articleUserNameLable";
    }
    return _articleUserNameLable;
}

- (UILabel *)articleTimeLable
{
    if (!_articleTimeLable) {
        _articleTimeLable = [[UILabel alloc] init];
        _articleTimeLable.textColor = HEXCOLOR(0xcdcdcd);
        _articleTimeLable.font = Font(12);
        _articleTimeLable.text = @"articleTimeLable";
        _articleTimeLable.textAlignment = NSTextAlignmentRight;
    }
    return _articleTimeLable;
}

@end
