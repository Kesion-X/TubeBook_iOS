//
//  LoginManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerDataSDK.h"

@protocol TubeLoginDelegate <NSObject>
    
- (void)loginSuccess:(NSDictionary *)message;
- (void)loginFail:(NSDictionary *)message;
    
@end

@interface LoginManager : NSObject

- (instancetype)initLoginManager:(TubeServerDataSDK *)tubeServer;
- (void)login:(NSString *)account pass:(NSString *)pass;
- (void)addListener:(id<TubeLoginDelegate>) delegate;
    
@end
