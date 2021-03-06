//
//  UIHomeCellTopicOrSerialView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIHomeCellTopicOrSerialView.h"
#import "CKMacros.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIHomeCellTopicOrSerialView

- (instancetype)initUIHomeCellTopicOrSerialView:(ArticleKind)kind
{
    self = [super init];
    if (self) {
        self.kind = kind;
        [self config];
        [self addViewAndConstraints];
    }
    return self;
}

- (void)config
{
    self.layer.cornerRadius = 3;
    self.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = YES;
}

- (void)addViewAndConstraints
{
    if (self.kind == TopicArticle) {
        self.kindView = [[UITagView alloc] initUITagView:@"专题" color:kTAG_COLOR];
    } else {
        self.kindView = [[UITagView alloc] initUITagView:@"连载" color:kTAG_COLOR];
    }
    [self addSubview:self.tagImageView];
    [self addSubview:self.titleLable];
    [self addSubview:self.articleDetailLable];
    [self addSubview:self.kindView];
    if (self.kind == TopicArticle) {
        [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self).offset(8);
            make.height.mas_equalTo(48);
            make.width.mas_equalTo(48);
        }];
    }else{
        [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self).offset(8);
            make.height.mas_equalTo(48);
            make.width.mas_equalTo(32);
        }];
    }
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagImageView.mas_right).offset(8);
        make.top.equalTo(self).offset(12);
    }];
    [self.articleDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagImageView.mas_right).offset(8);
        make.top.equalTo(self.titleLable.mas_bottom).offset(4);
    }];
    [self.kindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-8);
        make.width.mas_equalTo([self.kindView getUIWidht]);
        make.height.mas_equalTo([self.kindView getUIHeight]);
    }];
    

}

- (CGFloat)getUIHeight
{
    return 64;
}
+ (CGFloat)getUIHeight:(ArticleKind)kind
{
    return 64;
}

- (void)setDataWithTitle:(NSString *)title tagImageUrl:(NSString *)tagImageUrl detail:(NSString *)detail;
{
    self.title = title;
    self.tagImageUrl = tagImageUrl;
    self.detail = detail;
}

- (void)setDetail:(NSString *)detail
{
    [self.articleDetailLable setText:detail];
}

- (void)setTitle:(NSString *)title
{
    [self.titleLable setText:title];
}

- (void)setTagImageUrl:(NSString *)tagImageUrl
{
    [self.tagImageView sd_setImageWithURL:[NSURL URLWithString:tagImageUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
}

#pragma mark - get
- (UIImageView *)tagImageView
{
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.backgroundColor = kTAB_TEXT_COLOR;
    }
    return _tagImageView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = Font(12);
        _titleLable.textColor = kTEXTCOLOR;
        _titleLable.text = @"title";
    }
    return _titleLable;
}

- (UILabel *)articleDetailLable
{
    if (!_articleDetailLable) {
        _articleDetailLable = [[UILabel alloc] init];
        _articleDetailLable.font = Font(10);
        _articleDetailLable.textColor = HEXCOLOR(0x8492A6);
        _articleDetailLable.text = @"articleTagLable";
    }
    return _articleDetailLable;
}



@end
