//
//  TubeLinkManager.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TubeLinkManager.h"
#import "TubeLink.h"
#import "TubeAddress.h"
#import "TubeLinkManager.h"
#import "ProtocolConst.h"
#import "BaseSocketPackage.h"

@interface TubeLinkManager () <TubeLinkDelegate>

@property (nonatomic, strong) dispatch_queue_t tubeConnectManagerQueue;
@property (nonatomic, strong) dispatch_queue_t tubeDataQueue;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic, strong) TubeLink *link;
@property (nonatomic, strong) TubeAddress *address;
@property (atomic, strong) NSMutableData *bufferData;
@property (nonatomic, strong) NSString *linkID;
@property (nonatomic, strong) NSMutableDictionary *delegateDictionary;
@property (nonatomic, strong) NSMutableArray *waitWorkBlock;
@property (nonatomic, assign) TubeSocketConnectionStatus socketConnectionStatus;

@end

@implementation TubeLinkManager
{
    NSInteger connectionCount;
    BOOL checkReConnectioning; // 防止每次请求都重连
}
    
- (void)dealloc
{
    for (NSString *key in [self.delegateDictionary allKeys]) {
        [self.delegateDictionary removeObjectForKey:key];
    }
}

- (instancetype)initTubeLinkManager:(NSString *)linkID
{
    self = [super init];
    if (self) {
        self.socketConnectionStatus = TubeSocketConnectionStatusNotConnection;
        connectionCount = 0;
        self.linkID = linkID;
        self.link = [[TubeLink alloc] initWithLinkID:linkID address:self.address delegate:self];
        self.tubeConnectManagerQueue = dispatch_queue_create("com.kesion.sdk.queue.connect", NULL);
        self.tubeDataQueue = dispatch_queue_create("com.kesion.sdk.queue.data", NULL);
        self.waitWorkBlock = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addListenerDelegate:(id) delegate procotolName:(NSString *)procotolName
{
    [self.delegateDictionary setObject:delegate forKey:procotolName];
}

- (void)removeListenerDelegatProcotolName:(NSString *)procotolName
{
    [self.delegateDictionary removeObjectForKey:procotolName];
}

- (void)connect
{
    self.bufferData = [[NSMutableData alloc] init];
    dispatch_async(self.tubeConnectManagerQueue, ^{
        if (self.socketConnectionStatus == TubeSocketConnectionStatusNotConnection) { // 防止重复连接
            NSLog(@"%s 发起连接！",__func__);
            [self.link connect];
            self.socketConnectionStatus = TubeSocketConnectionStatusConnectioning;
        }
    });
}
- (void)disconnect
{
    dispatch_async(self.tubeConnectManagerQueue, ^{
        self.socketConnectionStatus = TubeSocketConnectionStatusNotConnection;
        [self.link disconnect];
    });
}
- (void)disconnectAndWait // 推荐使用
{
    dispatch_async(self.tubeConnectManagerQueue, ^{
        self.socketConnectionStatus = TubeSocketConnectionStatusNotConnection;
        [self.link disconnectAndWait];
    });
}

- (void)writeData:(NSData *)data
{
    if ([self isConnected]) {
        dispatch_async(self.tubeDataQueue, ^{
            [self.link writeData:data];
        });
    } else {
        dispatch_block_t block =  ^{
            [self.link writeData:data];
        };
        [self.waitWorkBlock addObject:block];

        if (self.socketConnectionStatus == TubeSocketConnectionStatusNotConnection && !checkReConnectioning) {
            NSLog(@"socket还未连接！开启重连");
            checkReConnectioning = YES;
            [self reConnection];
        }

    }
}

- (BOOL)isConnected
{
    return  [self.link isConnected];
}

#pragma mark - TubeLinkDelegate
- (void)onConnectingWithLinkID:(NSString *)linkID
{
    NSLog(@"%s 正在连接！",__func__);
    self.socketConnectionStatus = TubeSocketConnectionStatusConnectioning;
}

- (void)onConnectedWithLinkID:(NSString *)linkID
{
    NSLog(@"%s 已连接！",__func__);
    @synchronized (self) {
        if ( self.waitWorkBlock.count > 0 ) {
            NSLog(@"重连后重新发出请求！");
            for (long i = self.waitWorkBlock.count-1; i>=0 ; --i){
                dispatch_block_t block = [self.waitWorkBlock objectAtIndex:i];
                dispatch_async(self.tubeDataQueue, block);
                [self.waitWorkBlock removeObject:block];
            }
        }
    }
    checkReConnectioning = NO;
    self.socketConnectionStatus = TubeSocketConnectionStatusConnectioned;
    connectionCount = 0;
    [self dispatchConnected];
}

- (void)onConnectWithError:(NSError *)error
{
    self.socketConnectionStatus = TubeSocketConnectionStatusNotConnection;
    if (error) {
        switch (error.code) {
            case TubeLinkCodeInitDataError:
            {
                break;
            }
            case TubeLinkCodeTimeOut:
            {
                
                break;
            }
            case TubeLinkCodeNotConnection:
            {
                break;
            }
            default:
                break;
        }
    }
    NSLog(@"%s 发生连接错误，正尝试重连！",__func__);
    [self reConnection];
}
- (void)onDisconnectedWithLinkID:(NSString *)linkID andError:(NSError *)error
{
    self.socketConnectionStatus = TubeSocketConnectionStatusNotConnection;
    if (error) {
        NSLog(@"%s 发生连接错误，正尝试重连！",__func__);
        [self reConnection];
        [self dispatchDisConnection];
        return ;
    }
    [self dispatchDisConnection];
    NSLog(@"%s 断开链接或链接失败！",__func__);
}

- (void)onReadData:(NSData *)rawData
{
    [self.bufferData appendBytes:rawData.bytes length:rawData.length];
    Byte *buffer = (Byte *)[self.bufferData bytes];
    NSUInteger bufferLength = [self.bufferData length];
    while (bufferLength > SOCKET_LENGTH_BYTE_SIZE) {
//        NSInteger length = (buffer[0] << 24) | (buffer[1] << 16) | (buffer[2] << 8) | (buffer[3]);
//        NSLog(@"data length: %d",length);
        int length = 0;
        [self.bufferData getBytes: &length length: sizeof(length)];
        NSLog(@"data length: %d",length);
        if (length < SOCKET_LENGTH_BYTE_SIZE || length > kMaxPacketSize){
            //重新登录
            [self reConnection];
            bufferLength = 0;
            break;
        }
        
        if (bufferLength >= (SOCKET_LENGTH_BYTE_SIZE + length)) {
            NSData *data = [NSData dataWithBytes:buffer length:(length + SOCKET_LENGTH_BYTE_SIZE)];
            bufferLength -= (SOCKET_LENGTH_BYTE_SIZE + length);
            buffer += (SOCKET_LENGTH_BYTE_SIZE + length);
            [self dispatchData:data];
        } else {
            break;
        }
    }
    
    if (bufferLength > 0) {
        [self.bufferData setData:[[NSData alloc] initWithBytes:buffer length:bufferLength]];
    } else {
        self.bufferData = [[NSMutableData alloc] init];
    }

}

- (void)onReadDataError:(NSError *)error
{
    if (error) {
        switch (error.code) {
            case TubeLinkCodeInitDataError:
            {

                break;
            }
            case TubeLinkCodeTimeOut:
            {
                
                break;
            }
            case TubeLinkCodeNotConnection:
            {
                break;
            }
            default:
                break;
        }
    }
    NSLog(@"%s 读取失败，正尝试重连！",__func__);
    [self reConnection];
}

- (void)onWriteDataError:(NSError *)error
{
    if (error) {
        switch (error.code) {
            case TubeLinkCodeInitDataError:
            {
                break;
            }
            case TubeLinkCodeTimeOut:
            {
                
                break;
            }
            case TubeLinkCodeNotConnection:
            {
                break;
            }
            default:
                break;
        }
    }
    NSLog(@"%s 请求失败，正尝试重连，重发请求！",__func__);
    [self reConnection];
}

#pragma mark - private
- (void)dispatchData:(NSData *)data
{
    dispatch_async(self.tubeDataQueue , ^{
       // NSLog(@"KESION %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithData:data];
        NSString *procotolName = [pg.head getProcotolName];
        id<TubeDateDelegate> delegate = [self.delegateDictionary objectForKey:procotolName];
        if (delegate && [delegate respondsToSelector:@selector(receiveData:)]) {
            [delegate receiveData:pg];
        }
    });
}

- (void)reConnection
{
    @synchronized (self) {
        if (connectionCount >= 3) {
            checkReConnectioning = NO;
            connectionCount = 0;
            // 网络不好，请调整网络，请稍后再试
            NSError *err = [NSError errorWithDomain:@"网络不好，请调整网络，请稍后再试" code:TubeLinkCodeTimeOut userInfo:nil];
            NSLog(@"%s 3次重连失败，网络不好，请调整网络，请稍后再试！",__func__);
            if (self.waitWorkBlock.count>0) {
                NSLog(@"%s 网络不好，清除剩余请求操作！",__func__);
                [self.waitWorkBlock removeAllObjects];
            }
            [self dispatchConnectionError:err];
            [self disconnect];
            self.link = nil;
            self.link = [[TubeLink alloc] initWithLinkID:self.linkID address:self.address delegate:self];
            return;
        }
    }
    // 10秒后发起重连
     if (self.socketConnectionStatus == TubeSocketConnectionStatusNotConnection) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), self.tubeConnectManagerQueue, ^{
            if (self.socketConnectionStatus == TubeSocketConnectionStatusNotConnection) {
                NSLog(@"%s 发起重连！",__func__);
                connectionCount++;
                [self disconnect];
                self.link = nil;
                self.link = [[TubeLink alloc] initWithLinkID:self.linkID address:self.address delegate:self];
                [self connect];
            }
        });
     }
}
    
- (void)dispatchConnected
{
    for (NSString *key in [self.delegateDictionary allKeys]) {
        id<TubeDateDelegate> delegate = [self.delegateDictionary objectForKey:key];
        if (delegate && [delegate respondsToSelector:@selector(connectioned)]) {
            [delegate connectioned];
        }
    }
}
    
- (void)dispatchConnectionError:(NSError *)err
{
    for (NSString *key in [self.delegateDictionary allKeys]) {
        id<TubeDateDelegate> delegate = [self.delegateDictionary objectForKey:key];
        if (delegate && [delegate respondsToSelector:@selector(connectionError:)]) {
            [delegate connectionError:err];
        }
    }
}
    
- (void)dispatchDisConnection
{
    for (NSString *key in [self.delegateDictionary allKeys]) {
        id<TubeDateDelegate> delegate = [self.delegateDictionary objectForKey:key];
        if (delegate && [delegate respondsToSelector:@selector(disConnection)]) {
            [delegate disConnection];
        }
    }
}

- (TubeAddress *)address
{
    if (!_address) {
        _address = [[TubeAddress alloc] initWithHost:@"127.0.0.1" andPort:8080];
    }
    return _address;
}

- (NSMutableDictionary *)delegateDictionary
{
    if (!_delegateDictionary) {
        _delegateDictionary = [[NSMutableDictionary alloc] init];
    }
    return _delegateDictionary;
}

@end
