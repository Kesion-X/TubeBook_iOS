//
//  NewestViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "NewestViewController.h"
#import "UIRefreshTableView.h"
#import "Masonry.h"
#import "UIHomeCellItemHeadView.h"
#import "UIHomeCellItemFootView.h"
#import "UIHomeCellItemContentView.h"
#import "NormalArticleContent.h"
#import "UINormalArticleCell.h"
#import "CKTableCell.h"
#import "UISerialArticleCell.h"
#import "TopicArticleContent.h"
#import "SerialArticleContent.h"
#import "TopicArticleContent.h"
#import "UITopicArticleCell.h"

@interface NewestViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIRefreshTableView *refreshTableView;
@property(nonatomic, strong) NSMutableArray *contentData;
@property(nonatomic, strong) NSMutableDictionary *classMap;

@end

@implementation NewestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewAndConstraint];
    [self configTable];
   
}

- (void)configTable
{
    self.refreshTableView.delegate = self;
    self.refreshTableView.dataSource = self;
  
    [self registerCell:[UINormalArticleCell class] forKeyContent:[NormalArticleContent class]];
    [self registerCell:[UISerialArticleCell class] forKeyContent:[SerialArticleContent class]];
    [self registerCell:[UITopicArticleCell class] forKeyContent:[TopicArticleContent class]];
    for (int i=0; i<10; ++i) {
        CKContent *content = [[NormalArticleContent alloc] init];
        content.dataType.userState = i%2;
        content.dataType.isHaveImage = i%2;
        [self.contentData addObject:content];
        CKContent *content2 = [[SerialArticleContent alloc] init];
        content2.dataType.userState = i%2;
        content2.dataType.isHaveImage = i%2;
        [self.contentData addObject:content2];
        CKContent *content3 = [[TopicArticleContent alloc] init];
        content3.dataType.userState = i%2;
        content3.dataType.isHaveImage = i%2;
        [self.contentData addObject:content3];
    }
}

- (void)addViewAndConstraint
{
    [self.view addSubview:self.refreshTableView];
    [self.refreshTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)registerCell:(Class)cellClass forKeyContent:(Class)contentClass
{
    self.classMap[NSStringFromClass(contentClass)] = NSStringFromClass(cellClass);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *content = self.contentData[indexPath.row];
    NSString *cellClassName = self.classMap[NSStringFromClass([content class])];
    Class cellClass = NSClassFromString(cellClassName);
    return [cellClass getCellHeight:content];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *content = self.contentData[indexPath.row];
    NSString *cellClassName = self.classMap[NSStringFromClass([content class])];
    Class cellClass = NSClassFromString(cellClassName);
    NSString *cellId = [cellClass getDequeueId:content.dataType];
    CKTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[cellClass alloc] initWithDateType:content.dataType];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //下拉刷新
    [self.refreshTableView.refreshHeadView listenerScrollViewAndChangeState:scrollView refreshState:^(RefreshState state) {
        if (state==RefreshStateStateLoading) {
           
        }
    }];
    
    //加载更多
    [self.refreshTableView showLoadMoreIndicatorView:scrollView loadData:^{
 
    }];
}

#pragma mark - get

- (UIRefreshTableView *)refreshTableView
{
    if (!_refreshTableView) {
        _refreshTableView = [[UIRefreshTableView alloc] init];
    }
    return _refreshTableView;
}

- (NSMutableArray *)contentData
{
    if (!_contentData) {
        _contentData = [[NSMutableArray alloc] init];
    }
    return _contentData;
}

- (NSMutableDictionary *)classMap
{
    if (!_classMap) {
        _classMap = [[NSMutableDictionary alloc] init];
    }
    return _classMap;
}



@end
