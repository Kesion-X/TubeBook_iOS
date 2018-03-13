//
//  TubeServerDataSDK.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TubeServerDataSDK : NSObject

- (void)addListenerDelegate:(id) delegate procotolName:(NSString *)procotolName;
- (void)removeListenerDelegatProcotolName:(NSString *)procotolName;
- (void)connect;
- (void)disconnect;
- (void)disconnectAndWait;
- (void)writeData:(NSData *)data;
- (BOOL)isConnected;

@end
