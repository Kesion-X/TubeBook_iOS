//
//  CKMessageCenterView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKMessageCenterView.h"
#import "CKMacros.h"

@interface CKMessageCenterView ()

@property (nonatomic, strong) NSString *message;

@end

@implementation CKMessageCenterView

- (instancetype)initCKMessageCenterViewWithMessage:(NSString *)message frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        self.message = message;
        self.messageLable.text = message;
        CGSize size = [NSString getSizeWithAttributes:self.message font:self.messageLable.font];
        if ( size.width > SCREEN_WIDTH/2) {
            size = [NSString getSizeWithAttributes:self.message width:SCREEN_WIDTH/2 font:self.messageLable.font];
        }
        self.vWidth = size.width + 20;
        self.vHeight = size.height + 20;
        self.frame = CGRectMake((SCREEN_WIDTH - self.vWidth)/2, (SCREEN_HEIGHT - self.vHeight)/2, self.vWidth, self.vHeight);
        self.messageLable.frame = CGRectMake( 10, 10, size.width, size.height);
        [self layoutIfNeeded];
        [self addSubview:self.messageLable];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    }
    return self;
}


- (UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] init];
        _messageLable.font = Font(12);
        _messageLable.textColor = [UIColor whiteColor];
        _messageLable.numberOfLines = 0;
        _messageLable.lineBreakMode = NSLineBreakByCharWrapping;
        _messageLable.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLable;
}

@end
