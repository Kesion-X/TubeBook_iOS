//
//  TubeSearchTableViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRefreshTableViewController.h"
#import "CKContent.h"
#import "TubeArticleConst.h"

typedef NS_ENUM(NSInteger, TubeSearchType)
{
    TubeSearchTypeTopicTitle = 0x00001, // 专题标题
    TubeSearchTypeSerialTitle = 0x0010  // 连载标题
};

typedef void(^callBackSelectedContentBlock)(CKContent *content);

@interface TubeSearchTableViewController : TubeRefreshTableViewController

@property (nonatomic, assign) TubeSearchType searchType;
@property (nonatomic, assign) FouseType fouseType;
- (instancetype)initTubeSearchTableViewControllerWithType:(TubeSearchType)searchType contentCallBack:(callBackSelectedContentBlock)contentCallBackBlock;
- (instancetype)initTubeSearchTableViewControllerWithType:(TubeSearchType)searchType fouseType:(FouseType)fouse contentCallBack:(callBackSelectedContentBlock)contentCallBackBlock;

@end
