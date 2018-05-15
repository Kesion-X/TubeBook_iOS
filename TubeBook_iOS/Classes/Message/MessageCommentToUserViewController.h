//
//  MessageCommentToUserViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRefreshTableViewController.h"
#import "CKContent.h"
#import "UserCommentContent.h"

typedef void(^controllerDisMissBlock)(void);

@interface MessageCommentToUserViewController : TubeRefreshTableViewController

@property (nonatomic, strong) UserCommentContent *content;

@property (nonatomic, strong) controllerDisMissBlock dismissCompletionBlock;

- (instancetype)initMessageCommentToUserViewControllerWithContent:(UserCommentContent *)content;


@end
