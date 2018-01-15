//
//  TubeBundleImageTool.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeBundleImageTool.h"

@implementation TubeBundleImageTool

+ (UIImage *)cacheImageFromMainBundleNamed:(NSString *)name
{
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:name];
    if (!cacheImage) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *imageBundlePath = [bundlePath stringByAppendingPathComponent:name];
        cacheImage = [UIImage imageWithContentsOfFile:imageBundlePath];
        if (!cacheImage) {
            // 第一次取不到图片, 做一次适配
            int scale = [UIScreen mainScreen].scale;
            NSString *suitableSuffix = [NSString stringWithFormat:@"@%dx.png", scale];
            imageBundlePath = [imageBundlePath stringByAppendingString:suitableSuffix];
            cacheImage = [UIImage imageWithContentsOfFile:imageBundlePath];
            if (!cacheImage) {
                // 还是取不到图片, 就直接强制读2x图片
                imageBundlePath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png", name]];
                cacheImage = [UIImage imageWithContentsOfFile:imageBundlePath];
            }
        }
        if (cacheImage) {
            [[SDImageCache sharedImageCache] storeImage:cacheImage forKey:name toDisk:NO completion:nil];
        }
    }
    return cacheImage;
}

+ (UIImage *)imageFromMainBundleNamed:(NSString *)name
{
    UIImage *image = nil;
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:name];
    image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    if (!image) {
        // 第一次取不到图片, 做一次适配
        int scale = [UIScreen mainScreen].scale;
        NSString *suitableSuffix = [NSString stringWithFormat:@"@%dx.png", scale];
        imagePath = [imagePath stringByAppendingString:suitableSuffix];
        image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        if (!image) {
            // 还是取不到图片, 就直接强制读2x图片
            imagePath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.png", name]];
            image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        }
    }
    return image;
}

@end
