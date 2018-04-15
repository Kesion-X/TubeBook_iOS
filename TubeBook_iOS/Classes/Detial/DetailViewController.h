//
//  DetailViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TubePageViewController.h"

typedef NS_ENUM(NSInteger, TubeDetailType)
{
    TubeDetailTypeTopic,
    TubeDetailTypeSerial,
    TubeDetailTypeUser
};

@interface DetailViewController : TubePageViewController

@property (nonatomic, assign) TubeDetailType tubeDetailType;
@property (nonatomic, assign) NSInteger tabid;
@property (nonatomic, assign) NSString *uid;
- (instancetype)initTopicDetailViewControllerWithTabid:(NSInteger)tabid uid:(NSString *)uid;
- (instancetype)initSerialDetailViewControllerWithTabid:(NSInteger)tabid uid:(NSString *)uid;
- (instancetype)initUserDetailViewControllerWithUid:(NSString *)uid;

@end
