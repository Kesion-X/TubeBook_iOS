//
//  ArticleWebViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "ArticleWebViewController.h"
#import "InfoDescriptionView.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "TubeAlterCenter.h"
#import "DetailViewController.h"
#import "TubeUIImageView.h"

@interface ArticleWebViewController ()

@property (nonatomic, strong) InfoDescriptionView *infoView;

@end
@implementation ArticleWebViewController


- (instancetype)initArticleWebViewControllerWithHtml:(NSString *)html uid:(NSString *)uid atid:(NSString *)atid
{
    self = [self initArticleWebViewControllerWithHtml:html];
    if ( self ) {
        self.uid = uid;
        self.atid = atid;
    }
    return self;
}

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
    if (self.atid && self.uid) {
        self.infoView = [[InfoDescriptionView alloc] initInfoDescriptionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeArticle]) infoType:InfoDescriptionTypeArticle];
        [self.view addSubview:self.infoView];
        self.webView.frame = CGRectMake(0, [InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeArticle] , SCREEN_WIDTH, SCREEN_HEIGHT -[InfoDescriptionView getViewHeightWithInfotype:InfoDescriptionTypeArticle] - 64);
        [self.view layoutIfNeeded];
        if ( !self.html ) {
            @weakify(self);
            [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleContentWithAtid:self.atid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
                @strongify(self);
                if ( status == DataCallBackStatusSuccess ) {
                    NSDictionary *content = page.content.contentData;
                    NSDictionary *info = [content objectForKey:@"detailInfo"];
                    NSString *body = [info objectForKey:@"body"];
                    NSInteger time = [[info objectForKey:@"createtime"] integerValue];
                    NSString *userid = [info objectForKey:@"userid"];
                    [self.infoView setUid:userid];
                    [self.infoView setInfoTime:[TimeUtil getDateWithTime:time]];
                    [self loadWebWithHtml:body];
                    [self.infoView.infoTitleLable setText:[info objectForKey:@"title"]];
                    [self requestUserInfo:userid];
       
                }
            }];
        }
        [self.infoView setActionInfoImageWithTarget:self action:@selector(infoImageClick:)];
        [self.infoView setActionForLikeButtonWithTarget:self action:@selector(likeClick)];
    }
    [self requestLikeStatus];
}

- (void)infoImageClick:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    TubeUIImageView *infoView = (TubeUIImageView *)[singleTap view];
    NSString *uid = infoView.uid;
    [self.navigationController pushViewController:[[DetailViewController alloc] initUserDetailViewControllerWithUid:uid] animated:YES];
}

- (void)requestUserInfo:(NSString *)uid;
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedUserInfoWithUid:uid isSelf:NO callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            NSDictionary *userinfo = [content objectForKey:@"userinfo"];
            NSString *avatarUrl = [userinfo objectForKey:@"avatar"];
            NSString *nick = [userinfo objectForKey:@"nick"];
            if ( !nick || nick.length==0 ) {
                nick = uid;
            }
            NSString *motto = [userinfo objectForKey:@"description"];
            [self.infoView setInfoName:nick];
            [self.infoView setInfomotto:motto];
            [self.infoView setInfoImageUrl:avatarUrl];
        }
    }];
}

- (void)requestLikeStatus
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleLikeStatusWithAtid:self.atid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if ( status==DataCallBackStatusSuccess ) {
            NSDictionary *content = page.content.contentData;
            BOOL isLike = [[content objectForKey:@"isLike"] boolValue];
            [self.infoView setIsLike:isLike];
        }
    }];
}

- (void)likeClick
{
    [[TubeSDK sharedInstance].tubeArticleSDK setArticleToLikeWithLikeStatus:!self.infoView.isLike atid:self.atid uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"操作成功" duration:1.0f];
            [self requestLikeStatus];
        }
    }];
}

@end
