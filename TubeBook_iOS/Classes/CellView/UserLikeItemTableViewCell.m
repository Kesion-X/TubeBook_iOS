//
//  UserLikeItemTableViewCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UserLikeItemTableViewCell.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "UserLikeItemContent.h"
#import "NSString+StringKit.h"
#import "CommentUIViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserLikeItemTableViewCell

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
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.userNameLable];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.articleTitleLable];;
    [self.contentView addSubview:self.isReviewView];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kCELL_MARGIN);
        make.top.equalTo(self).offset(4);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
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
    [self.articleTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.top.equalTo(self.avatarImageView.mas_bottom);
    }];
    UIView *spaceLine = [[UIView alloc] init];
    spaceLine.backgroundColor = HEXCOLOR(0xededed);
    [self.contentView addSubview:spaceLine];
    [spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-0.5f);
        make.left.equalTo(self.contentView).offset(kCELL_MARGIN + 32 +8);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    [self.isReviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(8);
        make.width.mas_equalTo(8);
    }];
    
    UITapGestureRecognizer *tapAvatarGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatar)];
    [self.avatarImageView addGestureRecognizer:tapAvatarGesturRecognizer];
    [self.avatarImageView setUserInteractionEnabled:YES];
}

- (void)tapAvatar
{
    TubeRefreshTableViewController *controller = self.viewController;
    if ([controller.keyForIndexBlockDictionary objectForKey:kUserLikeItemTableViewCellAvatarImageViewTap]) {
        tapForIndexBlock block = [controller.keyForIndexBlockDictionary objectForKey:kUserLikeItemTableViewCellAvatarImageViewTap];
        block([controller.refreshTableView indexPathForCell:self]);
    }
}

- (CGFloat)getCellHeight
{
    return 4 + 32 + 18 + 16 + 8;
}

+ (CGFloat)getCellHeight:(CKContent *)content
{
    UserLikeItemContent *mcontent = (UserLikeItemContent *)content;
    CGFloat height = 0;
    height = 4 + 32 + [NSString getSizeWithAttributes:mcontent.articleTitle width:(SCREEN_WIDTH - kCELL_MARGIN - 32 - 8) font:Font(14)].height + 16 + 8;
    return height;
}

- (void)setContent:(CKContent *)content
{
    [super setContent:content];
    UserLikeItemContent *mcontent = (UserLikeItemContent *)content;
    self.articleTitle = mcontent.articleTitle;
    self.avatarUrl = content.avatarUrl;
    self.userName = content.userName;
    self.time = mcontent.time;
    self.isReview = mcontent.isReview;
}

#pragma mark - set
- (void)setIsReview:(BOOL)isReview
{
    _isReview = isReview;
    self.isReviewView.hidden = isReview;
}

- (void)setArticleTitle:(NSString *)articleTitle
{
    _articleTitle = articleTitle;
    self.articleTitleLable.text = [NSString stringWithFormat:@"来自文章:%@",articleTitle];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    self.userNameLable.text = [userName stringByAppendingString:@" 喜欢了你的文章"];
}

- (void)setAvatarUrl:(NSString *)avatarUrl
{
    _avatarUrl = avatarUrl;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
    
}

- (void)setTime:(NSString *)time
{
    _time = time;
    self.timeLable.text = time;
}

#pragma mark - get

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

- (UILabel *)articleTitleLable
{
    if (!_articleTitleLable) {
        _articleTitleLable = [[UILabel alloc] init];
        _articleTitleLable.textColor = kTEXTCOLOR;
        _articleTitleLable.font = Font(14);
        _articleTitleLable.text = @"commentLable";
        _articleTitleLable.numberOfLines = 0;
        _articleTitleLable.lineBreakMode = NSLineBreakByCharWrapping;
        //_commentLable.backgroundColor = [UIColor grayColor];
    }
    return _articleTitleLable;
}

- (UIView *)isReviewView
{
    if (!_isReviewView) {
        _isReviewView = [[UIView alloc] init];
        _isReviewView.backgroundColor = HEXCOLOR(0xff6b6b);//红
        _isReviewView.layer.cornerRadius = 4;
        _isReviewView.layer.borderWidth = 0.5f;
        _isReviewView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _isReviewView.layer.masksToBounds = YES;
        _isReviewView.hidden = YES;
    }
    return _isReviewView;
}
@end
