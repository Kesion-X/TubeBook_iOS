//
//  UITagView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITagView : UIView

@property(nonatomic, strong) UILabel *tagLable;
@property(nonatomic, strong) NSString *tagText;
@property(nonatomic, strong) UIColor *color;

- (instancetype)initUITagView:(NSString *)tagText color:(UIColor *)color;
- (CGFloat)getUIHeight;
- (CGFloat)getUIWidht;

@end
