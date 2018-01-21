//
//  UITubeNavigationView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKMacros.h"
#import "UIIndicatorView.h"
#include "UITubeSearchView.h"

@interface UITubeHomeNavigationView : UIView

@property(nonatomic ,strong) UIButton *addNewAttention;
@property(nonatomic, strong) UIIndicatorView *indicatorView;
@property(nonatomic, strong) UITubeSearchView *searchView;

- (instancetype)initUITubeHomeNavigationView;


@end
