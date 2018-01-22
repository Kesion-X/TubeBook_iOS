//
//  UINormalArticleCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTableCell.h"
#import "UIHomeCellItemContentView.h"
#import "UIHomeCellItemFootView.h"
#import "UIHomeCellItemHeadView.h"

@interface UINormalArticleCell : CKTableCell

@property (nonatomic, strong) UIHomeCellItemContentView *homeCellItemContentView;
@property (nonatomic, strong) UIHomeCellItemFootView *homeCellItemFootView;
@property (nonatomic, strong) UIHomeCellItemHeadView *homeCellItemHeadView;




@end
