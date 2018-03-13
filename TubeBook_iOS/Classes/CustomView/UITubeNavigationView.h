//
//  UITubeNavigationView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/8.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^leftBtCallback)(void);
typedef void(^rightBtCallback)(void);

@interface UITubeNavigationView : UIView

- (instancetype) initUITubeNavigationView:(UIViewController *)sourceViewController leftTitle:(NSString *)leftTitle leftBtCallback:(leftBtCallback)leftCallback rightTitle:(NSString *)rightTitle rightBtCallback:(rightBtCallback)rightCallback centerTitle:(NSString *)centerTitle;

@end
