//
//  TubeArticleSDK.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeArticleSDK.h"

@interface TubeArticleSDK ()

@property (nonatomic, strong) TubeArticleManager *articleManager;

@end

@implementation TubeArticleSDK

- (instancetype)initTubeArticleSDK:(TubeServerDataSDK *)tubeServer
{
    self = [super init];
    if (self) {
        self.articleManager = [[TubeArticleManager alloc] initTubeArticleManagerWithSocket:tubeServer];
    }
    return self;
}

- (void)fetchedArticleTagListWithCount:(NSInteger)count callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleTagListWithCount:count callBack:callBack];
}

- (void)addArticleTag:(NSString *)tag callBack:(dataCallBackBlock)callBack
{
    [self.articleManager addArticleTag:tag callBack:callBack];
}

- (void)fetchedArticleTopicTitleListWithIndex:(NSInteger)index uid:(NSString *)uid fouseType:(FouseType)fouseType conditionDic:(NSDictionary *)conditionDic callBack:(dataCallBackBlock)callBack
{
    [self.articleManager fetchedArticleTopicTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
}

/*
 * @brief 上传文章
 * @parme detailDic 为可设内容
 */
- (void)uploadArticleWithTitle:(nonnull NSString *)title atid:(nonnull NSString *)atid uid:(nonnull NSString *)uid detail:(NSDictionary *)detailDic callBack:(dataCallBackBlock)callBack
{
    [self.articleManager uploadArticleWithTitle:title atid:atid uid:uid detail:detailDic callBack:callBack];
}

/*
 * @brief 设置文章标签
 */
- (void)setArticleTagWithAtid:(nonnull NSString *)atid tags:(NSArray *)tags callBack:(dataCallBackBlock)callBack;

{
    [self.articleManager setArticleTagWithAtid:atid tags:tags callBack:callBack];
}

/*
 * @brief 设置文章类别
 */
- (void)setArticleTabWithAtid:(nonnull NSString *)atid articleType:(ArticleType)articleType tabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack
{
    [self.articleManager setArticleTabWithAtid:atid articleType:articleType tabid:tabid callBack:callBack];
}

/*
 * @brief 获取连载标题信息列表
 */
- (void)fetchedArticleSerialTitleListWithIndex:(NSInteger)index
                                           uid:(NSString *)uid
                                     fouseType:(FouseType)fouseType
                                  conditionDic:(NSDictionary *)conditionDic
                                      callBack:(dataCallBackBlock)callBack{
    [self.articleManager fetchedArticleSerialTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
}

/*
 * @brief 获取专题/连载标题信息列表
 */
- (void)fetchedArticleTopicOrSerialTitleListWithType:(ArticleType)articleType
                                               index:(NSInteger)index
                                                 uid:(NSString *)uid
                                           fouseType:(FouseType)fouseType
                                        conditionDic:(NSDictionary *)conditionDic
                                            callBack:(dataCallBackBlock)callBack
{
    if ( articleType == ArticleTypeTopic ) {
        [self fetchedArticleTopicTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
    } else if ( articleType == ArticleTypeSerial ) {
        [self fetchedArticleSerialTitleListWithIndex:index uid:uid fouseType:fouseType conditionDic:conditionDic callBack:callBack];
    }
}


@end
