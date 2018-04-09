//
//  BaseTubeServerManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/1.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerDataSDK.h"
#import "TubeLinkManager.h"

typedef NS_ENUM(NSInteger, DataCallBackStatus)
{
    DataCallBackStatusSuccess,
    DataCallBackStatusFail
};

typedef void(^dataCallBackBlock)(DataCallBackStatus status,BaseSocketPackage *page);

@interface BaseTubeServerManager : NSObject <TubeDateDelegate>

@property (nonatomic, strong) TubeServerDataSDK *tubeServer;

- (instancetype)initBaseTubeServerManager:(TubeServerDataSDK *)tubeServer;
- (NSString *)procotolName; // 必须实现

@end
