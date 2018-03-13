//
//  UIImage+Extension.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/8.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 * 传入图片的名称,返回一张可拉伸不变形的图片
 *
 * @param imageName 图片名称
 *
 * @return 可拉伸图片
 */
+ (UIImage *)resizableImageWithName:(NSString *)imageName;

@end
