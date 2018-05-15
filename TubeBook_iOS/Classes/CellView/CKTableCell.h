//
//  CKTableCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDataType.h"
#import "CKContent.h"
#import "TubeRefreshTableViewController.h"

@interface CKTableCell : UITableViewCell

@property (nonatomic, strong) CKContent *content;
@property (nonatomic, strong) UIViewController *viewController;

//需要实现
- (instancetype)initWithDateType:(CKDataType *)type;
- (CGFloat)getCellHeight;
+ (CGFloat)getCellHeight:(CKContent *)content;

+ (NSString *)getDequeueId:(CKDataType *)type;

@end
