//
//  CKMacros.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

#ifndef IPHONE
#define IPHONE_4_4S_SCREEN_WIDTH 320.0f
#define IPHONE_4_4S_SCREEN_HEIGHT 480.0f
#define IPHONE_5_5S_5C_SCREEN_WIDTH 320.0f
#define IPHONE_5_5S_5C_SCREEN_HEIGHT 568.0f
#define IPHONE_6_6S_7_SCREEN_WIDTH 375.0f
#define IPHONE_6_6S_7_SCREEN_HEIGHT 667.0f
#define IPHONE_6P_6SP_7P_SCREEN_WIDTH 414.0f
#define IPHONE_6P_6SP_7P_SCREEN_HEIGHT 736.0f
#define IPHONE_X_SCREEN_HEIGHT 812.0f
#endif

#ifndef CK_WIDTH
#define CK_WIDTH(w) SCREEN_WIDTH/IPHONE_6_6S_7_SCREEN_WIDTH*w
#endif

#ifndef CK_HEIGHT
#define CK_HEIGHT(H) SCREEN_HEIGHT/IPHONE_6_6S_7_SCREEN_HEIGHT*h
#endif

#define Font(x) [UIFont systemFontOfSize:x]

#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(hexValue) [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:1.0]
#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:(alphaValue)]
#endif

@interface CKMacros : NSObject

@end
