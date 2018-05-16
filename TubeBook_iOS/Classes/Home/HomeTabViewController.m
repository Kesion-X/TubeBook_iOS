//
//  HomeTabViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "HomeTabViewController.h"
#import "TubeNavigationUITool.h"
#import "CKMacros.h"
#import "UIIndicatorView.h"
#import "Masonry.h"
#import "UINavigationBar+CustomHeight.h"
#import "UITubeSearchView.h"
#import "UITubeHomeNavigationView.h"
#include "NewestViewController.h"
#include "RecommendViewController.h"
#include "AuthorViewController.h"
#include "SerialViewController.h"
#include "TopicViewController.h"
#import "UserInfoUtil.h"

@interface HomeTabViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIIndicatorViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITubeHomeNavigationView *tubeNavigationView;
@property (nonatomic, strong) UIScrollView *scrollerView;

@end

@implementation HomeTabViewController
{
    CGFloat preOffsetX;
    CGFloat offsetDistance;
}
- (void)dealloc
{
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = nil;
    self.tubeNavigationView.indicatorView.indicatorDelegate = nil;
    self.scrollerView.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviewAndConConstraints];
    [self configPageView];
    [self initOffset];

}

- (void)initOffset
{
    preOffsetX = [UIScreen mainScreen].bounds.size.width;
    offsetDistance = 0;
}

- (void)addSubviewAndConConstraints
{
    self.tubeNavigationView = [[UITubeHomeNavigationView alloc] init];
    [self.view addSubview:self.tubeNavigationView];
    [self.tubeNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo([self.tubeNavigationView.searchView getUITubeSearchViewHeight]+[self.tubeNavigationView.indicatorView getUIHeight]+12);
    }];
    self.tubeNavigationView.indicatorView.indicatorDelegate = self;
}

- (void)configPageView
{
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    CGFloat y = self.tubeNavigationView.frame.origin.y+self.tubeNavigationView.frame.size.height;
    self.pageViewController.view.frame = CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - y);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    NSArray *array = [NSArray arrayWithObjects:[self.arrayControllers objectAtIndex:0], nil];
    [self.pageViewController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
    self.scrollerView = [self findScrollView];
    self.scrollerView.delegate = self;
    self.scrollerView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

}

- (void)configNavigation
{
    if (!self.navigationController.navigationBar.isHidden) {
        [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.tabBarController.navigationItem.title = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.titleView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    [self configNavigation];
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
}

- (NSUInteger)getCurrentPageIndex:(UIViewController *)controller
{
    NSUInteger i=0;
    for (UIViewController *c in self.arrayControllers){
        if (c==controller){
            break;
        }
        i++;
    }
    return i;
}

-(UIScrollView *)findScrollView{
    UIScrollView* scrollView;
    for(id subview in _pageViewController.view.subviews){
        if([subview isKindOfClass:UIScrollView.class]){
            scrollView=subview;
            break;
        }}
    return scrollView;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    if (fabs(x-preOffsetX)>200) {//此处当向右滑动到第三个界面时offset从0开始，暂时还没找到原因，进行判定控制，offset被重置为0的情况
        return;
    }
    if (x!=SCREEN_WIDTH&&x!=0) {
        offsetDistance +=(x - preOffsetX);
        preOffsetX = x;
        //向右偏移
        if (offsetDistance>0) {
            if (self.tubeNavigationView.indicatorView.currentIndicator==self.tubeNavigationView.indicatorView.itemArrays.count-1) {
                self.scrollerView.bounces = NO;
            }else{
                self.scrollerView.bounces = YES;
            }
            [self.tubeNavigationView.indicatorView changeIndicatorViewSize:YES scale:(offsetDistance)/SCREEN_WIDTH];
        } else {//向左偏移
            if (self.tubeNavigationView.indicatorView.currentIndicator==0) {
                self.scrollerView.bounces = NO;
            }else{
                self.scrollerView.bounces = YES;
            }
            [self.tubeNavigationView.indicatorView changeIndicatorViewSize:NO scale:(-offsetDistance)/SCREEN_WIDTH];
        }
    }

}

#pragma mark - UIIndicatorViewDelegate
- (void)indicatorItemsClick:(NSUInteger)index
{
    [self.view addSubview:self.pageViewController.view];
    NSArray *array = [NSArray arrayWithObjects:[self.arrayControllers objectAtIndex:index], nil];
    [self.pageViewController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
    [self initOffset];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{

    if (completed) {
        [self.tubeNavigationView.indicatorView setShowIndicatorItem:[self getCurrentPageIndex:pageViewController.viewControllers[0]]];
        NSLog(@"page class:%@ %lu ",[previousViewControllers description], [self getCurrentPageIndex:pageViewController.viewControllers[0]]);
        [self initOffset];
    }
}
#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.arrayControllers indexOfObject:viewController];
    if (index == 0 || (index == NSNotFound)) {
        
        return nil;
    }
    index--;
    return [self.arrayControllers objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.arrayControllers indexOfObject:viewController];
    if (index == self.arrayControllers.count - 1 || (index == NSNotFound)) {
        return nil;
    }
    index++;
    return [self.arrayControllers objectAtIndex:index];
}

#pragma mark - get
- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:nil];
    }
    return _pageViewController;
}

- (NSMutableArray *)arrayControllers
{
    if (!_arrayControllers) {
        _arrayControllers = [[NSMutableArray alloc] init];
        [_arrayControllers addObject:[[NewestViewController alloc] init]];
        [_arrayControllers addObject:[[RecommendViewController alloc] init]];
        [_arrayControllers addObject:[[TopicViewController alloc] initTopicViewControllerWithFouseType:FouseTypeAttrent
                                      uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]]];
        [_arrayControllers addObject:[[SerialViewController alloc] initSerialViewControllerWithFouseType:FouseTypeAttrent uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]]];
        [_arrayControllers addObject:[[AuthorViewController alloc] initAuthorViewControllerWithAutorType:AuthorTypeAttent]];
    }
    return _arrayControllers;
}


@end
