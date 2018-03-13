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

@end

@implementation TubeLinkManager
{
    NSInteger connectionCount;
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
        connectionCount = 0;
        self.linkID = linkID;
        self.link = [[TubeLink alloc] initWithLinkID:linkID address:self.address delegate:self];
        self.tubeConnectManagerQueue = dispatch_queue_create("com.kesion.sdk.queue.connect", NULL);
        self.tubeDataQueue = dispatch_queue_create("com.kesion.sdk.queue.data", NULL);
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
        [self.link connect];
    });
}
- (void)disconnect
{
    dispatch_async(self.tubeConnectManagerQueue, ^{
        [self.link disconnect];
    });
}
- (void)disconnectAndWait // 推荐使用
{
    dispatch_async(self.tubeConnectManagerQueue, ^{
        [self.link disconnectAndWait];
    });
}

- (void)writeData:(NSData *)data
{
    dispatch_async(self.tubeDataQueue, ^{
        [self.link writeData:data];
    });
}

- (BOOL)isConnected
{
    return  [self.link isConnected];
}

#pragma mark - TubeLinkDelegate
- (void)onConnectingWithLinkID:(NSString *)linkID
{
    
}

- (void)onConnectedWithLinkID:(NSString *)linkID
{
    connectionCount = 0;
    [self dispatchConnected];
}

- (void)onConnectWithError:(NSError *)error
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
    [self reConnection];
}
- (void)onDisconnectedWithLinkID:(NSString *)linkID andError:(NSError *)error
{
    if (error) {
        [self reConnection];
    }
    [self dispatchDisConnection];
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
    if (connectionCount == 3) {
        connectionCount = 0;
        // 网络不好，请调整网络，请稍后再试
        NSError *err = [NSError errorWithDomain:@"网络不好，请调整网络，请稍后再试" code:TubeLinkCodeTimeOut userInfo:nil];
        [self dispatchConnectionError:err];
        [self disconnect];
        self.link = nil;
        self.link = [[TubeLink alloc] initWithLinkID:self.linkID address:self.address delegate:self];
        return;
    }
    connectionCount++;
    [self disconnect];
    self.link = nil;
    self.link = [[TubeLink alloc] initWithLinkID:self.linkID address:self.address delegate:self];
    [self connect];
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
