//
//  DetialArticleListViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TubeRefreshTableViewController.h"
#import "DetailViewController.h"

@interface DetialArticleListViewController : TubeRefreshTableViewController

@property (nonatomic, assign) TubeDetailType type;
@property (nonatomic, assign) NSInteger tabid;
- (instancetype)initDetialArticleListViewControllerWithDetailType:(TubeDetailType)type tabid:(NSInteger)tabid;

@end
