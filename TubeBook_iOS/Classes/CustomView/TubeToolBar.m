//
//  TubeToolBar.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/17.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeToolBar.h"
#import "CKMacros.h"
#import "Masonry.h"

@implementation TubeToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
        UIView *topSeparateView = [[UIView alloc] init];
        topSeparateView.backgroundColor = HEXCOLOR(0xdcdce0);
        [self addSubview:topSeparateView];
        [topSeparateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *bottomSeparateView = [[UIView alloc] init];
        bottomSeparateView.backgroundColor = HEXCOLOR(0xdcdce0);
        [self addSubview:bottomSeparateView];
        [bottomSeparateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-0.5);
            make.height.mas_equalTo(0.5);
        }];
        

        
    }
    return self;
}

@end
