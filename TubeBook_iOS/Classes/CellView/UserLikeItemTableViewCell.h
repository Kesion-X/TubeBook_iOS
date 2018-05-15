//
//  UserLikeItemTableViewCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"
#define kUserLikeItemTableViewCellAvatarImageViewTap [NSStringFromClass([UserLikeItemTableViewCell class]) stringByAppendingString:@"avatarImageViewTap"]
#define kUserLikeItemTableViewCellArtilceTitleLableViewTap [NSStringFromClass([UserLikeItemTableViewCell class]) stringByAppendingString:@"ArticleTitleViewTap"]

@interface UserLikeItemTableViewCell : CKTableCell

@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *articleTitle;
//@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, assign) BOOL isReview;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *userNameLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *articleTitleLable;
//@property (nonatomic, strong) UILabel *articleTitleLable;
@property (nonatomic, strong) UIView *isReviewView;

@end
