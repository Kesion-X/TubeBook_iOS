//
//  UIHomeCellItemHeadView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIHomeCellItemHeadView.h"
#import "CKMacros.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UIHomeCellItemHeadView ()

@end

@implementation UIHomeCellItemHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addViewAndConstraint];
    }
    return self;
}

- (instancetype)initUIHomeCellItemHeadView:(UserState)userState;
{
    self = [super init];
    if (self) {
        self.userState = userState;
        [self addViewAndConstraint];
    }
    return self;
}

- (instancetype)initUIHomeCellItemHeadView:(NSString *)avatarUrl username:(NSString *)username time:(NSString *)time islike:(BOOL)islike
{
    self = [super init];
    if (self) {
        self.avatarUrl = avatarUrl;
        self.userName = username;
        self.time = time;
        self.islike = islike;
        [self addViewAndConstraint];
    }
    return self;
}

- (void)addViewAndConstraint
{
    [self addSubview:self.avatarImageView];
    [self addSubview:self.userNameLable];
    [self addSubview:self.timeLable];
    [self addSubview:self.likeOrPublishLable];
    [self addSubview:self.menuButton];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kCELL_MARGIN);
        make.top.equalTo(self).offset(4);
        make.width.mas_equalTo(32);
        make.bottom.equalTo(self).offset(-4);
    }];
    [self.userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
        make.top.equalTo(self).offset(4);
        make.height.mas_equalTo(16);
    }];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
        make.top.equalTo(self.userNameLable.mas_bottom).offset(2);
        make.height.mas_equalTo(14);
    }];
    [self.likeOrPublishLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLable.mas_right).offset(8);
        make.top.equalTo(self).offset(4);
        make.height.mas_equalTo(16);
    }];
    [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
        make.centerY.equalTo(self);
    }];
    if ( self.userState == UserLikeArticle ) {
        self.likeOrPublishLable.text = @"喜欢了文章";
    } else {
        self.likeOrPublishLable.text = @"发表了文章";
    }
}

- (CGFloat)getUIHeight
{
    return 40;
}

+ (CGFloat)getUIHeight:(UserState)userState
{
    return 40;
}

- (void)setDataWithAvatarUrl:(NSString *)avatarUrl
       userName:(NSString *)userName
           time:(NSString *)time
      userState:(UserState)userState
{
    self.avatarUrl = avatarUrl;
    self.userName = userName;
    self.time = time;
    self.userState = userState;
}

- (void)setAvatarUrl:(NSString *)avatarUrl
{
    _avatarUrl = avatarUrl;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    [self.userNameLable setText:userName];
}

- (void)setTime:(NSString *)time
{
    _time = time;
    [self.timeLable setText:time];
}

- (void)setIslike:(BOOL)islike
{
    _islike = islike;
}

- (void)setUserState:(UserState)userState
{
    _userState = userState;
    if ( self.userState == UserLikeArticle ) {
        self.likeOrPublishLable.text = @"喜欢了文章";
    } else {
        self.likeOrPublishLable.text = @"发表了文章";
    }
}

#pragma mark - get
- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _avatarImageView.layer.borderWidth = 0.5f;
        _avatarImageView.layer.cornerRadius = 16;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)userNameLable
{
    if (!_userNameLable) {
        _userNameLable = [[UILabel alloc] init];
        _userNameLable.textColor = kTEXTCOLOR;
        _userNameLable.font = Font(14);
        _userNameLable.text = @"username";
    }
    return _userNameLable;
}

- (UILabel *)timeLable
{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.textColor = kTAB_TEXT_COLOR;
        _timeLable.font = Font(12);
        _timeLable.text = @"time";
    }
    return _timeLable;
}

- (UILabel *)likeOrPublishLable
{
    if (!_likeOrPublishLable) {
        _likeOrPublishLable = [[UILabel alloc] init];
        _likeOrPublishLable.textColor = kTEXTCOLOR;
        _likeOrPublishLable.font = Font(14);
        _likeOrPublishLable.text = @"like or publish";
    }
    return _likeOrPublishLable;
}

- (UIButton *)menuButton
{
    if (!_menuButton) {
        _menuButton = [[UIButton alloc] init];
        [_menuButton setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    }
    return _menuButton;
}



@end
