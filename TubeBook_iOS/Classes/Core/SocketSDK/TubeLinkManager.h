//
//  TubeLinkManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeLink.h"
#import "TubeAddress.h"
#import "TubeLinkManager.h"
#import "ProtocolConst.h"
#import "BaseSocketPackage.h"

typedef NS_ENUM(NSInteger, TubeSocketConnectionStatus)
{
    TubeSocketConnectionStatusNotConnection,
    TubeSocketConnectionStatusConnectioning,
    TubeSocketConnectionStatusConnectioned
};

@protocol TubeDateDelegate <NSObject>

@optional

- (void)connectioned;
- (void)connectionError:(NSError *)err;
- (void)receiveData:(BaseSocketPackage *)pg;
- (void)disConnection;
    
@end

@interface TubeLinkManager : NSObject

- (instancetype)initTubeLinkManager:(NSString *)linkID;
- (void)addListenerDelegate:(id) delegate procotolName:(NSString *)procotolName;
- (void)removeListenerDelegatProcotolName:(NSString *)procotolName;
- (void)connect;
- (void)disconnect;
- (void)disconnectAndWait;
- (void)writeData:(NSData *)data;
- (BOOL)isConnected;

@end
