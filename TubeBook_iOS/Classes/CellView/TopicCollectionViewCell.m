//
//  TopicCollectionViewCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TopicCollectionViewCell.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "DescoverTopicContent.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TopicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViewConstraints];
    }
    return self;
}

- (void)addViewConstraints
{
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.topicImageView];
    [self.contentView addSubview:self.countAttentLable];
    [self.topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-40);
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicImageView.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setContent:(CKContent *)content
{
    self.title = content.topicTitle;
    self.topicImageUrl = content.topicImageUrl;
    self.countAttent = [NSString stringWithFormat:@"%lu",content.likeCount];
}

- (void)setTitle:(NSString *)title
{
    [self.titleLable setText:title];
}

- (void)setTopicImageUrl:(NSString *)topicImageUrl
{
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:topicImageUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
}



#pragma mark - get

- (UIImageView *)topicImageView
{
    if (!_topicImageView) {
        _topicImageView = [[UIImageView alloc] init];
        _topicImageView.layer.cornerRadius = 8;
        _topicImageView.layer.borderWidth = 0.5;
        _topicImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _topicImageView.layer.masksToBounds = YES;
    }
    return _topicImageView;
}

- (UILabel *)countAttentLable
{
    if (!_countAttentLable) {
        _countAttentLable = [[UILabel alloc] init];
        _countAttentLable.textColor = HEXCOLOR(0xffffff);
        _countAttentLable.font = Font(10);
        _countAttentLable.text = @"serialDescription";
    }
    return _countAttentLable;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = kTEXTCOLOR;
        _titleLable.font = Font(16);
        _titleLable.text = @"title";
        _titleLable.numberOfLines = 0;
        _titleLable.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _titleLable;
}
@end
