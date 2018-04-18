//
//  UIImageWithLable.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/18.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kIconMarginBottom 10
@interface UIImageWithLable : UIView

@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger countNotReview;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *countLable;

- (instancetype)initUIImageWithLableWithWidth:(CGFloat)width height:(CGFloat)height;
- (void)setIconByImageName:(NSString *)imageName;

@end
