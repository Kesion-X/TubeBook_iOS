//
//  UserCommentTableViewCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/30.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"
#define kCountLableTap [NSStringFromClass([UserCommentTableViewCell class]) stringByAppendingString:@"countLableTap"]
#define kAvatarImageViewTap [NSStringFromClass([UserCommentTableViewCell class]) stringByAppendingString:@"avatarImageViewTap "]

@interface UserCommentTableViewCell : CKTableCell

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *commentLable;
@property (nonatomic, strong) UILabel *commentCountLable;

@end
