//
//  DetailSerialArticleTableViewCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DetailSerialArticleTableViewCell.h"
#import "DetailSerialArticleContent.h"
#import "CKMacros.h"
#import "Masonry.h"

@implementation DetailSerialArticleTableViewCell

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
    [self.contentView addSubview:self.articleTitleLable];
    [self.contentView addSubview:self.articleTimeLable];
    
    [self.articleTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.contentView).offset (8);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.articleTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kCELL_MARGIN);
        make.bottom.equalTo(self.contentView).offset(-8);
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
    DetailSerialArticleContent *taContent = (DetailSerialArticleContent *)content;
    self.articleTitle = taContent.articleTitle;
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


#pragma mark - get

- (UILabel *)articleTitleLable
{
    if (!_articleTitleLable) {
        _articleTitleLable = [[UILabel alloc] init];
        _articleTitleLable.textColor = kTEXTCOLOR;
        _articleTitleLable.font = Font(16);
        _articleTitleLable.text = @"title";
    }
    return _articleTitleLable;
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
