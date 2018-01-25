//
//  UIRingScrollView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/24.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRingScrollView : UIView

- (instancetype)initWithFrameUIRingScrollView:(CGRect)frame
                                   arrayItems:(NSMutableArray *)arrayItems
                                  normalColor:(UIColor *)normalColor
                                   lightColor:(UIColor *)lightColor;

@end
