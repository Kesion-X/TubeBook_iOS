//
//  BaseTubeServerManager.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "BaseTubeServerManager.h"
#import "TubeLinkManager.h"

@interface BaseTubeServerManager ()
@end

@implementation BaseTubeServerManager

- (instancetype)initBaseTubeServerManager:(TubeServerDataSDK *)tubeServer
{
    self = [super init];
    if (self) {
        self.tubeServer = tubeServer;
        [self.tubeServer addListenerDelegate:self procotolName:[self procotolName]];
    }
    return self;
}

@end
