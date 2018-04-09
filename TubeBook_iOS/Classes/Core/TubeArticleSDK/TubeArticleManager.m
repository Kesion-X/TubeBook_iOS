//
//  TubeArticleManager.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/31.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeArticleManager.h"
#import "ProtocolConst.h"
#import "TubeLinkManager.h"

@interface TubeArticleManager ()

@property (nonatomic, strong) NSMutableDictionary *requestCallBackBlockDir;

@end

@implementation TubeArticleManager


- (instancetype)initTubeArticleManagerWithSocket:(TubeServerDataSDK *)tubeServer;
{
    self = [super initBaseTubeServerManager:tubeServer];
    if (self) {
        self.requestCallBackBlockDir = [[NSMutableDictionary alloc] init];
    }
    return self;
}
// 监听协议的配置
- (NSString *)procotolName
{
    return ARTICLE_PROTOCOL;
}

/*
 * @brief 获取标签
 */
- (void)fetchedArticleTagListWithCount:(NSInteger)count callBack:(dataCallBackBlock)callBack;
{
    NSLog(@"%s protocol:%@ method:%@ count:%ld", __func__, ARTICLE_PROTOCOL, ARTICLE_PROTOCOL_TAG, count);
    if ([self.requestCallBackBlockDir objectForKey:ARTICLE_PROTOCOL_TAG]) {
        NSLog(@"%s haved request fetchedArticleTagListWithCount, wait after", __func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBack forKey:ARTICLE_PROTOCOL_TAG];
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(count), @"tagCount",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_PROTOCOL_TAG,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

- (void)addArticleTag:(NSString *)tag callBack:(dataCallBackBlock)callBack
{
    NSLog(@"%s protocol:%@ method:%@ tag:%@", __func__, ARTICLE_PROTOCOL, ARTICLE_PROTOCOL_ADD_TAG, tag);
    if ([self.requestCallBackBlockDir objectForKey:ARTICLE_PROTOCOL_ADD_TAG]) {
        NSLog(@"%s haved request addArticleTag, wait after", __func__);
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBack forKey:ARTICLE_PROTOCOL_ADD_TAG];
    }
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                tag, @"tag",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_PROTOCOL_ADD_TAG,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

/*
 * @brief 获取专题标题信息列表
 */
- (void)fetchedArticleTopicTitleListWithIndex:(NSInteger)index uid:(NSString *)uid conditionDic:(NSDictionary *)conditionDic callBack:(dataCallBackBlock)callBack;
{
    NSLog(@"%s protocol:%@ method:%@ index:%lu uid:%@", __func__, ARTICLE_PROTOCOL, ARTICLE_TOPIC_TITLE_LIST, index, uid);
    if ([self.requestCallBackBlockDir objectForKey:ArticleTopicTitleList]) {
        NSLog(@"haved request fetchedArticleTopicTitleListWithIndex, wait after");
        return ;
    } else {
        [self.requestCallBackBlockDir setValue:callBack forKey:ArticleTopicTitleList];
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @(index), @"index",
                                uid,@"uid",nil];
    if (conditionDic) {
        [contentDic addEntriesFromDictionary:conditionDic];
    }
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             ARTICLE_PROTOCOL, PROTOCOL_NAME,
                             ARTICLE_TOPIC_TITLE_LIST,PROTOCOL_METHOD,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

/*
 * @brief 获取连载标题信息列表
 */
- (void)fetchedArticleSerialTitleListWithIndex:(NSInteger)index fouseType:(FouseType)fouseType
{
    
}

/*
 * @brief 获取关注的作者列表
 */
- (void)fetchedUserInfoListWithIndex:(NSInteger)index fouseType:(FouseType)fouseType
{
    
}

/*
 * @brief 获取最新文章(普通/专题/连载)列表
 */
- (void)fetchedNewArticleListWithIndex:(NSInteger)index articleType:(ArticleType)articleType fouseType:(FouseType)fouseType
{
    
}

/*
 * @brief 获取最新文章(普通/专题/连载)列表,tabid
 */
- (void)fetchedNewArticleListtWithIndex:(NSInteger)index articleType:(ArticleType)articleType tabid:(NSInteger)tabid fouseType:(FouseType)fouseType
{
    
}

/*
 * @brief 获取推荐文章(普通/专题/连载)列表
 */
- (void)fetchedRecommendArticleListtWithIndex:(NSInteger)index articleType:(ArticleType)articleType fouseType:(FouseType)fouseType
{
    
}

/*
 * @brief 获取推荐文章(普通/专题/连载)列表, tabid
 */
- (void)fetchedRecommendArticleListtWithIndex:(NSInteger)index articleType:(ArticleType)articleType tabid:(NSInteger)tabid fouseType:(FouseType)fouseType
{
    
}

/*
 * @brief 获取文章详细信息
 */
- (void)fetchedArticleContentWithAtid:(NSUInteger)atid
{
    
}

- (void)connectioned
{
    
}

- (void)connectionError:(NSError *)err
{
    
}

- (void)receiveData:(BaseSocketPackage *)pg
{
    NSLog(@"%s receiveData head:%@ content:%@", __func__, pg.head.headData,pg.content.contentData);
    NSDictionary *headDic = pg.head.headData;
    if ([[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:ARTICLE_PROTOCOL_TAG]) {
        [self callBackToMain:pg method:ARTICLE_PROTOCOL_TAG];
    } else if ([[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:ARTICLE_PROTOCOL_ADD_TAG]) {
        [self callBackToMain:pg method:ARTICLE_PROTOCOL_ADD_TAG];
    } else if ([[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:ARTICLE_TOPIC_TITLE_LIST]) {
        [self callBackToMain:pg method:ARTICLE_TOPIC_TITLE_LIST];
    }
}

- (void)callBackToMain:(BaseSocketPackage *)pg method:(NSString *)method
{
    dispatch_async(dispatch_get_main_queue(), ^{
        dataCallBackBlock callback =[self.requestCallBackBlockDir objectForKey:method];
        NSDictionary *contentDic = pg.content.contentData;
        DataCallBackStatus status = DataCallBackStatusFail;
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
    
}

@end
