//
//  TubeGCDTimer.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/24.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TubeGCDTimer : NSObject

+ (instancetype)sharedInstance;
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action;
- (void)cancelAllTimer;

@end
