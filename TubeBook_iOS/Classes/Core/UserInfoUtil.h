//
//  UserInfoUtil.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kAccountKey @"accountKey" // 取账号

@interface UserInfoUtil : NSObject
// account
@property (nonatomic, strong) NSMutableDictionary *userInfo;

+ (instancetype)sharedInstance;

@end
