//
//  TubeIMManager.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeIMManager.h"

@interface TubeIMManager ()

@property (nonatomic, strong) NSMutableDictionary *requestCallBackBlockDir;
@property (nonatomic, weak) id <TubeIMNotificationDelegate> delegate;

@end

@implementation TubeIMManager

- (instancetype)initTubeIMManagerWithSocket:(TubeServerDataSDK *)tubeServer
{
    self = [super initBaseTubeServerManager:tubeServer];
    if (self) {
        self.requestCallBackBlockDir = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (NSString *)procotolName
{
    return IM_PROTOCOL;
}

- (void)addNotificationListener:(id <TubeIMNotificationDelegate>)delegate
{
    self.delegate = delegate;
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
    if ( [[headDic objectForKey:PROTOCOL_METHOD] isEqualToString:IM_NOTIFICATION_MESSAGE] ) {
        if (self.delegate) {
            DataCallBackStatus status = DataCallBackStatusFail;
            if ( [[content objectForKey:@"status"] isEqualToString:@"success"] ) {
                status = DataCallBackStatusSuccess;
            }
            if ( [self.delegate respondsToSelector:@selector(imNotificationReceiveWithStatus:page:)] ) {
                [self.delegate imNotificationReceiveWithStatus:status page:pg];
            }
        }
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
