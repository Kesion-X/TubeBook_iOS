//
//  TubeUserInfoManager.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeUserInfoManager.h"

@interface TubeUserInfoManager ()

@property (nonatomic, strong) NSMutableDictionary *requestCallBackBlockDir;

@end

@implementation TubeUserInfoManager
{
    NSInteger tag ;
}

- (instancetype)initTubeUserInfoManagerWithSocket:(TubeServerDataSDK *)tubeServer;
{
    self = [super initBaseTubeServerManager:tubeServer];
    if (self) {
        self.requestCallBackBlockDir = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)procotolName
{
    return USER_PROTOCOL;
}
#pragma mark - public
// 获取人物基本信息
- (void)fetchedUserInfoWithUid:(NSString *)uid isSelf:(BOOL)isSelf callBack:(dataCallBackBlock)callBack
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_FETCH_INFO, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_FETCH_INFO stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBack forKey:[USER_FETCH_INFO stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       @(isSelf), @"isSelf",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_FETCH_INFO,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
    
}

// 获取关注的用户列表
- (void)fetchedAttentedUserListWithUid:(NSString *)uid index:(NSInteger)index callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_FETCH_INFO, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_ATTENT_USERLIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_ATTENT_USERLIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       @(index), @"index",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ATTENT_USERLIST,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 获取用户关注用户数
- (void)fetchedUserAttenteUserCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_USER_ATTENT_USER_COUNT, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_USER_ATTENT_USER_COUNT stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_USER_ATTENT_USER_COUNT stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_USER_ATTENT_USER_COUNT,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 获取用户粉丝数
- (void)fetchedUserAttentedCountWithUid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_USER_ATTENTED_COUNT, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_USER_ATTENTED_COUNT stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_USER_ATTENTED_COUNT stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_USER_ATTENTED_COUNT,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 设置关注/取消关注
- (void)setUserAttentWithStatus:(BOOL)isAttent uid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@", __func__, USER_PROTOCOL, USER_SET_ATTENT_STATUS);
    if ([self.requestCallBackBlockDir objectForKey:[USER_SET_ATTENT_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_SET_ATTENT_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       uid, @"uid",
                                       attentUid, @"attentUid",
                                       @(isAttent), @"isAttent", nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_SET_ATTENT_STATUS,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

- (void)fetchedUserAttentStatusWithUid:(NSString *)uid attentUid:(NSString *)attentUid callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@", __func__, USER_PROTOCOL, USER_ATTENT_STATUS);
    if ([self.requestCallBackBlockDir objectForKey:[USER_ATTENT_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_ATTENT_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       uid, @"uid",
                                       attentUid, @"attentUid", nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ATTENT_STATUS,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 获取用户写的文章列表
- (void)fetchedSelfArticleListWithIndex:(NSInteger)index
                                    uid:(NSString *)uid
                            articleType:(UserArticleType)articleType
                               callback:(dataCallBackBlock)callback
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ index:%lu uid:%@", __func__, USER_PROTOCOL, USER_ARTICLE_LIST, index, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_ARTICLE_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callback forKey:[USER_ARTICLE_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       @(articleType), @"articleType",
                                       @(index), @"index",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ARTICLE_LIST,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 获取粉丝列表
- (void)fetchedFansListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_ATTENTED_USER_LIST, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_ATTENTED_USER_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_ATTENTED_USER_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       @(index), @"index",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_ATTENTED_USER_LIST,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 获取自己喜欢的文章列表
- (void)fetchedLikeArticleListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_LIKE_ARTICLE_LIST, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_LIKE_ARTICLE_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_LIKE_ARTICLE_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       @(index), @"index",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_LIKE_ARTICLE_LIST,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

- (void)setUserAvaterWithUid:(NSString *)uid imageUrl:(NSString *)imageUrl callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_SET_AVATER, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_SET_AVATER stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_SET_AVATER stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       uid,@"uid",
                                       imageUrl, @"avater",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_SET_AVATER,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 设置第三方文章收藏状态
- (void)setThirdCollectionStatus:(BOOL)collectStatus url:(NSString *)url uid:(NSString *)uid title:(NSString *)title callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_SET_THIRD_URL_COLLECTION_STATUS, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_SET_THIRD_URL_COLLECTION_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_SET_THIRD_URL_COLLECTION_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       @(collectStatus), @"collectStatus",
                                        title, @"title",
                                        uid, @"uid",
                                        url, @"url",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_SET_THIRD_URL_COLLECTION_STATUS, PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

// 获取收藏第三方文章列表
- (void)fetchedThirdCollectionListWithIndex:(NSInteger)index uid:(NSString *)uid callBack:(dataCallBackBlock)callBlock
{
    tag ++;
    NSLog(@"%s protocol:%@ method:%@ uid:%@", __func__, USER_PROTOCOL, USER_THIRD_COLLECTION_LIST, uid);
    if ([self.requestCallBackBlockDir objectForKey:[USER_THIRD_COLLECTION_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]]) {
        NSLog(@"%s haved request, wait after",__func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBlock forKey:[USER_THIRD_COLLECTION_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",tag]]];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @(tag), @"tag",
                                       @(index), @"index",
                                       uid,@"uid",nil];
    NSLog(@"%s content:%@",__func__,contentDic);
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             USER_PROTOCOL, PROTOCOL_NAME,
                             USER_THIRD_COLLECTION_LIST,PROTOCOL_METHOD,
                             nil];
    NSLog(@"%s head:%@",__func__,headDic);
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

#pragma mark - delegate

- (void)connectioned
{
    
}

- (void)connectionError:(NSError *)err
{
    NSLog(@"%s 链接失败，移除请求操作", __func__);
    [self.requestCallBackBlockDir removeAllObjects];
    
}

- (void)receiveData:(BaseSocketPackage *)pg
{
    NSDictionary *headDic = pg.head.headData;
    NSDictionary *content = pg.content.contentData;
    NSLog(@"%s reveiveData head: %@ tag: %lu",__func__ ,headDic ,[[content objectForKey:@"tag"] integerValue]);
    if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_FETCH_INFO] ) {
        [self callBackToMain:pg method:[USER_FETCH_INFO stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_ATTENT_USERLIST] ) {
        [self callBackToMain:pg method:[USER_ATTENT_USERLIST stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_SET_ATTENT_STATUS] ) {
        [self callBackToMain:pg method:[USER_SET_ATTENT_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_ATTENT_STATUS] ) {
        [self callBackToMain:pg method:[USER_ATTENT_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_ARTICLE_LIST] ) {
        [self callBackToMain:pg method:[USER_ARTICLE_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_USER_ATTENT_USER_COUNT] ) {
        [self callBackToMain:pg method:[USER_USER_ATTENT_USER_COUNT stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_USER_ATTENTED_COUNT] ) {
        [self callBackToMain:pg method:[USER_USER_ATTENTED_COUNT stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_ATTENTED_USER_LIST] ) {
        [self callBackToMain:pg method:[USER_ATTENTED_USER_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_LIKE_ARTICLE_LIST] ) {
        [self callBackToMain:pg method:[USER_LIKE_ARTICLE_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_SET_AVATER] ) {
        [self callBackToMain:pg method:[USER_SET_AVATER stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_SET_THIRD_URL_COLLECTION_STATUS] ) {
        [self callBackToMain:pg method:[USER_SET_THIRD_URL_COLLECTION_STATUS stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_THIRD_COLLECTION_LIST] ) {
        [self callBackToMain:pg method:[USER_THIRD_COLLECTION_LIST stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else {
        NSLog(@"%s not head method work",__func__);
    }

}

- (void)callBackToMain:(BaseSocketPackage *)pg method:(NSString *)method
{
    dispatch_async(dispatch_get_main_queue(), ^{
        dataCallBackBlock callback =[self.requestCallBackBlockDir objectForKey:method];
        NSDictionary *headDic = pg.head.headData;
        NSDictionary *contentDic = pg.content.contentData;
        DataCallBackStatus status = DataCallBackStatusFail;
        NSLog(@"%s dispatch data block, status:%lu, head: %@ tag: %lu.",__func__,status, headDic,[[contentDic objectForKey:@"tag"] integerValue]);
        if ([[contentDic objectForKey:@"status"] isEqualToString:@"success"]) {
            status = DataCallBackStatusSuccess;
        }
        if (callback) {
            callback(status,pg);
        }
        [self.requestCallBackBlockDir removeObjectForKey:method];
    });
}



- (void)disConnection
{
    NSLog(@"%s 失去链接，移除请求操作", __func__);
    [self.requestCallBackBlockDir removeAllObjects];
}

@end
