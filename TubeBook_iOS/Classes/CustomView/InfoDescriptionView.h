//
//  InfoDescriptionView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKMacros.h"
#import "TubeUIImageView.h"

typedef NS_ENUM(NSInteger, InfoDescriptionType)
{
    InfoDescriptionTypeArticle,
    InfoDescriptionTypeTopic,
    InfoDescriptionTypeSerial,
    InfoDescriptionTypeUser
};

@interface InfoDescriptionView : UIView

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *infoImageUrl;
@property (nonatomic, strong) NSString *infoName;
@property (nonatomic, strong) NSString *infomotto;
@property (nonatomic, strong) NSString *infoTime;
@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *infoDescription;
@property (nonatomic, assign) BOOL isLike;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, assign) InfoDescriptionType infoType;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) TubeUIImageView *infoImageView;
@property (nonatomic, strong) UILabel *infoNameLable;
@property (nonatomic, strong) UILabel *infoMottoLable;
@property (nonatomic, strong) UILabel *infoTimeLable;
@property (nonatomic, strong) UILabel *infoTitleLable;
@property (nonatomic, strong) UILabel *infoDescriptionLable;

- (instancetype)initInfoDescriptionViewWithFrame:(CGRect)frame infoType:(InfoDescriptionType)infoType;
+ (CGFloat)getViewHeightWithInfotype:(InfoDescriptionType)infoType;
- (void)setSpaceColor:(UIColor *)color;
- (void)setDetailBackImage:(UIImage *)image;
- (void)setAllTitleLableWithColor:(UIColor *)color;
- (void)setActionForLikeButtonWithTarget:(nullable id)target action:(SEL)action;
- (void)setActionInfoImageWithTarget:(nullable id)target action:(nullable SEL)action;

@end
