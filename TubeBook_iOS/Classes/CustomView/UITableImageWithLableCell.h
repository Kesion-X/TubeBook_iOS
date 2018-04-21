//
//  UITableImageWithLableCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableImageWithLableCell : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) UIImageView *titleIconImageView;
@property (nonatomic, strong) UILabel *titleLable;

- (instancetype)initUITableImageWithLableCellWithFrame:(CGRect)frame title:(NSString *)title iconName:(NSString *)iconName;

@end
