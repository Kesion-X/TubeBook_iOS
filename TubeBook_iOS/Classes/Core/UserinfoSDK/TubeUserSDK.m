//
//  TubeUserSDK.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeUserSDK.h"

@interface TubeUserSDK ()

@property (nonatomic, strong) TubeUserInfoManager *userManager;

@end

@implementation TubeUserSDK

- (instancetype)initTubeUserSDK:(TubeServerDataSDK *)tubeServer
{
    self = [super init];
    if (self) {
        self.userManager = [[TubeUserInfoManager alloc] initTubeUserInfoManagerWithSocket:tubeServer];
    }
    return self;
}

// 获取人物基本信息
- (void)fetchedUserInfoWithUid:(NSString *)uid isSelf:(BOOL)isSelf callBack:(dataCallBackBlock)callBack
{
    [self.userManager fetchedUserInfoWithUid:uid isSelf:isSelf callBack:callBack];
}

// 获取关注的用户列表
- (void)fetchedAttentedUserListWithUid:(NSString *)uid index:(NSInteger)index callBack:(dataCallBackBlock)callBlock
{
    [self.userManager fetchedAttentedUserListWithUid:uid index:index callBack:callBlock];
}

// 获取关注状态
- (void)fetchedUserAttentStatusWithUid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock
{
    [self.userManager fetchedUserAttentStatusWithUid:uid attentUid:attentUid callBack:callBlock];
}
// 设置关注/取消关注
- (void)setUserAttentWithStatus:(BOOL)isAttent uid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock
{
    [self.userManager setUserAttentWithStatus:isAttent uid:uid attentUid:attentUid callBack:callBlock];
}

@end
