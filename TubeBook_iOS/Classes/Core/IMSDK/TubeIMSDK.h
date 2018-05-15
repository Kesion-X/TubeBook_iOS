//
//  TubeIMSDK.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeIMManager.h"

@interface TubeIMSDK : NSObject

- (instancetype)initTubeIMSDK:(TubeServerDataSDK *)tubeServer;

- (void)addNotificationListener:(id <TubeIMNotificationDelegate>)delegate;
- (void)removeNotificationListener:(id <TubeIMNotificationDelegate>)delegate;

@end
