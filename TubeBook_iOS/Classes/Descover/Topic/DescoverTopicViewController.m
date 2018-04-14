//
//  DescoverTopicViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "DescoverTopicViewController.h"
#import "CKMacros.h"
#import "TopicCollectionViewCell.h"
#import "UIRefreshTableView.h"
#import "DescoverTopicContent.h"
#import "DescoverTopicTopContent.h"
#import "TopicTopCollectionViewCell.h"
#import "TubeSDK.h"
#define kCollectionMargin 10

@interface DescoverTopicViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *topList;
@property (nonatomic, strong) NSMutableArray *contentList;

@property(nonatomic, strong) UIRefreshHeadView *refreshHeadView;
@property(nonatomic, strong) UIActivityIndicatorView *loadMoreIndicatorView;
@property(nonatomic, strong) NSMutableDictionary *classMap;

@end

@implementation DescoverTopicViewController
{
    NSInteger index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置CollectionView的属性
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[TopicCollectionViewCell class] forCellWithReuseIdentifier:[TopicCollectionViewCell getDequeueId:nil]];
    [self registerCell:[TopicCollectionViewCell class] forKeyContent:[DescoverTopicContent class]];
    
    [self.collectionView registerClass:[TopicTopCollectionViewCell class] forCellWithReuseIdentifier:[TopicTopCollectionViewCell getDequeueId:nil]];
     [self registerCell:[TopicTopCollectionViewCell class] forKeyContent:[DescoverTopicTopContent class]];
    
    [self.collectionView addSubview:self.refreshHeadView];
    [self.collectionView addSubview:self.loadMoreIndicatorView];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //下拉刷新
    [self.refreshHeadView listenerScrollViewAndChangeState:scrollView refreshState:^(RefreshState state) {
        if (state==RefreshStateStateLoading) {
//            if (self.refreshTableViewControllerDelegate) {
//                [self.refreshTableViewControllerDelegate refreshData];
//            }
            index = 0;
            [self requestData];
        }
    }];
    
    //加载更多
    [self showLoadMoreIndicatorView:scrollView loadData:^{
//        if (self.refreshTableViewControllerDelegate) {
//            [self.refreshTableViewControllerDelegate loadMoreData];
//        }
        [self requestData];
    }];
}

- (void)showLoadMoreIndicatorView:(UIScrollView *)scrollView loadData:(loadData)loadData;
{
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

- (void)registerCell:(Class)cellClass forKeyContent:(Class)contentClass
{
    self.classMap[NSStringFromClass(contentClass)] = NSStringFromClass(cellClass);
}


#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section) {
        case 0:
        {
            //count = 1;
            count = self.topList.count;
            //count = 1;
            break;
        }
        case 1:
        {
            //count = 5;
            count = self.contentList.count;
            break;
        }
        default:
            break;
    }
    return count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CKCollectionViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            CKContent *content = self.topList[indexPath.row];
            NSString *cellClassName = self.classMap[NSStringFromClass([content class])];
            Class cellClass = NSClassFromString(cellClassName);
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[cellClass getDequeueId:content.dataType] forIndexPath:indexPath];
            [cell setContent:content];
            break;
        }
        case 1:
        {
            CKContent *content = self.contentList[indexPath.row];
            NSString *cellClassName = self.classMap[NSStringFromClass([content class])];
            Class cellClass = NSClassFromString(cellClassName);
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[cellClass getDequeueId:content.dataType] forIndexPath:indexPath];
            [cell setContent:content];
            break;
        }
        default:
            break;
    }
    return cell;
}


#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    switch (indexPath.section) {
        case 0:
        {
            size = CGSizeMake( SCREEN_WIDTH - kCollectionMargin*2, 200);
            break;
        }
        case 1:
        {
            size = CGSizeMake( (SCREEN_WIDTH - kCollectionMargin*4)/3, (SCREEN_WIDTH - kCollectionMargin*4)/3 + 40);
            break;
        }
    }
    
    return  size;
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kCollectionMargin, 8, kCollectionMargin, 8);//（上、左、下、右）
}

#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionMargin;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionMargin;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // Medal *p = self.medals[indexPath.item];
    NSLog(@"---------------------");
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - get
- (NSMutableArray *)topList
{
    if (!_topList) {
        _topList = [[NSMutableArray alloc] init];
    }
    return _topList;
}

- (NSMutableArray *)contentList
{
    if (!_contentList) {
        _contentList = [[NSMutableArray alloc] init];
    }
    return _contentList;
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

- (NSMutableDictionary *)classMap
{
    if (!_classMap) {
        _classMap = [[NSMutableDictionary alloc] init];
    }
    return _classMap;
}

#pragma mark - load

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleTopicTitleListWithIndex:index
                                                                               uid:nil
                                                                         fouseType:FouseTypeAll
                                                                      conditionDic:nil
                                                                          callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
                                                                              
                                                                              if ( index==0 && weakSelf.contentList.count>0) {
                                                                                  [weakSelf.contentList removeAllObjects];
                                                                                  [weakSelf.collectionView reloadData];
                                                                              }
                                                                              
                                                                              if ( status==DataCallBackStatusSuccess ) {
                                                                                  NSDictionary *content = page.content.contentData;
                                                                                  NSArray *array = [content objectForKey:@"tabTapList"];
                                                                                  if (array.count == 0) {
                                                                                      return ;
                                                                                  }
                                                                                  for (NSDictionary *dic in array) {
                                                                                      NSString *time = [dic objectForKey:@"create_time"];
                                                                                      NSString *create_uid = [dic objectForKey:@"create_userid"];
                                                                                      NSString *description = [dic objectForKey:@"description"];
                                                                                      NSString *pic = [dic objectForKey:@"pic"];
                                                                                      NSString *title = [dic objectForKey:@"title"];
                                                                                      NSInteger id = [[dic objectForKey:@"id"] integerValue];
                                                                                      CKContent *ckContent = nil;
                                                                                      ckContent = [[DescoverTopicContent alloc] init];
                                                                                      ckContent.topicTitle = title;
                                                                                      ckContent.topicImageUrl = pic;
                                                                                      ckContent.topicDescription = description;
                                                                                      ckContent.userUid = create_uid;
                                                                                      ckContent.time = time;
                                                                                      ckContent.id = id;
                                                                                      [weakSelf.contentList addObject:ckContent];
                                                                                  }
                                                                                  index ++;
                                                                                  [weakSelf.collectionView reloadData];
                                                                              }
                                                                          }];
}



@end
