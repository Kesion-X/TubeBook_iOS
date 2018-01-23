//
//  TubeRefreshTableViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRefreshTableViewController.h"

@interface TubeRefreshTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TubeRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTable];
}

- (void)configTable
{
    self.refreshTableView.delegate = self;
    self.refreshTableView.dataSource = self;
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
            if (self.refreshTableViewControllerDelegate) {
                [self.refreshTableViewControllerDelegate refreshData];
            }
        }
    }];
    
    //加载更多
    [self.refreshTableView showLoadMoreIndicatorView:scrollView loadData:^{
        if (self.refreshTableViewControllerDelegate) {
            [self.refreshTableViewControllerDelegate loadMoreData];
        }
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
