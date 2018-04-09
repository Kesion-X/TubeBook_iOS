//
//  TagManager.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TagManager.h"
#import "BaseSocketPackage.h"
#import "ProtocolConst.h"
#import "TubeLinkManager.h"

@interface TagManager () <TubeDateDelegate>

@property (nonatomic, strong) TubeServerDataSDK *tubeServer;

@end

@implementation TagManager

- (instancetype)initTagManagerWithSocket:(TubeServerDataSDK *)tubeServer
{
    self = [super init];
    if (self) {
        self.tubeServer = tubeServer;
        [self.tubeServer addListenerDelegate:self procotolName:TAG_PROTOCOL];
    }
    return self;
}

- (void)requestTagDataWithTagCount:(NSInteger)tagCount tagDataCallBack:(tagDataCallBack)tagDataCallBack
{
    self.tagCallBack = tagDataCallBack;
    NSDictionary *contentDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                @(tagCount), @"tagCount",nil];
    NSDictionary *headDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             TAG_PROTOCOL, PROTOCOL_NAME,
                             nil];
    BaseSocketPackage *pg = [[BaseSocketPackage alloc] initWithHeadDic:headDic contentDic:contentDic];
    [self.tubeServer writeData:pg.data];
}

- (void)connectioned
{
    
}

- (void)connectionError:(NSError *)err
{
    
}

- (void)receiveData:(BaseSocketPackage *)pg
{
    
}

- (void)disConnection
{
    
}


@end
