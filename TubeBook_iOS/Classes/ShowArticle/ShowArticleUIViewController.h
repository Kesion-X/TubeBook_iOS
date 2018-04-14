//
//  ShowArticleUIViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubePageViewController.h"

@interface ShowArticleUIViewController : TubePageViewController

- (instancetype)initShowArticleUIViewControllerWithAtid:(NSString *)atid uid:(NSString *)uid;
- (instancetype)initShowArticleUIViewControllerWithAtid:(NSString *)atid uid:(NSString *)uid body:(NSString *)body;

@end
