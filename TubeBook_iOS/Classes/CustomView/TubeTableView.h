//
//  TubeTableView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TubeTableViewDelegate  <NSObject>

- (void)tableItemView:(UIView *)itemView index:(NSInteger)index;

@end

@interface TubeTableView : UIView

@property (nonatomic, strong) id <TubeTableViewDelegate> delegate;
- (instancetype)initWithWidth:(CGFloat)width;
- (void)addItemView:(UIView *)view;
- (void)updateLayout;

@end
