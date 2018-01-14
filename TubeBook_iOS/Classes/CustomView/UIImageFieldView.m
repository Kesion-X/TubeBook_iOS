//
//  UIImageFieldView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIImageFieldView.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "ReactiveObjC.h"

@interface UIImageFieldView ()

@property (nonatomic) BOOL isSecret;
@property (nonatomic) BOOL isClose;
@property (nonatomic,strong) NSString *placeholder;
@property (nonatomic,strong) NSString *imagePath;

@end

@implementation UIImageFieldView

- (instancetype)initUIImageFieldView:( NSString * _Nonnull )imagePath placeholder:(NSString *)placeholder isSecret:(BOOL)isSecret
{
    self = [super init];
    if (self) {
        _imagePath = imagePath;
        _placeholder = placeholder;
        _isClose = YES;
        _isSecret = isSecret;
        [self initSet];
        [self addView];
        [self addConstraint];
        [self installListener];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame rightImage:( NSString * _Nonnull )imagePath placeholder:(NSString *)placeholder isSecret:(BOOL)isSecret
{
    if (self = [super initWithFrame:frame]) {
        _imagePath = imagePath;
        _placeholder = placeholder;
        _isClose = YES;
        _isSecret = isSecret;
        [self initSet];
        [self addView];
        [self addConstraint];
        [self installListener];
    }
    return self;
}

#pragma private
- (void)initSet
{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = HEXACOLOR(0xffffff, 0.6);
}

- (void)addView
{
    [self addSubview:self.rightImage];
    [self addSubview:self.field];
    [self addSubview:self.clearButton];
    [self addSubview:self.seeButton];
}

- (void)addConstraint
{
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
        make.centerY.mas_equalTo(self);
    }];
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightImage.mas_right).offset(8);
        make.height.mas_equalTo(24);
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.mas_equalTo(self);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.field.mas_right).offset(-8);
        make.centerY.mas_equalTo(self);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    [self.seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.clearButton.mas_left).offset(-8);
        make.centerY.mas_equalTo(self);
        make.height.equalTo(@12);
        make.width.equalTo(@12);
    }];
}

- (void)installListener
{
    @weakify(self);
    if (_isSecret) {
        [[_seeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (_isClose) {
                _field.secureTextEntry = NO;
                [_seeButton setBackgroundImage:[UIImage imageNamed:@"icon_open_see"] forState:UIControlStateNormal];
            }else{
                _field.secureTextEntry = YES;
                [_seeButton setBackgroundImage:[UIImage imageNamed:@"icon_close_see"] forState:UIControlStateNormal];
            }
            _isClose = !_isClose;
        }];
    }
    
    [[_field rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (_fieldBlock) {
            _fieldBlock(x);
        }
        if (_delegate) {
            [_delegate fieldChange:x];
        }
        if (x.length>0) {
            _clearButton.hidden = NO;
            if (_isSecret) {
                _seeButton.hidden = NO;
            }
        }else{
            _clearButton.hidden = YES;
            if (_isSecret) {
                _seeButton.hidden = YES;
            }
        }
    }];
    
    [[_clearButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        _field.text = @"";
        _clearButton.hidden = YES;
        if (_isSecret) {
            _seeButton.hidden = YES;
        }
    }];
}

#pragma -mark get
- (UIImageView *)rightImage
{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] init];
        [_rightImage setImage:[UIImage imageNamed:_imagePath]];
    }
    return _rightImage;
}

- (UITextField *)field
{
    if (!_field) {
        _field = [[UITextField alloc] init];
        _field.font = Font(14);
        _field.textColor = kTEXTCOLOR;
        _field.placeholder = _placeholder;
        if (_isSecret) {
            _field.secureTextEntry = YES;
        }
    }
    return _field;
}

- (UIButton *)clearButton
{
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] init];
        [_clearButton setBackgroundImage:[UIImage imageNamed:@"icon_delect"] forState:UIControlStateNormal];
        _clearButton.hidden = YES;
    }
    return _clearButton;
}

- (UIButton *)seeButton
{
    if (!_seeButton) {
        _seeButton = [[UIButton alloc] init];
        [_seeButton setBackgroundImage:[UIImage imageNamed:@"icon_close_see"] forState:UIControlStateNormal];
        _seeButton.hidden = YES;
    }
    return _seeButton;
}

- (void)setFieldChangeBlock:(fieldChangeBlock _Nullable )fieldBlock{
    _fieldBlock = fieldBlock;
}

@end
