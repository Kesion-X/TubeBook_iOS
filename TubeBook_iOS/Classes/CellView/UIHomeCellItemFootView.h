//
//  UIHomeCellItemFootView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDataType.h"
#import "UITagView.h"

typedef NS_ENUM(NSInteger,UIFootCellStyle)
{
    UIFootCellNormalStyle,
    UIFootCellImageLeftStyle,
};


@interface UIHomeCellItemFootView : UIView

@property (nonatomic, strong) NSString *pulibshUserName;
@property (nonatomic) NSUInteger commentCount;
@property (nonatomic) NSUInteger likeCount;
@property (nonatomic) UserState userState;
@property (nonatomic) NSString *tagName;
@property (nonatomic) UIFootCellStyle footCellStyle;

@property(nonatomic, strong) UILabel *pulibshUserNameLable;
@property(nonatomic, strong) UILabel *commentCountLable;
@property(nonatomic, strong) UILabel *likeCountLable;
@property (nonatomic, strong) UITagView *tagView;

- (instancetype)initUIHomeCellItemFootView:(UserState)userState;
- (instancetype)initUIHomeCellItemFootView:(UserState)userState footCellStyle:(UIFootCellStyle)footCellStyle;
- (instancetype)initUIHomeCellItemFootView:(NSString *)pulibshUserName commentCount:(NSUInteger)commentCount likeCount:(NSUInteger)likeCount;
- (instancetype)initUIHomeCellItemFootView:(NSString *)tagName commentCount:(NSUInteger)commentCount likeCount:(NSUInteger)likeCount footCellStyle:(UIFootCellStyle)footCellStyle;
- (CGFloat)getUIHeight;
+ (CGFloat)getUIHeight:(UserState)userState;

@end
