//
//  TubeBundleImageTool.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDImageCache.h"

@interface TubeBundleImageTool : NSObject

/**
 一个基于SDImageCache的读取mainbundlepng中png图片工具，支持内存缓存
 图片名称栗子: 对于文件名abc, 如果bundle中有abc@2x.png, 那么直接传入name = "abc"即可, 如果只有abc.png, 则传入name = "abc.png"
 
 @param name 图片名称，不需要带scale和后缀
 @return 图片对象
 */
+ (UIImage *)cacheImageFromMainBundleNamed:(NSString *)name;

/**
 根据给定的图片名称从mainbundle中加载对应的png图片并返回， 如果不存在则返回nil
 图片名称栗子: 对于文件名abc, 如果bundle中有abc@2x.png, 那么直接传入name = "abc"即可, 如果只有abc.png, 则传入name = "abc.png"
 
 @param name 图片名称
 @return image
 */
+ (UIImage *)imageFromMainBundleNamed:(NSString *)name;

@end
