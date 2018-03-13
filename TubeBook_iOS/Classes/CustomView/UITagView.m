
//
//  UITagView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UITagView.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "NSString+StringKit.h"

#define kTAG_Margin 4

@implementation UITagView
{
    CGSize size;
}
- (instancetype)initUITagView:(NSString *)tagText color:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.tagText = tagText;
        self.color = color;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = color.CGColor;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tagButton];
        size = [NSString getSizeWithAttributes:tagText font:self.tagButton.titleLabel.font];
        [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(4);
            make.left.equalTo(self).offset(4);
            make.bottom.equalTo(self).offset(-4);
            make.right.equalTo(self).offset(-4);
        }];
        
    }
    return self;
}


- (CGFloat)getUIHeight
{
    return size.height+4*2;
}

- (CGFloat)getUIWidht
{
    return size.width+8*2;
}

- (void)setTagColor:(UIColor *)color
{
    self.color = color;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
    [self.tagButton setTitleColor:self.color forState:UIControlStateNormal];
}

#pragma mark - get
- (UIButton *)tagButton
{
    if(!_tagButton) {
        _tagButton = [[UIButton alloc] init];
        _tagButton.titleLabel.font = Font(9);
        _tagButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _tagButton.titleLabel.textColor = self.color;
        [_tagButton setTitle:self.tagText forState:UIControlStateNormal];
        [_tagButton setTitleColor:self.color forState:UIControlStateNormal];
        _tagButton.titleLabel.text = self.tagText;
    }
    return _tagButton;
}

@end
