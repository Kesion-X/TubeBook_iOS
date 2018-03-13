//
//  TubeLoginSDK.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeLoginSDK.h"
#import "LoginManager.h"

@interface TubeLoginSDK ()
    
@property (nonatomic, strong) LoginManager *logMrg;
@property (nonatomic, weak) id<TubeLoginDelegate> delegate;
    
@end

@implementation TubeLoginSDK

- (instancetype)initTubeLoginSDK:(TubeServerDataSDK *)tubeServer;
{
    self = [super init];
    if (self) {
        self.logMrg = [[LoginManager alloc] initLoginManager:tubeServer];
    }
    return self;
}

- (void)login:(NSString *)account pass:(NSString *)pass
{
    [self.logMrg login:account pass:pass];
}
    
- (void)addListener:(id<TubeLoginDelegate>) delegate
{
    [self.logMrg addListener:delegate];
}
    
@end
