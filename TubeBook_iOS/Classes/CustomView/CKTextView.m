//
//  CKTextView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTextView.h"
#import "ChatKitSetting.h"
#import "Masonry.h"
#import "CKMacros.h"
#import "UIView+TubeFrameMargin.h"
#import <objc/runtime.h>

@implementation CKTextView


- (void)dealloc
{
    self.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:17];
        if (self.showPlaceholderText) {
            [self addSubviewsAndConstraints];
        }
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.overrideNextResponder) {
        if ([NSStringFromSelector(action) hasPrefix:@"ck_menuAction_"]) {
            return YES;
        }
        return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    Method m = class_getInstanceMethod([self class], @selector(resolve:));
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(m)];
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *selString = NSStringFromSelector(anInvocation.selector);
    if ([self.overrideNextResponder respondsToSelector:@selector(resolve:)]) {
        anInvocation.target = self.overrideNextResponder;
        NSInteger menuType = [[selString stringByReplacingOccurrencesOfString:@"ck_menuAction_" withString:@""] intValue];
        [anInvocation setArgument:&menuType atIndex:2];
    } else {
        anInvocation.target = self;
        [anInvocation setArgument:&selString atIndex:2];
    }
    
    anInvocation.selector = @selector(resolve:);
    [anInvocation invoke];
}

- (void)resolve:(NSString *)selString
{
    // do nothing;
}

- (void)cut:(id)sender
{
    [self copy:sender];
    
    NSMutableAttributedString *originalString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [originalString deleteCharactersInRange:self.selectedRange];
    self.attributedText = originalString;
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void)copy:(id)sender
{
    NSAttributedString *selectedString = [self.textStorage attributedSubstringFromRange:self.selectedRange];
    NSString *copyString = [self stringFromAtrributedtext:selectedString];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (copyString.length != 0) {
        pboard.string = copyString;
    }
}

- (NSString *)stringFromAtrributedtext:(NSAttributedString *)attibuteText
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attibuteText];
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:NSClassFromString(@"DXAtAttachment")]) {
            NSString *name = [value valueForKey:@"name"];
            NSString *fullString = [NSString stringWithFormat:@"@%@ ",name];
            [attributeString replaceCharactersInRange:range withString:fullString];
        }
    }];
    return attributeString.string;
}

- (void)addSubviewsAndConstraints
{
    [self addSubview:self.placeholderLabel];
    
    if (IOS8) {
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(6);
            make.centerY.equalTo(self.mas_centerY);
        }];
    } else {
        self.placeholderLabel.width = 120;
        self.placeholderLabel.height = 20;
        self.placeholderLabel.left = 6;
        self.placeholderLabel.centerY = self.centerY;
    }
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.text = @"输入消息...";
        _placeholderLabel.textColor = HEXCOLOR(0xbbbbbb);
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
    }
    return _placeholderLabel;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
