//
//  CKContent.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKDataType.h"

@interface CKContent : NSObject

@property(nonatomic, strong) NSString *avatarUrl; // 用户头像
@property(nonatomic, strong) NSString *userName; //用户名称
@property(nonatomic, strong) NSString *time; //动态时间
@property(nonatomic, strong) NSString *pulibshUserName; //发布者名称
@property(nonatomic) NSUInteger commentCount; // 评论数
@property(nonatomic) NSUInteger likeCount; // 喜欢数

@property(nonatomic, strong) CKDataType *dataType; // 数据类型

@end
