//
//  UIHomeCellTopicOrSerialView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDataType.h"
#import "UITagView.h"

@interface UIHomeCellTopicOrSerialView : UIView

@property (nonatomic, strong) NSString *tagImageUrl;//专题/连载图片
@property (nonatomic, strong) NSString *title;//专题/连载标题
@property (nonatomic, strong) NSString *articleTag;//专题/连载标签
@property (nonatomic) ArticleKind kind;//普通/专题/连载

@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *articleTagLable;
@property (nonatomic, strong) UITagView *kindView;

- (instancetype)initUIHomeCellTopicOrSerialView:(ArticleKind)kind;
- (CGFloat)getUIHeight;
+ (CGFloat)getUIHeight:(ArticleKind)kind;
@end
