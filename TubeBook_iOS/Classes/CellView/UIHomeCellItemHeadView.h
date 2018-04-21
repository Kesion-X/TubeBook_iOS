//
//  UIHomeCellItemHeadView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDataType.h"

@interface UIHomeCellItemHeadView : UIView

@property(nonatomic, strong) NSString *avatarUrl;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *time;
@property(nonatomic) BOOL islike;
@property(nonatomic) UserState userState;
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *userNameLable;
@property(nonatomic, strong) UILabel *timeLable;
@property(nonatomic, strong) UILabel *likeOrPublishLable;
@property(nonatomic, strong) UIButton *menuButton;

- (instancetype)initUIHomeCellItemHeadView:(UserState)userState;
- (instancetype)initUIHomeCellItemHeadView:(NSString *)avatarUrl username:(NSString *)username time:(NSString *)time islike:(BOOL)islike;
- (CGFloat)getUIHeight;
+ (CGFloat)getUIHeight:(UserState)userState;
- (void)setDataWithAvatarUrl:(NSString *)avatarUrl
       userName:(NSString *)userName
           time:(NSString *)time
      userState:(UserState)userState;
@end
