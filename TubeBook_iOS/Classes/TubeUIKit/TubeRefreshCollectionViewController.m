//
//  TubeRefreshCollectionViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeRefreshCollectionViewController.h"
#import "CKMacros.h"

@interface TubeRefreshCollectionViewController () 


@end

@implementation TubeRefreshCollectionViewController

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.layout.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self configLayout];
}

- (void)configLayout
{
    self.layout.delegate = self;
}

- (void)configCollectionView
{
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView addSubview:self.refreshHeadView];
    [self.collectionView addSubview:self.loadMoreIndicatorView];
}

- (void)registerCell:(Class)cellClass forKeyContent:(Class)contentClass
{
    self.classMap[NSStringFromClass(contentClass)] = NSStringFromClass(cellClass);
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //下拉刷新
    [self.refreshHeadView listenerScrollViewAndChangeState:scrollView refreshState:^(RefreshState state) {
        if (state==RefreshStateStateLoading) {
            if (self.refreshTableViewControllerDelegate) {
                [self.refreshTableViewControllerDelegate refreshData];
            }
        }
    }];
    
    //加载更多
    [self showLoadMoreIndicatorView:scrollView loadData:^{
        if (self.refreshTableViewControllerDelegate) {
            [self.refreshTableViewControllerDelegate loadMoreData];
        }
    }];
}

- (void)showLoadMoreIndicatorView:(UIScrollView *)scrollView loadData:(loadData)loadData;
{
    if (self.refreshHeadView.reStatus != RefreshStateNormal) { // 防止在下拉刷新的时候加载更多
        return ;
    }
    if (scrollView.contentOffset.y<0) {
        return ;
    }
    
    CGFloat y = scrollView.frame.size.height;
    if (scrollView.contentSize.height < scrollView.frame.size.height ) {
        y = scrollView.contentSize.height;
    }
      if (((scrollView.contentOffset.y + y) - (scrollView.contentSize.height)) > 72 && scrollView.isDragging) {
        if (self.loadMoreIndicatorView.hidden) {
            [self.loadMoreIndicatorView startAnimating];
            self.loadMoreIndicatorView.hidden = NO;
            self.loadMoreIndicatorView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, scrollView.contentSize.height-30, 25, 25);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.1 animations:^{
                    loadData();
                    self.loadMoreIndicatorView.hidden = YES;
                    [self.loadMoreIndicatorView stopAnimating];
                }];
            });
        }
    }
}

#pragma mark - UIWaterfallCollectionViewLayoutDelegate
- (CGFloat)collectionViewLayout:(UICollectionViewLayout *)collectionViewLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *content = self.contentData[indexPath.row];
    NSString *cellClassName = self.classMap[NSStringFromClass([content class])];
    Class cellClass = NSClassFromString(cellClassName);
    return [cellClass getCellHeight:content];
}

#pragma mark - UICollectionViewDelegate
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}

#pragma mark - UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CKContent *content = self.contentData[indexPath.row];
    NSString *cellClassName = self.classMap[NSStringFromClass([content class])];
    Class cellClass = NSClassFromString(cellClassName);
    CKCollectionViewCell* cell = (CKCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[cellClass getDequeueId:content.dataType] forIndexPath:indexPath];
    [cell setContent:content];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentData.count;
}

#pragma mark - get
-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
    }
    return _collectionView;
}

-(UICollectionViewLayout *)layout{
    if(!_layout){
        _layout = [[UIWaterfallCollectionViewLayout alloc] init];
    }
    return _layout;
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

- (UIRefreshHeadView *)refreshHeadView
{
    if (!_refreshHeadView) {
        _refreshHeadView = [[UIRefreshHeadView alloc] initWithFrame:CGRectMake(0, -56, SCREEN_WIDTH, 56)];
    }
    return _refreshHeadView;
}

- (UIActivityIndicatorView *)loadMoreIndicatorView
{
    if (!_loadMoreIndicatorView) {
        _loadMoreIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadMoreIndicatorView.hidden = YES;
    }
    return _loadMoreIndicatorView;
}

@end
