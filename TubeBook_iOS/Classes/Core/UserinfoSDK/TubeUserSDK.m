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

// 获取用户关注用户数
- (void)fetchedUserAttenteUserCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    [self.userManager fetchedUserAttenteUserCountWithUid:uid callBack:callBlock];
}

// 获取用户粉丝数
- (void)fetchedUserAttentedCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    [self.userManager fetchedUserAttentedCountWithUid:uid callBack:callBlock];
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

// 获取用户写的文章列表
- (void)fetchedSelfArticleListWithIndex:(NSInteger)index
                                    uid:(NSString *)uid
                            articleType:(UserArticleType)articleType
                               callback:(dataCallBackBlock)callback
{
    [self.userManager fetchedSelfArticleListWithIndex:index uid:uid articleType:articleType callback:callback];
}

// 获取粉丝列表
- (void)fetchedFansListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    [self.userManager fetchedFansListWithIndex:index uid:uid callBack:callBlock];
}

// 获取自己喜欢的文章列表
- (void)fetchedLikeArticleListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    [self.userManager fetchedLikeArticleListWithIndex:index uid:uid callBack:callBlock];
}

// 设置头像
- (void)setUserAvaterWithUid:(NSString *)uid imageUrl:(NSString *)imageUrl callBack:(dataCallBackBlock)callBlock
{
    [self.userManager setUserAvaterWithUid:uid imageUrl:imageUrl callBack:callBlock];
}

// 设置第三方文章收藏状态
- (void)setThirdCollectionStatus:(BOOL)collectStatus url:(NSString *)url uid:(NSString *)uid title:(NSString *)title callBack:(dataCallBackBlock)callBlock
{
    [self.userManager setThirdCollectionStatus:collectStatus url:url uid:uid title:title callBack:callBlock];
}

- (void)fetchedThirdCollectionListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    [self.userManager fetchedThirdCollectionListWithIndex:index uid:uid callBack:callBlock];
}


@end
