//
//  UIDescoverRecommendCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"
#import "UIHomeCellItemContentView.h"
#import "UIHomeCellItemFootView.h"
#import "UIHomeCellItemHeadView.h"
#import "DescoverRecommendContent.h"

@interface UIDescoverRecommendCell : CKTableCell

@property (nonatomic, strong) UIHomeCellItemContentView *homeCellItemContentView;
@property (nonatomic, strong) UIHomeCellItemFootView *homeCellItemFootView;
@property (nonatomic, strong) UIHomeCellItemHeadView *homeCellItemHeadView;

@end
