//
//  TubeWebViewViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TubeWebViewViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSString *url;

- (instancetype)initTubeWebViewViewControllerWithHtml:(NSString *)html;
- (instancetype)initTubeWebViewViewControllerWithUrl:(NSString *)url;
- (void)loadWeb;
- (void)loadWebWithHtml:(NSString *)html;

@end
