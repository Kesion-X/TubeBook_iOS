//
//  UIRingScrollView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/24.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIRingScrollView.h"
#import "CKMacros.h"
#import "Masonry.h"

#define kCIRCLE_MARGIN 16
#define kCIRCLE_SIZE 6
#define kCIRCLE_MARGIN_BOTTOM 10
#define kAUTO_SCROLL_MARGIN 30

@interface UIRingScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *arrayItems;//uiview
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSUInteger preIndex;
@property (nonatomic) NSUInteger nextIndex;

@property (nonatomic, strong) UIView *circlesView;
@property (nonatomic, strong) NSMutableArray *circleItems;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *lightColor;

@property (nonatomic) CGFloat drawLeft;

@end

@implementation UIRingScrollView


- (void)dealloc{
    self.scrollView.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configScrollView];
        self.circlesView = [[UIView alloc] init];
        [self addSubview:self.circlesView];
    }
    return self;
}

- (instancetype)initWithFrameUIRingScrollView:(CGRect)frame
                                   arrayItems:(NSMutableArray *)arrayItems
                                  normalColor:(UIColor *)normalColor
                                   lightColor:(UIColor *)lightColor
{
    self = [self initWithFrame:frame];
    if (self) {
        self.currentIndex = 0;
        self.normalColor = normalColor;
        self.lightColor = lightColor;
        for (UIView *v in arrayItems) {
            [self addArrayItemsView:v];
        }
    }
    return self;
}

- (void)configScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    self.scrollView.delegate = self;
}

- (void)addArrayItemsView:(UIView *)item
{
    [self.arrayItems addObject:item];
    [self.scrollView addSubview:item];
    item.frame = CGRectMake(self.drawLeft, 0, self.frame.size.width, self.frame.size.height);
    self.drawLeft += self.frame.size.width;
    self.scrollView.contentSize = CGSizeMake(self.drawLeft, self.scrollView.frame.size.height);
    
    UIView *v = [self createCircleView];
    [self.circleItems addObject:v];
    [self.circlesView addSubview:v];
    [self refreshCircleLayout];
    [self refreshCirclesShow];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView.scrollEnabled)
    if ((self.currentIndex != self.arrayItems.count-1) &&
        scrollView.contentOffset.x > (self.currentIndex * self.scrollView.frame.size.width + kAUTO_SCROLL_MARGIN)) {

        self.scrollView.scrollEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollView setContentOffset:CGPointMake(((self.currentIndex+1) * self.scrollView.frame.size.width), self.scrollView.contentOffset.y) animated:YES];
            } completion:^(BOOL finished) {
                self.scrollView.scrollEnabled = YES;
                self.currentIndex++;
            }];
        });

    } else {
        if (self.currentIndex != 0) {
            self.scrollView.scrollEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    [self.scrollView setContentOffset:CGPointMake(((self.currentIndex-1) * self.scrollView.frame.size.width), self.scrollView.contentOffset.y) animated:YES];
                } completion:^(BOOL finished) {
                    self.scrollView.scrollEnabled = YES;
                    self.currentIndex--;

                }];
            });
            
        }
    }
    
    [self refreshCirclesShow];
}

#pragma mark - 刷新小圆点布局
- (void)refreshCircleLayout
{
    [self.circlesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-kCIRCLE_MARGIN_BOTTOM);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(self.circleItems.count * kCIRCLE_SIZE + (self.circleItems.count + 1) * kCIRCLE_MARGIN);
        make.height.mas_equalTo(kCIRCLE_SIZE + kCIRCLE_MARGIN * 2);
    }];
    UIView *preV= self.circlesView;
    for (UIView *v in self.circleItems) {
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preV).offset(kCIRCLE_MARGIN);
            make.width.mas_equalTo(kCIRCLE_SIZE);
            make.height.mas_equalTo(kCIRCLE_SIZE);
            make.centerY.equalTo(preV);
        }];
        preV = v;
    }
}

#pragma mark - 刷新小圆点显示
- (void)refreshCirclesShow
{
    for (int i=0; i<self.circleItems.count ; i++) {
        UIView *v = [self.circleItems objectAtIndex:i];
        if (self.currentIndex==i) {
            v.backgroundColor = self.lightColor;
        } else {
            v.backgroundColor = self.normalColor;
        }
    }
}

#pragma mark - 创建一个新的小圆点
- (UIView *)createCircleView
{
    UIView *circleV = [[UIView alloc] init];
    circleV.layer.cornerRadius = 3;
    circleV.layer.borderWidth = 0.5;
    circleV.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
    circleV.layer.masksToBounds = YES;
    return circleV;
}

#pragma mark - get and set

- (NSMutableArray *)arrayItems
{
    if (!_arrayItems) {
        _arrayItems = [[NSMutableArray alloc] init];
    }
    return _arrayItems;
}

- (NSMutableArray *)circleItems
{
    if (!_circleItems) {
        _circleItems = [[NSMutableArray alloc] init];
    }
    return _circleItems;
}


- (UIView *)circlesView
{
    if (!_circlesView) {
        _circlesView = [[UIView alloc] init];
    }
    return _circlesView;
}

@end
