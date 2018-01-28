//
//  TubeLink.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeAddress.h"

#define kTIMEOUT 30

@protocol TubeLinkDelegate <NSObject>

@optional
- (void)onConnectingWithLinkID:(NSString *)linkID;
- (void)onConnectedWithLinkID:(NSString *)linkID;
- (void)onConnectWithError:(NSError *)error;
- (void)onDisconnectedWithLinkID:(NSString *)linkID andError:(NSError *)error;
- (void)onReadData:(NSData *)rawData;
- (void)onReadDataError:(NSError *)error;
- (void)onWriteDataError:(NSError *)error;

@end

@interface TubeLink : NSObject

- (BOOL)connect;
- (void)disconnect;
- (void)disconnectAndWait; // 推荐使用
- (void)writeData:(NSData *)data;
- (BOOL)isConnected;

@end
