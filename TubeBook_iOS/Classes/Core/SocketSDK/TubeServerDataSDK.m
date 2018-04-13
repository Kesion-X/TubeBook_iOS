//
//  TubeServerDataSDK.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeServerDataSDK.h"
#import "TubeLinkManager.h"

@interface TubeServerDataSDK ()

@property (nonatomic, strong) TubeLinkManager *tubeMgr;

@end

@implementation TubeServerDataSDK

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tubeMgr = [[TubeLinkManager alloc] initTubeLinkManager:nil];
    }
    return self;
}

- (void)addListenerDelegate:(id) delegate procotolName:(NSString *)procotolName
{
    [self.tubeMgr addListenerDelegate:delegate procotolName:procotolName];
}
    
- (void)removeListenerDelegatProcotolName:(NSString *)procotolName
{
    [self.tubeMgr removeListenerDelegatProcotolName:procotolName];
}
    
- (void)connect
{
    [self.tubeMgr connect];
}
    
- (void)disconnect
{
    [self.tubeMgr disconnect];
}

- (void)disconnectAndWait
{
    [self.tubeMgr disconnectAndWait];
}

- (void)writeData:(NSData *)data
{
    [self.tubeMgr writeData:data];
}

- (BOOL)isConnected
{
    return [self.tubeMgr isConnected];
}

@end
