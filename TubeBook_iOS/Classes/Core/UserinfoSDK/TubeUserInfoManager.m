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
        NSLog(@"haved request fetchedUserInfoWithUid, wait after");
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
        NSLog(@"haved request fetchedUserInfoWithUid, wait after");
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
    NSLog(@"%s receiveData head:%@ content:%@", __func__, pg.head.headData,pg.content.contentData);
    NSDictionary *headDic = pg.head.headData;
    NSDictionary *content = pg.content.contentData;
    if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_FETCH_INFO] ) {
        [self callBackToMain:pg method:[USER_FETCH_INFO stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
    } else if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:USER_ATTENT_USERLIST] ) {
        [self callBackToMain:pg method:[USER_ATTENT_USERLIST stringByAppendingString:[NSString stringWithFormat:@"%lu",[[content objectForKey:@"tag"] integerValue]]]];
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
    NSLog(@"%s 失去链接，移除请求操作", __func__);
    [self.requestCallBackBlockDir removeAllObjects];
}

@end
