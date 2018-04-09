//
//  TagManager.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerDataSDK.h"

typedef void(^tagDataCallBack)(NSInteger status, NSDictionary *data);

@interface TagManager : NSObject

@property (nonatomic, strong) tagDataCallBack tagCallBack;
- (instancetype)initTagManagerWithSocket:(TubeServerDataSDK *)tubeServer;

/**
 *parameters: tagCount 0代表请求所有，n代表请求n个
 */
- (void)requestTagDataWithTagCount:(NSInteger)tagCount tagDataCallBack:(tagDataCallBack)tagDataCallBack;

@end
