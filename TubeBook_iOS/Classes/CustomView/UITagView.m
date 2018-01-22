
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
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = color.CGColor;
        self.layer.masksToBounds = YES;
        [self addSubview:self.tagLable];
        size = [NSString getSizeWithAttributes:tagText font:self.tagLable.font];
        [self.tagLable mas_makeConstraints:^(MASConstraintMaker *make) {
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
    return size.width+4*2;
}

#pragma mark - get
- (UILabel *)tagLable
{
    if(!_tagLable) {
        _tagLable = [[UILabel alloc] init];
        _tagLable.font = Font(9);
        _tagLable.textColor = self.color;
        _tagLable.text = self.tagText;
    }
    return _tagLable;
}

@end
