//
//  TubeWebViewViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeWebViewViewController.h"
#import "CKMacros.h"

@interface TubeWebViewViewController ()

//@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) NSString *html;
//@property (nonatomic, strong) NSString *url;

@end
//[webView goBack];
//[webView goForward];
//[webView reload];//重载
//[webView stopLoading];//取消载入内容
@implementation TubeWebViewViewController


- (instancetype)initTubeWebViewViewControllerWithUrl:(NSString *)url
{
    self = [super init];
    if ( self ) {
        self.url = url;
    }
    return self;
}

- (instancetype)initTubeWebViewViewControllerWithHtml:(NSString *)html
{
    self = [super init];
    if ( self ) {
        self.html = html;
        
        self.html = [self.html stringByReplacingOccurrencesOfString:@"<span" withString:[NSString stringWithFormat:@"<div style=\"word-wrap:break-word; width:%fpx;\"><span",SCREEN_WIDTH - 10]];
        self.html =  [self.html stringByReplacingOccurrencesOfString:@"/span>" withString:[NSString stringWithFormat:@"/span></div>"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
   // self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [self loadWeb];
}

- (void)loadWeb
{
    if ( self.html ) {
        [self.webView loadHTMLString:self.html baseURL:nil];
    } else if ( self.url ) {
        NSURL* url = [NSURL URLWithString:self.url];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];//加载
    }
}

- (void)loadWebWithHtml:(NSString *)html
{
    self.html = html;
    self.html = [self.html stringByReplacingOccurrencesOfString:@"<span" withString:[NSString stringWithFormat:@"<div style=\"word-wrap:break-word; width:%fpx;\"><span",SCREEN_WIDTH - 10]];
    self.html =  [self.html stringByReplacingOccurrencesOfString:@"/span>" withString:[NSString stringWithFormat:@"/span></div>"]];
    [self.webView loadHTMLString:self.html baseURL:nil];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//
//}



@end
