//
//  TopicViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TubeRefreshTableViewController.h"
#import "TubeArticleConst.h"

@interface TopicViewController : TubeRefreshTableViewController

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) FouseType fouseType;
- (instancetype)initTopicViewControllerWithFouseType:(FouseType)fouseType uid:(NSString *)uid;

@end
