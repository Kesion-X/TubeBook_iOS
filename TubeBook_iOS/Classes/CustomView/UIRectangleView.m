//
//  UIRectangleView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIRectangleView.h"
#import "CKMacros.h"

@implementation UIRectangleView

- (instancetype)initUIRectangleView:(UIColor *)backColor{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = kTEXTCOLOR.CGColor;
        self.backgroundColor = backColor;
    }
    return self;
}

@end
