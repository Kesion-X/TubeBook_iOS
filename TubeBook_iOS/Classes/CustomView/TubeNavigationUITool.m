//
//  TubeNavigationUITool.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeNavigationUITool.h"
#import "CKMacros.h"

@implementation TubeNavigationUITool

+ (TubeNavigationUITool *)sharedInstance{
    static TubeNavigationUITool *tubeBookNavigationUITool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tubeBookNavigationUITool = [[TubeNavigationUITool alloc] init];
    });
    return tubeBookNavigationUITool;
}

+ (UIBarButtonItem *)itemWithIconImage:(UIImage *)iconImage
                                 title:(NSString *)title
                            titleColor:(UIColor *)color
                                target:(id)target
                                action:(SEL)action
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat delta = SCREEN_WIDTH == 414 ? 0 : 4;
#ifdef __IPHONE_11_0
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        delta -= 4;
    }
#endif
    delta -= 4;
    customButton.contentEdgeInsets = UIEdgeInsetsMake(0, delta/2, 0, -delta/2);
    [customButton setImage:iconImage forState:UIControlStateNormal];
    [customButton setImage:iconImage forState:UIControlStateHighlighted];
    customButton.frame = CGRectMake(0.0f, 0.0f, 65, 32.0f);
    [customButton setTitleColor:color forState:UIControlStateNormal];
    customButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    customButton.titleLabel.font = Font(17);
    [customButton setTitle:title forState:UIControlStateNormal];
    customButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    customButton.titleLabel.minimumScaleFactor = 10.0;
    customButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    customButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [customButton addTarget:target
                     action:action
           forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:customButton];
}

+ (UIBarButtonItem *)itemWithIconImage:(UIImage *)iconImage
                         itemDirection:(ButtomItemDirection)itemDirection
                                 title:(NSString *)title
                            titleColor:(UIColor *)color
                                target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = nil;
    if (itemDirection == LeftButtomItem) {
        item = [TubeNavigationUITool itemWithIconImage:iconImage title:title titleColor:color target:target action:action];
    } else {
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customButton.frame = CGRectMake(0.0f, 0.0f, 65, 32.0f);
        [customButton setTitleColor:color forState:UIControlStateNormal];
        customButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        customButton.titleLabel.font = Font(17);
        [customButton setTitle:title forState:UIControlStateNormal];
        customButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        customButton.titleLabel.minimumScaleFactor = 10.0;
        customButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        customButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [customButton addTarget:target
                         action:action
               forControlEvents:UIControlEventTouchUpInside];
        item = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    }
    return item;
}

+ (UIView *)itemTitleWithLableTitle:(NSString *)title titleColoe:(UIColor *)color
{
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = title;
    titleLable.font = FontBold(18);
    titleLable.textColor = color;
    return titleLable;
}

@end
