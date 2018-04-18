//
//  TubeIMSDK.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeIMSDK.h"

@interface TubeIMSDK ()

@property (nonatomic, strong) TubeIMManager *imManager;

@end

@implementation TubeIMSDK

- (instancetype)initTubeIMSDK:(TubeServerDataSDK *)tubeServer
{
    self = [super init];
    if (self) {
        self.imManager = [[TubeIMManager alloc] initTubeIMManagerWithSocket:tubeServer];
    }
    return self;
}

- (void)addNotificationListener:(id <TubeIMNotificationDelegate>)delegate
{
    [self.imManager addNotificationListener:delegate];
}

@end
