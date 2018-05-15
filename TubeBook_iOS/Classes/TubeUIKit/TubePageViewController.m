//
//  TubePageViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubePageViewController.h"
#import "UIIndicatorView.h"
#import "CKMacros.h"

@interface TubePageViewController () <UIPageViewControllerDelegate,UIPageViewControllerDataSource, UIScrollViewDelegate, UIIndicatorViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView;

@end

@implementation TubePageViewController
{
    CGFloat preOffsetX;
    CGFloat offsetDistance;
}

- (void)dealloc
{
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = nil;
    self.scrollerView.delegate = nil;
    self.indicatorView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOffset];
}

- (void)configIndicator:(UIIndicatorView *)indicator
{
    self.indicatorView = indicator;
    self.indicatorView.delegate = self;
}

- (void)configPageView:(CGRect)frame arrayControllers:(NSMutableArray *)arrayControllers
{
    self.arrayControllers = arrayControllers;
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageViewController.view.frame = frame;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    NSArray *array = [NSArray arrayWithObjects:[self.arrayControllers objectAtIndex:0], nil];
    [self.pageViewController setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
    self.scrollerView = [self findScrollView];
    self.scrollerView.delegate = self;
}

- (void)initOffset
{
    preOffsetX = [UIScreen mainScreen].bounds.size.width;
    offsetDistance = 0;
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

-(UIScrollView *)findScrollView
{
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
        if ( !self.indicatorView ) {
            return;
        }
        if (offsetDistance>0) {
            if (self.indicatorView.currentIndicator==self.indicatorView.itemArrays.count-1) {
                self.scrollerView.bounces = NO;
            }else{
                self.scrollerView.bounces = YES;
            }
            [self.indicatorView changeIndicatorViewSize:YES scale:(offsetDistance)/SCREEN_WIDTH];
        } else {//向左偏移
            if (self.indicatorView.currentIndicator==0) {
                self.scrollerView.bounces = NO;
            }else{
                self.scrollerView.bounces = YES;
            }
            [self.indicatorView changeIndicatorViewSize:NO scale:(-offsetDistance)/SCREEN_WIDTH];
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
        if (self.indicatorView) {
            [self.indicatorView setShowIndicatorItem:[self getCurrentPageIndex:pageViewController.viewControllers[0]]];
        }

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
    }
    return _arrayControllers;
}


@end
