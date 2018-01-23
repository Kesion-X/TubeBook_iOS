//
//  UIUserTableCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"

@interface UIUserTableCell : CKTableCell

@property(nonatomic, strong) NSString *avatarUrl; // 用户头像
@property(nonatomic, strong) NSString *userName; //用户名称
@property(nonatomic, strong) NSString *motto;//用户座右铭

@property(nonatomic, strong) UIImageView *userImageView;
@property(nonatomic, strong) UILabel *userTitleLable;
@property(nonatomic, strong) UILabel *userDescriptionLable;
@property(nonatomic, strong) UIImageView *userRightImageView;

@end
