//
//  UITubeSearchView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITubeSearchView : UIView

@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UILabel *searchText;

- (instancetype)initUITubeSearchView:(NSString *)searchText;
- (CGFloat)getUITubeSearchViewHeight;

@end
