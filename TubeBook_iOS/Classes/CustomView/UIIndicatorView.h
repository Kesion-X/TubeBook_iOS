//
//  UIIndicatorView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIIndicatorViewStyle) {
    UIIndicatorViewDefaultStyle,
    UIIndicatorViewLineStyle,
};
@protocol UIIndicatorViewDelegate <NSObject>

@optional
- (void) indicatorItemsClick:(NSUInteger)index;

@end

@interface UIIndicatorView : UIScrollView

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIColor *indicatorColor;//滑块背景
@property (nonatomic) NSUInteger currentIndicator;//当前滑块位置
@property (nonatomic,strong) NSMutableArray *itemArrays;
@property (nonatomic) UIIndicatorViewStyle style;
@property (nonatomic, strong) id<UIIndicatorViewDelegate> delegate;

- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor frame:(CGRect)frame arrays:(NSMutableArray *)arrays font:(UIFont *)font textNormalColor:(UIColor *)textNormalColor textLightColor:(UIColor *)textLightColor;
- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor style:(UIIndicatorViewStyle)style arrays:(NSMutableArray *)arrays font:(UIFont *)font textNormalColor:(UIColor *)textNormalColor textLightColor:(UIColor *)textLightColor isEnableAutoScroll:(BOOL)isEnableAutoScroll;
- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor font:(UIFont *)font;
- (void)addIndicatorItemByString:(NSString *)item;
- (CGFloat)getUIHeight;
- (CGFloat)getUIWidth;
- (void)setShowIndicatorItem:(NSUInteger)index;
- (void)changeIndicatorViewSize:(BOOL)isRight scale:(CGFloat)scale;

@end
