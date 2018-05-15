//
//  UserCommentTableViewCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/30.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UserCommentTableViewCell.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "UserCommentContent.h"
#import "NSString+StringKit.h"
#import "CommentUIViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserCommentTableViewCell

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
    [self.contentView addSubview:self.commentCountLable];
    [self.contentView addSubview:self.commentLable];
    
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
    [self.commentCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-8);
        make.right.equalTo(self.contentView).offset(-8);
        make.height.mas_equalTo(16);
    }];
    [self.commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
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
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCountLable)];
    [self.commentCountLable addGestureRecognizer:tapGesturRecognizer];
    [self.commentCountLable setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapAvatarGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatar)];
    [self.avatarImageView addGestureRecognizer:tapAvatarGesturRecognizer];
    [self.avatarImageView setUserInteractionEnabled:YES];
}

- (void)tapAvatar
{
    TubeRefreshTableViewController *controller = self.viewController;
    if ([controller.keyForIndexBlockDictionary objectForKey:kAvatarImageViewTap]) {
        tapForIndexBlock block = [controller.keyForIndexBlockDictionary objectForKey:kAvatarImageViewTap];
        block([controller.refreshTableView indexPathForCell:self]);
    }
}

- (void)tapCountLable
{
    TubeRefreshTableViewController *controller = self.viewController;
    if ([controller.keyForIndexBlockDictionary objectForKey:kCountLableTap]) {
       tapForIndexBlock block = [controller.keyForIndexBlockDictionary objectForKey:kCountLableTap];
        block([controller.refreshTableView indexPathForCell:self]);
    }
}

- (CGFloat)getCellHeight
{
    return 4 + 32 + 18 + 16 + 8;
}

+ (CGFloat)getCellHeight:(CKContent *)content
{
    UserCommentContent *mcontent = (UserCommentContent *)content;
    CGFloat height = 0;
    if (mcontent.commentCount == 0) {
        height = 4 + 32 + [NSString getSizeWithAttributes:mcontent.comment width:(SCREEN_WIDTH - kCELL_MARGIN - 32 - 8) font:Font(14)].height  + 8;
    } else {
        height = 4 + 32 + [NSString getSizeWithAttributes:mcontent.comment width:(SCREEN_WIDTH - kCELL_MARGIN - 32 - 8) font:Font(14)].height + 16 + 8;
    }
    //height = 4 + 32 + [NSString getSizeWithAttributes:mcontent.comment width:(SCREEN_WIDTH - kCELL_MARGIN - 32 - 8) font:Font(16)].height + 16 + 8;
    return height;
}

- (void)setContent:(CKContent *)content
{
    [super setContent:content];
    UserCommentContent *mcontent = (UserCommentContent *)content;
    self.commentCount = mcontent.commentCount;
    self.avatarUrl = content.avatarUrl;
    self.userName = content.userName;
    self.time = mcontent.time;
    self.comment = mcontent.comment;
}

#pragma mark - set
- (void)setCommentCount:(NSInteger)commentCount{
    _commentCount = commentCount;
    if (commentCount == 0) {
        self.commentCountLable.hidden = YES;
    } else {
        self.commentCountLable.hidden = NO;
        self.commentCountLable.text = [NSString stringWithFormat:@"%lu 个回复", commentCount];
    }
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    self.userNameLable.text = userName;
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

- (void)setComment:(NSString *)comment
{
    _comment = comment;
    self.commentLable.text = comment;
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

- (UILabel *)commentLable
{
    if (!_commentLable) {
        _commentLable = [[UILabel alloc] init];
        _commentLable.textColor = kTEXTCOLOR;
        _commentLable.font = Font(14);
        _commentLable.text = @"commentLable";
        _commentLable.numberOfLines = 0;
        _commentLable.lineBreakMode = NSLineBreakByCharWrapping;
        //_commentLable.backgroundColor = [UIColor grayColor];
    }
    return _commentLable;
}

- (UILabel *)commentCountLable
{
    if (!_commentCountLable) {
        _commentCountLable = [[UILabel alloc] init];
        _commentCountLable.textColor = HEXCOLOR(0x6495ED);
        _commentCountLable.font = Font(12);
        _commentCountLable.text = @"commentCountLable";
        _commentCountLable.backgroundColor = HEXCOLOR(0xededed);
        //_commentCountLable.r
    }
    return _commentCountLable;
}


@end
