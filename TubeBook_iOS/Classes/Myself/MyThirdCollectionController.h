//
//  MyThirdCollectionController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRefreshTableViewController.h"

@interface MyThirdCollectionController : TubeRefreshTableViewController

@property (nonatomic, strong) NSString *uid;

- (instancetype)initMyThirdCollectionControllerWithUid:(NSString *)uid;

@end
