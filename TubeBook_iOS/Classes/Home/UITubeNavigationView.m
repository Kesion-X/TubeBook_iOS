//
//  UITubeNavigationView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UITubeNavigationView.h"
#import "Masonry.h"

@implementation UITubeNavigationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addViewAndConstraint];
    
    }
    return self;
}

- (instancetype)initUITubeNavigationView
{
    self = [super init];
    if (self) {
        [self addViewAndConstraint];
    }
    return self;
}

- (void)addViewAndConstraint
{
    [self addSubview:self.addNewAttention];
    [self addSubview:self.searchView];
    [self addSubview:self.indicatorView];
    
    [self.addNewAttention mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self).offset(4);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addNewAttention.mas_right).offset(8);
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@28);
    }];
    [self.searchView setNeedsLayout];
    [self.searchView layoutIfNeeded];
    self.searchView.layer.cornerRadius = self.searchView.bounds.size.height/2;
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addNewAttention.mas_bottom).offset(4);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_equalTo([self.indicatorView getUIHeight]);
    }];
    [_indicatorView addIndicatorItemByString:@"最新"];
    [_indicatorView addIndicatorItemByString:@"推荐"];
    [_indicatorView addIndicatorItemByString:@"关注作者"];
    [_indicatorView addIndicatorItemByString:@"专题"];
    [_indicatorView addIndicatorItemByString:@"连载"];
    [_indicatorView addIndicatorItemByString:@"关注话题"];
    [self.indicatorView setShowIndicatorItem:0];
    
    UIView *bottomInterspace = [[UIView alloc] init];
    [bottomInterspace setBackgroundColor:kTAB_TEXT_COLOR];
    [self addSubview:bottomInterspace];
    [bottomInterspace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(0.5);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}


- (UIButton *)addNewAttention
{
    if (!_addNewAttention) {
        _addNewAttention = [[UIButton alloc] init];
        [_addNewAttention setImage:[UIImage imageNamed:@"icon_add_ attention" ] forState:UIControlStateNormal];
    }
    return _addNewAttention;
}

- (UIIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIIndicatorView alloc] initUIIndicatorView:kTUBEBOOK_THEME_NORMAL_COLOR font:Font(12)];
    }
    return _indicatorView;
}

- (UITubeSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[UITubeSearchView alloc] initUITubeSearchView:@"在Tube上搜索你喜欢的内容吧"];
    }
    return _searchView;
}

@end
