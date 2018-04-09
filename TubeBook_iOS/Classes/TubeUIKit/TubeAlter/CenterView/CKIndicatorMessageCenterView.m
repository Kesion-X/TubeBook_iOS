//
//  CKIndicatorMessageCenterView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKIndicatorMessageCenterView.h"
#define kAlterWidth 80
#define kActivityIndicatorWidth 50

@interface CKIndicatorMessageCenterView ()

@property (nonatomic, strong) NSString *message;

@end

@implementation CKIndicatorMessageCenterView

- (void)dealloc
{
    [self.activityIndicatorView stopAnimating];
}

- (instancetype)initIndicatorMessageCenterViewWithMessage:(NSString *)message
{
    self.message = message;
    CGSize size = size = [NSString getSizeWithAttributes:message width:70 font:self.messageLable.font];

    self.vWidth = 80;
    self.vHeight = size.height + kActivityIndicatorWidth + 30;
    self = [super initWithFrame:CGRectMake((SCREEN_WIDTH - self.vWidth)/2, (SCREEN_HEIGHT - self.vHeight)/2, self.vWidth, self.vHeight)];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        self.activityIndicatorView.frame = CGRectMake(15, 15, kActivityIndicatorWidth, kActivityIndicatorWidth);
        self.messageLable.frame = CGRectMake(5, kActivityIndicatorWidth + 15, size.width, size.height);
        if (size.width <= 70) {
            self.messageLable.frame = CGRectMake(5 + (70-size.width)/2, kActivityIndicatorWidth + 15, size.width, size.height);
        }
        self.messageLable.text = self.message;
        [self addSubview:self.activityIndicatorView];
        [self addSubview:self.messageLable];
        [self layoutIfNeeded];
        [self.activityIndicatorView startAnimating];
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

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.hidden = YES;
    }
    return _activityIndicatorView;
}


@end
