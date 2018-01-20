//
//  UITubeSearchView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UITubeSearchView.h"
#import "CKMacros.h"
#import "Masonry.h"

@implementation UITubeSearchView

- (instancetype)initUITubeSearchView:(NSString *)searchText
{
    self = [super init];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        self.layer.masksToBounds = YES;
        self.searchText.text = searchText;
        self.backgroundColor = kNAVIGATION_COLOR;
        [self addSubview:self.searchText];
        
        [self addViewAndConstraint];
    }
    return self;
}

- (void)addViewAndConstraint
{
    UIView *centerView = [[UIView alloc] init];
    [self addSubview:centerView];
    [self addSubview:self.searchText];
    [centerView addSubview:self.searchIcon];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView);
        make.top.equalTo(centerView);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
    }];
    [_searchIcon setNeedsLayout];
    [_searchIcon layoutIfNeeded];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.mas_equalTo([_searchText.text sizeWithAttributes:@{NSFontAttributeName: _searchText.font}].width+_searchIcon.frame.size.width+8);
        make.height.mas_equalTo(MAX([_searchText.text sizeWithAttributes:@{NSFontAttributeName: _searchText.font}].height, _searchIcon.frame.size.height));
    }];
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_searchIcon.mas_right).offset(8);
        make.centerY.equalTo(self);
   
    }];

}

- (CGFloat)getUITubeSearchViewHeight
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return self.frame.size.height;
}

- (UILabel *)searchText
{
    if (!_searchText) {
        _searchText = [[UILabel alloc] init];
        _searchText.textColor = kTAB_TEXT_COLOR;
        _searchText.font = Font(14);
    }
    return _searchText;
}

- (UIImageView *)searchIcon
{
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] init];
        [_searchIcon setImage:[UIImage imageNamed:@"icon_search"]];
    }
    return _searchIcon;
}

@end
