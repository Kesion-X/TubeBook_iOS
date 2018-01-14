//
//  UITubeButton.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UITubeButton.h"
#import "CKMacros.h"

@implementation UITubeButton

- (instancetype)initUITubeButton:(NSString *)text normalColor:(UIColor *)normalColor lightColor:(UIColor *)lightColor;
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setTitle:text forState:UIControlStateNormal];
        [self setBackgroundImage:[CKMacros createImageWithColor:normalColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[CKMacros createImageWithColor:lightColor] forState:UIControlStateHighlighted];
    }
    return self;
}

@end
