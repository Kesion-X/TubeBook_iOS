//
//  UserLikeArticleViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/8.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRefreshTableViewController.h"

@interface UserLikeArticleViewController : TubeRefreshTableViewController

@property (nonatomic, strong) NSString *uid;
- (instancetype)initUserLikeArticleViewControllerWithUid:(NSString *)uid;

@end
