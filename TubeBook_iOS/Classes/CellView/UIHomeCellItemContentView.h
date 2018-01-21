//
//  UIHomeCellItemContentView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHomeCellItemContentView : UIView

@property(nonatomic, strong) NSString *contentUrl;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *contentDescription;
@property(nonatomic) BOOL isHaveImage;

@property(nonatomic, strong) UIImageView *contentImageView;
@property(nonatomic, strong) UILabel *titleLable;
@property(nonatomic, strong) UILabel *descriptionLable;

- (instancetype)initUIHomeCellItemContentView:(NSString *)contentUrl title:(NSString *)title contentDescription:(NSString *)contentDescription isHaveImage:(BOOL)isHaveImage;
- (CGFloat)getUIHeight;

@end
