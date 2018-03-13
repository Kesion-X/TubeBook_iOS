//
//  TubeLoginSDK.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerDataSDK.h"
#import "LoginManager.h"

@interface TubeLoginSDK : NSObject
    
- (instancetype)initTubeLoginSDK:(TubeServerDataSDK *)tubeServer;
- (void)login:(NSString *)account pass:(NSString *)pass;
- (void)addListener:(id<TubeLoginDelegate>) delegate;
    
@end
