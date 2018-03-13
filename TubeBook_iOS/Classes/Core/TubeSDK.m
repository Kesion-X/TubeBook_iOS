//
//  TubeSDK.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeSDK.h"

@interface TubeSDK ()

@end

@implementation TubeSDK

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tubeServerDataSDK = [[TubeServerDataSDK alloc] init];
        self.tubeLoginSDK = [[TubeLoginSDK alloc] initTubeLoginSDK:self.tubeServerDataSDK];
    }
    return self;
}
    
+ (instancetype)sharedInstance
{
    static TubeSDK *tubeSDK = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tubeSDK = [[TubeSDK alloc] init];
    });
    return tubeSDK;
}

- (void)connect
{
    [self.tubeServerDataSDK connect];
}
    
@end
