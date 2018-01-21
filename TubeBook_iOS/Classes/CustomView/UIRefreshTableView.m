//
//  UIRefreshTableView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIRefreshTableView.h"
#import "CKMacros.h"
#import "Masonry.h"

@interface UIRefreshTableView () <UIScrollViewDelegate>

@property(nonatomic, strong) id<UIScrollViewDelegate> scrollDelegate;

@end

@implementation UIRefreshTableView

- (void)dealloc
{
    UIScrollView *scrollView = self;
    scrollView.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addViewAndConstraint];
        UIScrollView *scrollView = self;
        scrollView.delegate = self;
    }
    return self;
}

- (void)addViewAndConstraint
{
    [self addSubview:self.refreshHeadView];
//    [self.refreshHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_top).offset(-16);
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//        make.height.mas_equalTo(self.refreshHeadView.triggerHeight);
//    }];
    //[self.refreshHeadView setBackgroundColor:[UIColor blueColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeadView listenerScrollViewAndChangeState:scrollView refreshState:^(RefreshState state) {
        if (state==RefreshStateStateLoading) {
            if (self.refreshOrLoadDelegate) {
                [self.refreshOrLoadDelegate refreshData];
            }
        }
    }];
}


#pragma mark - get
- (UIRefreshHeadView *)refreshHeadView
{
    if (!_refreshHeadView) {
        _refreshHeadView = [[UIRefreshHeadView alloc] initWithFrame:CGRectMake(0, -56, SCREEN_WIDTH, 56)];
    }
    return _refreshHeadView;
}

@end


@implementation UIRefreshHeadView
{
    RefreshState preRefreshState;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.triggerHeight = 56;
        preRefreshState = RefreshStateNormal;
        [self addViewAndConstraint];
    }
    return self;
}


- (void)addViewAndConstraint
{
    UIView *centerView = [[UIView alloc] init];
    [self addSubview:centerView];
    [centerView addSubview:self.activityIndicatorView];
    [centerView addSubview:self.iconOrientationView];
    [centerView addSubview:self.descriptionLabel];

    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24+8+100);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self.iconOrientationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(centerView);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(centerView);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconOrientationView.mas_right).offset(8);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100);
    }];
    
}

- (void)listenerScrollViewAndChangeState:(UIScrollView *)scrollView refreshState:(refreshState)state;
{
    if ((-scrollView.contentOffset.y) > self.triggerHeight) {
        if (preRefreshState == RefreshStateNormal) {
            state(RefreshStatePulling);
            [self changeRefreshState:RefreshStatePulling];
        }
    } else {
        if (scrollView.isDragging) {
            if (preRefreshState == RefreshStatePulling) {
                state(RefreshStateNormal);
                [self changeRefreshState:RefreshStateNormal];
            }
        } else {
            if (preRefreshState == RefreshStatePulling) {
                 state(RefreshStateStateLoading);
                [self changeRefreshState:RefreshStateStateLoading];
                scrollView.contentInset = UIEdgeInsetsMake(self.triggerHeight, 0.0f, 0.0f, 0.0f);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:1 animations:^{
                        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                        [self changeRefreshState:RefreshStateNormal];
                    }];
                });
            }
        
        }
    }
}

- (void)changeRefreshState:(RefreshState)refreshState
{
    switch (refreshState) {
        case RefreshStateNormal:
            if (!self.activityIndicatorView.hidden) {
                self.activityIndicatorView.hidden = YES;
            }
            if ([self.activityIndicatorView isAnimating]) {
                [self.activityIndicatorView stopAnimating];
            }
            self.iconOrientationView.hidden = NO;
            if (preRefreshState == RefreshStatePulling || preRefreshState == RefreshStateStateLoading) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.iconOrientationView.transform = CGAffineTransformMakeRotation(2*M_PI);
                }];
            }
            self.descriptionLabel.text = @"下拉刷新";
            break;
        case RefreshStatePulling:
            if (!self.activityIndicatorView.hidden) {
                self.activityIndicatorView.hidden = YES;
            }
            if ([self.activityIndicatorView isAnimating]) {
                [self.activityIndicatorView stopAnimating];
            }
            self.iconOrientationView.hidden = NO;
            if (preRefreshState==RefreshStateNormal) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.iconOrientationView.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
            self.descriptionLabel.text = @"松开刷新";
            break;
        case RefreshStateStateLoading:
                        NSLog(@"RefreshStateStateLoading");
            if (self.activityIndicatorView.hidden) {
                self.activityIndicatorView.hidden = NO;
            }
            if (![self.activityIndicatorView isAnimating]) {
                [self.activityIndicatorView startAnimating];
            }
            if (!self.iconOrientationView.hidden) {
                self.iconOrientationView.hidden = YES;
            }
            self.descriptionLabel.text = @"正在刷新";
            break;
    }
    preRefreshState = refreshState;
}

#pragma mark - get
- (UIImageView *)iconOrientationView
{
    if (!_iconOrientationView) {
        _iconOrientationView = [[UIImageView alloc] init];
        [_iconOrientationView setImage:[UIImage imageNamed:@"icon_arrows"]];
    }
    return _iconOrientationView;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = Font(12);
        _descriptionLabel.textColor = kTAB_TEXT_COLOR;
         self.descriptionLabel.text = @"下拉刷新";
    }
    return _descriptionLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidden = YES;
    }
    return _activityIndicatorView;
}

@end
