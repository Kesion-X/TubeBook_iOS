//
//  ArticleWebViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeWebViewViewController.h"

@interface ArticleWebViewController : TubeWebViewViewController

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *atid;

- (instancetype)initArticleWebViewControllerWithHtml:(NSString *)html uid:(NSString *)uid atid:(NSString *)atid;
- (instancetype)initArticleWebViewControllerWithHtml:(NSString *)html;
- (instancetype)initArticleWebViewControllerWithUrl:(NSString *)url;

@end
