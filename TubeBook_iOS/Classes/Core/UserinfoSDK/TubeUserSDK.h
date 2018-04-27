//
//  TubeUserSDK.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeUserInfoManager.h"

@interface TubeUserSDK : NSObject

- (instancetype)initTubeUserSDK:(TubeServerDataSDK *)tubeServer;
// 获取人物基本信息
- (void)fetchedUserInfoWithUid:(NSString *)uid isSelf:(BOOL)isSelf callBack:(dataCallBackBlock)callBack;
// 获取关注的用户列表
- (void)fetchedAttentedUserListWithUid:(NSString *)uid index:(NSInteger)index callBack:(dataCallBackBlock)callBlock;
// 获取关注状态
- (void)fetchedUserAttentStatusWithUid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock;
// 设置关注/取消关注
- (void)setUserAttentWithStatus:(BOOL)isAttent uid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock;

@end
