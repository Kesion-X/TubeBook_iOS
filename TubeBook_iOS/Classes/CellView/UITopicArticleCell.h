//
//  UITopicArticleCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"
#import "CKTableCell.h"
#import "UIHomeCellItemContentView.h"
#import "UIHomeCellItemFootView.h"
#import "UIHomeCellItemHeadView.h"
#import "UIHomeCellTopicOrSerialView.h"

@interface UITopicArticleCell : CKTableCell

@property (nonatomic, strong) UIHomeCellItemHeadView *homeCellItemHeadView;
@property (nonatomic, strong) UIHomeCellItemContentView *homeCellItemContentView;
@property (nonatomic, strong) UIHomeCellItemFootView *homeCellItemFootView;
@property (nonatomic, strong) UIHomeCellTopicOrSerialView *homeCellTopicOrSerialView;

@end
