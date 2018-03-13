//
//  TubeLink.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeLink.h"
#import "GCDAsyncSocket.h"

@interface TubeLink () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) TubeAddress *address;
@property (nonatomic, strong) NSString *linkID;
@property (nonatomic, weak) id<TubeLinkDelegate> delegate;

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) dispatch_queue_t socketQueue;
@property (nonatomic, strong) dispatch_queue_t delegateQueue;

@property (nonatomic,assign) uint32_t tagSeq;

@end

@implementation TubeLink

-(void)dealloc
{
    self.delegate = nil;
    if (self.socket) {
        [self.socket setDelegate:nil];
    }
}
    
- (instancetype)initWithLinkID:(NSString *)linkID address:(TubeAddress *)address delegate:(id<TubeLinkDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.linkID = linkID;
        self.address = address;
        self.delegate = delegate;
        
        
        self.socketQueue = dispatch_queue_create([[NSString stringWithFormat:@"com.kesion.tubeLink.socketQueue.%@", self] UTF8String], nil);
        self.delegateQueue = dispatch_queue_create([[NSString stringWithFormat:@"com.kesion.tubeLink.delegateQueue.%@", self] UTF8String], nil);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_delegateQueue socketQueue:_socketQueue];

    }
    return self;
}

- (BOOL)connect
{
    if (!self.socket.delegate) { //重新连接时需要
        self.socket.delegate = self;
    }
    NSError *err = nil;
    if (!self.address.host || self.address.port == 0) {
        if (self.delegate) {
            err = [NSError errorWithDomain:@"address of host nil or port=0" code:TubeLinkCodeInitDataError userInfo:nil];
            [self.delegate onConnectWithError:err];
        }
        return NO;
    }

    if ([self.socket connectToHost:self.address.host onPort:self.address.port withTimeout:kTIMEOUT error:&err]) {
        if (err) {
            if (self.delegate) {
                [self.delegate onConnectWithError:err];
            }
            return NO;
        }
        if (self.delegate) {
            [self.delegate onConnectingWithLinkID:self.linkID];
        }
        return YES;
    }
    if (self.delegate) {
        err = [NSError errorWithDomain:@"unknown err" code:TubeLinkCodeInitDataError userInfo:nil];
        [self.delegate onConnectWithError:err];
    }
    return NO;
}

- (void)disconnect
{
    [self.socket setDelegate:nil];
    [self.socket disconnect];
    if (self.delegate) {
        [self.delegate onDisconnectedWithLinkID:self.linkID andError:nil];
    }
}

- (void)disconnectAndWait // 推荐使用
{
    [self.socket setDelegate:nil];
    [self.socket disconnectAfterReadingAndWriting];
    if (self.delegate) {
        [self.delegate onDisconnectedWithLinkID:self.linkID andError:nil];
    }
}

- (void)writeData:(NSData *)data
{
    if (data.length == 0) {
        NSError *err = [NSError errorWithDomain:@"data length = 0 " code:TubeLinkCodeInitDataError userInfo:nil];
        [self.delegate onWriteDataError:err];
        return;
    }

    if ([self isConnected]) {
        [self.socket writeData:data withTimeout:10.0f tag:0];
    } else {
        NSError *err = [NSError errorWithDomain:@"socket isn't connection" code:TubeLinkCodeNotConnection userInfo:nil];
        [self.delegate onWriteDataError:err];
    }
}

- (BOOL)isConnected
{
    return [self.socket isConnected];
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (self.delegate) {
        [self.delegate onConnectedWithLinkID:self.linkID];
    }
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (self.delegate) {
        [self.delegate onDisconnectedWithLinkID:self.linkID andError:err];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (self.delegate) {
        [self.delegate onReadData:data];
    }
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    if (self.delegate) {
        NSError *err = [NSError errorWithDomain:@"write time out" code:TubeLinkCodeTimeOut userInfo:nil];
        [self.delegate onWriteDataError:err];
    }
    return kTIMEOUT;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    if (self.delegate) {
        NSError *err = [NSError errorWithDomain:@"write time out" code:TubeLinkCodeTimeOut userInfo:nil];
        [self.delegate onReadDataError:err];
    }
    return kTIMEOUT;
}


@end
