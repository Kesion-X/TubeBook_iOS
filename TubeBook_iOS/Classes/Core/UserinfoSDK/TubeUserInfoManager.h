//
//  TubeUserInfoManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "BaseTubeServerManager.h"
#import "TubeUserConst.h"

@interface TubeUserInfoManager : BaseTubeServerManager


- (instancetype)initTubeUserInfoManagerWithSocket:(TubeServerDataSDK *)tubeServer;

// 获取人物基本信息
- (void)fetchedUserInfoWithUid:(NSString *)uid isSelf:(BOOL)isSelf callBack:(dataCallBackBlock)callBack;
// 获取关注的用户列表 
- (void)fetchedAttentedUserListWithUid:(NSString *)uid index:(NSInteger)index callBack:(dataCallBackBlock)callBlock;
// 获取用户关注用户数
- (void)fetchedUserAttenteUserCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBlock;
// 获取用户粉丝数
- (void)fetchedUserAttentedCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBlock;
// 获取关注状态
- (void)fetchedUserAttentStatusWithUid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock;
// 设置关注/取消关注
- (void)setUserAttentWithStatus:(BOOL)isAttent uid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock;
// 获取用户写的文章列表
- (void)fetchedSelfArticleListWithIndex:(NSInteger)index
                                uid:(NSString *)uid
                        articleType:(UserArticleType)articleType
                           callback:(dataCallBackBlock)callback;
// 获取粉丝列表
- (void)fetchedFansListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock;

// 获取自己喜欢的文章列表
- (void)fetchedLikeArticleListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock;

// 设置头像
- (void)setUserAvaterWithUid:(NSString *)uid imageUrl:(NSString *)imageUrl callBack:(dataCallBackBlock)callBlock;

// 设置第三方文章收藏状态
- (void)setThirdCollectionStatus:(BOOL)collectStatus url:(NSString *)url uid:(NSString *)uid title:(NSString *)title callBack:(dataCallBackBlock)callBlock;
// 获取收藏第三方文章列表
- (void)fetchedThirdCollectionListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock;

// 获取自己看过的文章列表
- (void)fetchedReviewArticleList:(NSString *)uid;

@end
