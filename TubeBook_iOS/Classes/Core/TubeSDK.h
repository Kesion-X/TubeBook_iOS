//
//  TubeSDK.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeServerDataSDK.h"
#import "TubeLoginSDK.h"

@interface TubeSDK : NSObject

@property (nonatomic, strong) TubeServerDataSDK *tubeServerDataSDK;
@property (nonatomic, strong) TubeLoginSDK *tubeLoginSDK;
    
+ (instancetype)sharedInstance;
- (void)connect;
    
@end
