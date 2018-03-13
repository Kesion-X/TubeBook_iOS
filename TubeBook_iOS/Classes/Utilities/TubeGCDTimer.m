//
//  TubeGCDTimer.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/24.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeGCDTimer.h"

@interface TubeGCDTimer()
@property (nonatomic, strong) NSMutableDictionary *timerContainer;
@property (nonatomic, strong) dispatch_queue_t defaultTimerQueue;
@end

@implementation TubeGCDTimer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaultTimerQueue = dispatch_queue_create("com.meituan.dx.defaultTimerQueue", NULL);
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static TubeGCDTimer *tubeGCDTimer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tubeGCDTimer = [[TubeGCDTimer alloc] init];
    });
    return tubeGCDTimer;
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                                action:(dispatch_block_t)action
{
    if (nil == timerName)
    return;
    
    if (nil == queue)
    queue = _defaultTimerQueue;
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    // timer精度为0.1秒
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;

    dispatch_source_set_event_handler(timer, ^{
        action();
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
    
}

- (void)cancelTimerWithName:(NSString *)timerName
{
    if (!timerName) {
        return;
    }
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}
    
- (void)cancelAllTimer
{
    // Fast Enumeration
    [self.timerContainer enumerateKeysAndObjectsUsingBlock:^(NSString *timerName, dispatch_source_t timer, BOOL *stop) {
        [self.timerContainer removeObjectForKey:timerName];
        dispatch_source_cancel(timer);
    }];
}
    
#pragma mark - Property

- (NSMutableDictionary *)timerContainer
{
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

@end
