//
//  TubeArticleSDK.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeArticleManager.h"

@interface TubeArticleSDK : NSObject

- (instancetype)initTubeArticleSDK:(TubeServerDataSDK *)tubeServer;

/*
 * @brief 获取标签
 */
- (void)fetchedArticleTagListWithCount:(NSInteger)count callBack:(dataCallBackBlock)callBack;

/*
 * @brief 添加标签
 */
- (void)addArticleTag:(NSString *)tag callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取专题标题信息列表
 * @parme uid 为空代表所有
 */
- (void)fetchedArticleTopicTitleListWithIndex:(NSInteger)index
                                          uid:(NSString *)uid
                                    fouseType:(FouseType)fouseType
                                 conditionDic:(NSDictionary *)conditionDic
                                     callBack:(dataCallBackBlock)callBack;


/*
 * @brief 上传文章
 * @parme detailDic 为可设内容
 */
- (void)uploadArticleWithTitle:(nonnull NSString *)title atid:(nonnull NSString *)atid uid:(nonnull NSString *)uid detail:(NSDictionary *)detailDic callBack:(dataCallBackBlock)callBack;

/*
 * @brief 设置文章标签
 */
- (void)setArticleTagWithAtid:(nonnull NSString *)atid tags:(NSArray *)tags callBack:(dataCallBackBlock)callBack;

/*
 * @brief 设置文章类别
 */
- (void)setArticleTabWithAtid:(nonnull NSString *)atid articleType:(ArticleType)articleType tabid:(NSInteger)tabid callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取连载标题信息列表
 */
- (void)fetchedArticleSerialTitleListWithIndex:(NSInteger)index
                                           uid:(NSString *)uid
                                     fouseType:(FouseType)fouseType
                                  conditionDic:(NSDictionary *)conditionDic
                                      callBack:(dataCallBackBlock)callBack;

/*
 * @brief 获取专题/连载标题信息列表
 */
- (void)fetchedArticleTopicOrSerialTitleListWithType:(ArticleType)articleType
                                               index:(NSInteger)index
                                                 uid:(NSString *)uid
                                           fouseType:(FouseType)fouseType
                                        conditionDic:(NSDictionary *)conditionDic
                                            callBack:(dataCallBackBlock)callBack;

@end
