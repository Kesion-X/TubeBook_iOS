//
//  UISerialTableCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"

@interface UISerialTableCell : CKTableCell

@property(nonatomic, strong) NSString *serialImageUrl;//连载图片
@property(nonatomic, strong) NSString *serialTitle;//连载标题
@property(nonatomic, strong) NSString *serialDescription;//连载描述

@property(nonatomic, strong) UIImageView *serialImageView;
@property(nonatomic, strong) UILabel *serialTitleLable;
@property(nonatomic, strong) UILabel *serialDescriptionLable;
@property(nonatomic, strong) UIImageView *serialRightImageView;

@end
