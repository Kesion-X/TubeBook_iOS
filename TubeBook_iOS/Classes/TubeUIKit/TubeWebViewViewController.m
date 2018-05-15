//
//  TubeWebViewViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeWebViewViewController.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "TubeNavigationUITool.h"
#import "TubeSDK.h"
#import "TubeAlterCenter.h"

@interface TubeWebViewViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *collectBt;
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
        self.html = [self.html stringByReplacingOccurrencesOfString:@"<img " withString:[NSString stringWithFormat:@"<img style=\"margin-left:10px;margin-left:10px; width:%fpx;\"",SCREEN_WIDTH - 35]];
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

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.url) {
        [self.navigationController.navigationBar setBarTintColor:HEXCOLOR(0xffffff)];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s ",__func__);
    [self.titleLable removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    if (self.navigationController.viewControllers.count > 1){
        self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
        self.navigationItem.rightBarButtonItem = [TubeNavigationUITool itemWithIconImage:nil title:@"收藏" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(collect)];
        [self.navigationController.navigationBar addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navigationController.navigationBar).offset(80);
            make.right.equalTo(self.navigationController.navigationBar).offset(-80);
            make.centerY.equalTo(self.navigationController.navigationBar);
        }];
    }
}

- (void)back
{
    NSString *js1 = @"document.URL";
    NSString *URL = [self.webView stringByEvaluatingJavaScriptFromString:js1];
    if (![self.url isEqualToString:URL]) {
        NSLog(@"%s web view go back",__func__);
        [self.webView goBack];
        return;
    }
    if (self.navigationController.viewControllers.count > 1) {
        NSLog(@"%s pop view controller",__func__);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"%s dismiss view controller",__func__);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)collect
{
    NSString *url = [self.webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    [[TubeSDK sharedInstance].tubeUserSDK setThirdCollectionStatus:YES url:url uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] title:title callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"收藏成功！" duration:1.0f];
        }
    }];
}

- (void)loadWeb
{
    if (self.html) {
        [self.webView loadHTMLString:self.html baseURL:nil];
    } else if (self.url) {
        [self.navigationController.navigationBar setBarTintColor:HEXCOLOR(0xededed)];
        self.webView.delegate = self;
        NSURL* url = [NSURL URLWithString:self.url];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];//加载
    }
}

- (void)loadWebWithHtml:(NSString *)html
{
    self.html = html;
    self.html = [self.html stringByReplacingOccurrencesOfString:@"<span" withString:[NSString stringWithFormat:@"<div style=\"word-wrap:break-word; width:%fpx;\"><span",SCREEN_WIDTH - 10]];
    self.html = [self.html stringByReplacingOccurrencesOfString:@"<img " withString:[NSString stringWithFormat:@"<img style=\"margin-left:10px;margin-left:10px; width:%fpx;\"",SCREEN_WIDTH - 35]];
    self.html =  [self.html stringByReplacingOccurrencesOfString:@"/span>" withString:[NSString stringWithFormat:@"/span></div>"]];
    [self.webView loadHTMLString:self.html baseURL:nil];
}


#pragma mark - delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
        if (title && title.length>0) {
            self.titleLable.text = title;
        }
    });
    
}


#pragma mark - get
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        _titleLable.text = self.title;
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}



@end
