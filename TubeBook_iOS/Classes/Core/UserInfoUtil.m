//
//  UserInfoUtil.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UserInfoUtil.h"

@implementation UserInfoUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static UserInfoUtil *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfoUtil alloc] init];
    });
    return userInfo;
}

@end
