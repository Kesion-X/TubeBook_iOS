//
//  TubeUserInfoManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "BaseTubeServerManager.h"

@interface TubeUserInfoManager : BaseTubeServerManager

// 获取人物基本信息
- (void)fetchedUserInfo:(NSString *)uid isSelf:(BOOL)isSelf;
// 获取关注的用户列表
- (void)fetchedAttentedUserList:(NSString *)uid;
// 获取粉丝列表
- (void)fetchedFansList:(NSString *)uid;
// 获取自己写的文章列表
- (void)fetchedSelfArticleList:(NSString *)uid;
// 获取自己看过的文章列表
- (void)fetchedReviewArticleList:(NSString *)uid;
// 获取自己喜欢的文章列表
- (void)fetchedLikeArticleList:(NSString *)uid;
// 获取自己关注的专题列表
- (void)fetchedAttentedTopicList:(NSString *)uid;
// 获取自己关注的连载列表
- (void)fetchedAttentedSerialList:(NSString *)uid;

@end
