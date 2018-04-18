//
//  TubeIMManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTubeServerManager.h"

@protocol TubeIMNotificationDelegate  <NSObject>

// reicve_uid send_uid procotol method title content time
- (void)imNotificationReceiveWithStatus:(DataCallBackStatus)status page:(BaseSocketPackage *)page;

@end

@interface TubeIMManager : BaseTubeServerManager

- (instancetype)initTubeIMManagerWithSocket:(TubeServerDataSDK *)tubeServer;
// notification message
// reicve_uid send_uid procotol method title content time
- (void)addNotificationListener:(id <TubeIMNotificationDelegate>)delegate;

@end
