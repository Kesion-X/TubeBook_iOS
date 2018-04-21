//
//  UIHomeCellItemContentView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDataType.h"

@interface UIHomeCellItemContentView : UIView

@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *contentDescription;
@property (nonatomic) BOOL isHaveImage;
@property (nonatomic) UIContentCellStyle contentCellStyle;

@property(nonatomic, strong) UIImageView *contentImageView;
@property(nonatomic, strong) UILabel *titleLable;
@property(nonatomic, strong) UILabel *descriptionLable;

- (instancetype)initUIHomeCellItemContentView:(BOOL)isHaveImage;
- (instancetype)initUIHomeCellItemContentView:(BOOL)isHaveImage contentCellStyle:(UIContentCellStyle)contentCellStyle;
- (instancetype)initUIHomeCellItemContentView:(NSString *)contentUrl title:(NSString *)title contentDescription:(NSString *)contentDescription isHaveImage:(BOOL)isHaveImage;
- (instancetype)initUIHomeCellItemContentView:(NSString *)contentUrl title:(NSString *)title contentDescription:(NSString *)contentDescription isHaveImage:(BOOL)isHaveImage contentCellStyle:(UIContentCellStyle)contentCellStyle;

- (CGFloat)getUIHeight;
+ (CGFloat)getUIHeight:(BOOL)isHaveImage;
+ (CGFloat)getUIHeight:(BOOL)isHaveImage contentStyle:(UIContentCellStyle)contentStyle;
- (void)setDataWithTitle:(NSString *)title contentDescription:(NSString *)contentDescription contentUrl:(NSString *)contentUrl;

@end
