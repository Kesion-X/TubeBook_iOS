//
//  UIHomeCellItemFootView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIHomeCellItemFootView.h"
#import "CKMacros.h"
#import "Masonry.h"
#define ICOM_SIZE 18

@implementation UIHomeCellItemFootView

- (instancetype)initUIHomeCellItemFootView:(UserState)userState
{
    self = [super init];
    if (self) {
        self.userState = userState;
        self.footCellStyle = UIFootCellNormalStyle;
        [self addViewAndConstraint];
    }
    return self;
}

- (instancetype)initUIHomeCellItemFootView:(UserState)userState footCellStyle:(UIFootCellStyle)footCellStyle
{
    self = [super init];
    if (self) {
        self.userState = userState;
        self.footCellStyle = footCellStyle;
        [self addViewAndConstraint];
    }
    return self;
}

- (instancetype)initUIHomeCellItemFootView:(NSString *)pulibshUserName commentCount:(NSUInteger)commentCount likeCount:(NSUInteger)likeCount
{
    self = [super init];
    if (self) {
        self.pulibshUserName = pulibshUserName;
        self.commentCount = commentCount;
        self.likeCount = likeCount;
        self.footCellStyle = UIFootCellNormalStyle;
        [self addViewAndConstraint];
    }
    return self;
}

- (instancetype)initUIHomeCellItemFootView:(NSString *)tagName
                              commentCount:(NSUInteger)commentCount
                                 likeCount:(NSUInteger)likeCount
                             footCellStyle:(UIFootCellStyle)footCellStyle;
{
    self = [super init];
    if (self) {
        self.tagName = tagName;
        self.commentCount = commentCount;
        self.likeCount = likeCount;
        self.footCellStyle = footCellStyle;
        [self addViewAndConstraint];
    }
    return self;
}

- (void)addViewAndConstraint
{
    if (self.footCellStyle == UIFootCellNormalStyle) {
        if (self.userState == UserLikeArticle) {
            [self addSubview:self.pulibshUserNameLable];
            [self addSubview:self.commentCountLable];
            [self addSubview:self.likeCountLable];
            UILabel *commitL = [[UILabel alloc] init];
            commitL.textColor = HEXCOLOR(0xCDCDCD);
            commitL.font = Font(14);
            commitL.text = @"评论";
            UILabel *likeL = [[UILabel alloc] init];
            likeL.textColor = HEXCOLOR(0xCDCDCD);
            likeL.font = Font(14);
            likeL.text = @"喜欢";
            UIView *v = [[UIView alloc] init];
            v.layer.cornerRadius = 2;
            v.layer.masksToBounds = YES;
            [v setBackgroundColor:HEXCOLOR(0xf5f5f5)];
            [self addSubview:commitL];
            [self addSubview:likeL];
            [self addSubview:v];
            
            [self.pulibshUserNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kCELL_MARGIN);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
            [likeL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kCELL_MARGIN);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
            [self.likeCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(likeL.mas_left).offset(-4);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.likeCountLable.mas_left).offset(-4);
                make.centerY.equalTo(self);
                make.width.mas_equalTo(4);
                make.height.mas_equalTo(4);
            }];
            [commitL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(v.mas_left).offset(-4);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
            [self.commentCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(commitL.mas_left).offset(-4);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
        } else {
            [self addSubview:self.commentCountLable];
            [self addSubview:self.likeCountLable];
            UILabel *shareL = [[UILabel alloc] init];
            shareL.textColor = HEXCOLOR(0xCDCDCD);
            shareL.font = Font(14);
            shareL.text = @"分享";
            UIImageView *shareI = [[UIImageView alloc] init];
            [shareI setImage:[UIImage imageNamed:@"icon_share"]];
            UIImageView *likeI = [[UIImageView alloc] init];
            [likeI setImage:[UIImage imageNamed:@"icon_like"]];
            UIImageView *commentI = [[UIImageView alloc] init];
            [commentI setImage:[UIImage imageNamed:@"icon_comment"]];
            [self addSubview:shareL];
            [self addSubview:shareI];
            [self addSubview:likeI];
            [self addSubview:commentI];
            
            [shareL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kCELL_MARGIN);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
            [shareI mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(shareL.mas_left).offset(-4);
                make.width.mas_equalTo(ICOM_SIZE);
                make.height.mas_equalTo(ICOM_SIZE);
                make.centerY.equalTo(self);
            }];
            [self.likeCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(shareI.mas_left).offset(-4);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
            [likeI mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.likeCountLable.mas_left).offset(-4);
                make.width.mas_equalTo(ICOM_SIZE);
                make.height.mas_equalTo(ICOM_SIZE);
                make.centerY.equalTo(self);
            }];
            [self.commentCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(likeI.mas_left).offset(-4);
                make.top.equalTo(self).offset(4);
                make.bottom.equalTo(self).offset(-4);
            }];
            [commentI mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.commentCountLable.mas_left).offset(-4);
                make.width.mas_equalTo(ICOM_SIZE);
                make.height.mas_equalTo(ICOM_SIZE);
                make.centerY.equalTo(self);
            }];
        }
    } else {
        self.tagView = [[UITagView alloc] initUITagView:self.tagName color:kTAG_COLOR];
        [self addSubview:self.tagView];
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([self.tagView getUIWidht] + 8*2);
            make.height.mas_equalTo([self.tagView getUIHeight] + 4*2);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kCELL_MARGIN);
        }];
        [self addSubview:self.commentCountLable];
        [self addSubview:self.likeCountLable];
        UIImageView *likeI = [[UIImageView alloc] init];
        [likeI setImage:[UIImage imageNamed:@"icon_like"]];
        UIImageView *commentI = [[UIImageView alloc] init];
        [commentI setImage:[UIImage imageNamed:@"icon_comment"]];
        [self addSubview:likeI];
        [self addSubview:commentI];
        [commentI mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagView.mas_right).offset(kCELL_MARGIN);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(ICOM_SIZE);
            make.height.mas_equalTo(ICOM_SIZE);
        }];
        [self.commentCountLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentI.mas_right).offset(8);
            make.centerY.equalTo(self);
        }];
        [likeI mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentCountLable.mas_right).offset(kCELL_MARGIN);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(ICOM_SIZE);
            make.height.mas_equalTo(ICOM_SIZE);
        }];
        [self.likeCountLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentI.mas_right).offset(8);
            make.centerY.equalTo(self);
        }];
    }

}

- (CGFloat)getUIHeight;
{
    return 26;
}

+ (CGFloat)getUIHeight:(UserState)userState
{
    return 26;
}

- (void)setTagName:(NSString *)tagName
{
    _tagName = tagName;
    [self.tagView setTagName:tagName];
}

#pragma mark - get
- (UILabel *)pulibshUserNameLable
{
    if (!_pulibshUserNameLable) {
        _pulibshUserNameLable = [[UILabel alloc] init];
        _pulibshUserNameLable.textColor = HEXCOLOR(0x0099cc);
        _pulibshUserNameLable.font = Font(14);
        _pulibshUserNameLable.text = @"pulibsh user";
    }
    return _pulibshUserNameLable;
}

- (UILabel *)commentCountLable
{
    if (!_commentCountLable) {
        _commentCountLable = [[UILabel alloc] init];
        _commentCountLable.textColor = HEXCOLOR(0xCDCDCD);
        _commentCountLable.font = Font(14);
        _commentCountLable.text = @"0";
    }
    return _commentCountLable;
}

- (UILabel *)likeCountLable
{
    if (!_likeCountLable) {
        _likeCountLable = [[UILabel alloc] init];
        _likeCountLable.textColor = HEXCOLOR(0xCDCDCD);
        _likeCountLable.font = Font(14);
        _likeCountLable.text = @"0";
    }
    return _likeCountLable;
}



@end
