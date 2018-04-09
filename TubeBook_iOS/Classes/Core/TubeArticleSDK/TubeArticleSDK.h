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
- (void)fetchedArticleTopicTitleListWithIndex:(NSInteger)index uid:(NSString *)uid conditionDic:(NSDictionary *)conditionDic callBack:(dataCallBackBlock)callBack;

@end
