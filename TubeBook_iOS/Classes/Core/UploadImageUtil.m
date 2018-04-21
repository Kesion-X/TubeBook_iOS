//
//  UploadImageUtil.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/11.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UploadImageUtil.h"
#import "TimeUtil.h"
#import "AFNetworking.h"

@implementation UploadImageUtil

+ (void)uploadImage:(UIImage *)mImage success:(uploadSuccess)successCallback fail:(uploadFail)failCallback{
    NSLog(@"%s uploadImage:%@", __func__, @"http://127.0.0.1:8084/TubeBook_Web/UploadImage");
    NSString *fileName = [[TimeUtil getNowTimeTimestamp3] stringByAppendingString:@".jpg"];
    //创建manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//序列化操作
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [sessionManager POST:@"http://127.0.0.1:8084/TubeBook_Web/UploadImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *image = [UploadImageUtil imageCompressForWidthScale:mImage targetWidth:[UIScreen mainScreen].bounds.size.width - 40];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [formData  appendPartWithFileData:imageData name:@"uploadFile" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];//转utf-8
        NSLog(@"%s success %@",__func__, result);
        NSDictionary *dic = @{
                              @"message":result,
                              @"fileName":fileName
                              };
        successCallback(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallback(error);
    }];
}

+ (UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


@end
