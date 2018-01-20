//
//  UIIndicatorView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIIndicatorViewDelegate <NSObject>

@optional
- (void) indicatorChange:(NSUInteger)index;

@end

@interface UIIndicatorView : UIScrollView

@property (nonatomic, strong) id<UIIndicatorViewDelegate> delegate;

- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor font:(UIFont *)font;
- (void)addIndicatorItemByString:(NSString *)item;
- (CGFloat)getUIHeight;
- (void)setShowIndicatorItem:(NSUInteger)index;
- (void)changeIndicatorViewSize:(BOOL)isRight scale:(CGFloat)scale;
@end
