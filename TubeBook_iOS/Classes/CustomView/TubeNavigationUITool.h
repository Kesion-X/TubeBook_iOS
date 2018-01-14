//
//  TubeNavigationUITool.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TubeNavigationUITool : NSObject

+ (TubeNavigationUITool *)sharedInstance;
+ (UIBarButtonItem *)itemWithIconImage:(UIImage *)iconImage
                                 title:(NSString *)title
                            titleColor:(UIColor *)color
                                target:(id)target action:(SEL)action;
+ (UIView *)itemTitleWithLableTitle:(NSString *)title titleColoe:(UIColor *)color;

@end
