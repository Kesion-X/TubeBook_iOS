//
//  UIRefreshTableView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RefreshState) {
    RefreshStateNormal,//正常
    RefreshStatePulling,//释放可刷新
    RefreshStateStateLoading,//刷新中
};

typedef void(^refreshState)(RefreshState state);

@interface UIRefreshHeadView : UIView

@property (nonatomic, strong) UIImageView *iconOrientationView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, assign) CGFloat triggerHeight;
@property (nonatomic, assign) RefreshState reStatus;

- (void)listenerScrollViewAndChangeState:(UIScrollView *)scrollView refreshState:(refreshState)state;


@end


@protocol UIRefreshOrLoadTableViewDelegate <NSObject>

@optional

- (void)refreshData;
- (void)loadMoreData;

@end

typedef void(^loadData)(void);

@interface UIRefreshTableView : UITableView

@property(nonatomic, strong) UIRefreshHeadView *refreshHeadView;
@property(nonatomic, strong) UIActivityIndicatorView *loadMoreIndicatorView;
@property(nonatomic, strong) id<UIRefreshOrLoadTableViewDelegate> refreshOrLoadDelegate;
- (void)showLoadMoreIndicatorView:(UIScrollView *)scrollView loadData:(loadData)loadData;

@end


