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

- (void)fetchedArticleTopicTitleListWithIndex:(NSInteger)index uid:(NSString *)uid conditionDic:(NSDictionary *)conditionDic callBack:(dataCallBackBlock)callBack;
{
    [self.articleManager fetchedArticleTopicTitleListWithIndex:index uid:uid conditionDic:conditionDic callBack:callBack];
}


@end
