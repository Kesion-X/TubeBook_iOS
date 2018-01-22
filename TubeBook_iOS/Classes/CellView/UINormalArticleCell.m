//
//  UINormalArticleCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UINormalArticleCell.h"
#import "Masonry.h"

@implementation UINormalArticleCell

- (instancetype)initWithDateType:(CKDataType *)type
{
    self = [super initWithDateType:type];
    if (self) {
        self.homeCellItemHeadView = [[UIHomeCellItemHeadView alloc] initUIHomeCellItemHeadView:type.userState];
        self.homeCellItemContentView = [[UIHomeCellItemContentView alloc] initUIHomeCellItemContentView:type.isHaveImage];
        self.homeCellItemFootView = [[UIHomeCellItemFootView alloc] initUIHomeCellItemFootView:type.userState];
        [self addViewAndConstraint];
    }
    return self;
}

- (void)addViewAndConstraint
{
    [self.contentView addSubview:self.homeCellItemHeadView];
    [self.contentView addSubview:self.homeCellItemContentView];
    [self.contentView addSubview:self.homeCellItemFootView];
    [self.homeCellItemHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo([self.homeCellItemHeadView getUIHeight]);
    }];
    [self.homeCellItemContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.homeCellItemHeadView.mas_bottom);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo([self.homeCellItemContentView getUIHeight]);
    }];
    [self.homeCellItemFootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.homeCellItemContentView.mas_bottom);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo([self.homeCellItemFootView getUIHeight]);
    }];
}

- (CGFloat)getCellHeight
{
    CGFloat height = 0;
    if (self.homeCellItemHeadView && self.homeCellItemContentView && self.homeCellItemFootView) {
        height = [self.homeCellItemFootView getUIHeight] + [self.homeCellItemContentView getUIHeight] + [self.homeCellItemHeadView getUIHeight];
    }
    return height + 16;
}

+ (CGFloat)getCellHeight:(CKContent *)content
{
    return [UIHomeCellItemHeadView getUIHeight:content.dataType.userState] + [UIHomeCellItemContentView getUIHeight:content.dataType.isHaveImage] + [UIHomeCellItemFootView getUIHeight:content.dataType.userState] + 16;
}

@end
