//
//  UITopicTableCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"

@interface UITopicTableCell : CKTableCell

@property(nonatomic, strong) NSString *topicImageUrl;//专题图片
@property(nonatomic, strong) NSString *topicTitle;//专题标题
@property(nonatomic, strong) NSString *topicDescription;//专题描述

@property(nonatomic, strong) UIImageView *topicImageView;
@property(nonatomic, strong) UILabel *topicTitleLable;
@property(nonatomic, strong) UILabel *topicDescriptionLable;
@property(nonatomic, strong) UIImageView *topicRightImageView;

@end
