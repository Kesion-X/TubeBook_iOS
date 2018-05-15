//
//  MyThirdCollectionController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/5/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "MyThirdCollectionController.h"
#import "Masonry.h"
#import "TubeNavigationUITool.h"
#import "TubeSDK.h"
#import "DetailSerialArticleContent.h"
#import "DetailSerialArticleTableViewCell.h"
#import "CKContent.h"
#import "TubeWebViewViewController.h"

@interface MyThirdCollectionController () <UIRefreshOrLoadTableViewDelegate>

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation MyThirdCollectionController
{
    NSInteger index;
}

- (instancetype)initMyThirdCollectionControllerWithUid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self.uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s ,uid=%@",self.uid);
    self.refreshTableView.refreshOrLoadDelegate = self;
    [self registerCell:[DetailSerialArticleTableViewCell class] forKeyContent:[DetailSerialArticleContent class]];
    [self requestThirdCollectionList];
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
        
        [self.navigationController.navigationBar addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navigationController.navigationBar);
            make.centerY.equalTo(self.navigationController.navigationBar);
        }];
    }
}

- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        NSLog(@"%s pop view controller",__func__);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"%s dismiss view controller",__func__);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - request

- (void)requestThirdCollectionList
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedThirdCollectionListWithIndex:index uid:self.uid callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            if ( index == 0 && self.contentData.count>0 ) {
                [self.contentData removeAllObjects];
                [self.refreshTableView reloadData];
            }
            NSDictionary *contentDicary = page.content.contentData;
            NSArray *list = [contentDicary objectForKey:@"list"];
            for ( NSDictionary *contentDic in list ) {
                NSString *title = [contentDic objectForKey:@"title"];
                NSString *url = [contentDic objectForKey:@"url"];
                NSString *time = [TimeUtil getDateWithTime:[[contentDic objectForKey:@"collection_time"] integerValue]];
                DetailSerialArticleContent *content = [[DetailSerialArticleContent alloc] init];
                content.articleTitle = title;
                content.time = time;
                content.articleUrl = url;
                [self.contentData addObject:content];
            }
            if (list.count>0) {
                [self.refreshTableView reloadData];
                index ++;
            }
        }
    }];
}
#pragma mark - delegate
- (void)refreshData
{
    index = 0;
    [self requestThirdCollectionList];
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    [self requestThirdCollectionList];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailSerialArticleContent *content = [self.contentData objectAtIndex:indexPath.row];
    UIViewController *c = [[TubeWebViewViewController alloc] initTubeWebViewViewControllerWithUrl:content.articleUrl];
    c.title = content.articleTitle;
    NSLog(@"%s select item %@",__func__, c);
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark - get
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        _titleLable.text = self.title;
    }
    return _titleLable;
}


@end
