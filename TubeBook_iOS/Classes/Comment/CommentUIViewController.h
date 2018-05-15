//
//  CommentUIViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRefreshTableViewController.h"

typedef NS_ENUM(NSInteger, CommentType)
{
    CommentTypeArticle = 1,
    CommentTypeUser,
};

@interface CommentUIViewController : TubeRefreshTableViewController

@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, strong) NSString *autorUid;
@property (nonatomic, strong) NSString *atid;

- (instancetype)initCommentUIViewControllerWithAutorUid:(NSString *)uid atid:(NSString *)atid commentType:(CommentType)commentType;

@end
