//
//  ArticleWebViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "ArticleWebViewController.h"
#import "InfoDescriptionView.h"

@interface ArticleWebViewController ()

@property (nonatomic, strong) InfoDescriptionView *infoView;

@end

@implementation ArticleWebViewController

- (instancetype)initArticleWebViewControllerWithHtml:(NSString *)html
{
    self = [super initTubeWebViewViewControllerWithHtml:html];
    if (self) {
        
    }
    return self;
}
- (instancetype)initArticleWebViewControllerWithUrl:(NSString *)url
{
    self = [super initTubeWebViewViewControllerWithUrl:url];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoView = [[InfoDescriptionView alloc] initInfoDescriptionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeArticle]) infoType:InfoDescriptionTypeArticle];
    [self.view addSubview:self.infoView];
    self.webView.frame = CGRectMake(0, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeArticle] , SCREEN_WIDTH, SCREEN_HEIGHT -[InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeArticle]);
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
