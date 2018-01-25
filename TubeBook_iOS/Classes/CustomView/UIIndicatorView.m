//
//  UIIndicatorView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIIndicatorView.h"
#import "NSString+StringKit.h"
#import "NSString+StringKit.h"
#import "CKMacros.h"
#import "UIView+TubeFrameMargin.h"

#define kINDICATOR_MARGIN_TB 8
#define kINDICATOR_MARGIN_LR 8
#define kITEM_MARGIN_LR 16
#define kITEM_MARGIN_TB 4
#define kITEM_HEIGHT 18
#define kINDICATOR_VIEW_HEIGHT (kITEM_HEIGHT+kITEM_MARGIN_TB*2+kINDICATOR_MARGIN_TB*2)


@interface UIIndicatorView ()

@property (nonatomic) CGFloat leftPointDraw;
@property (nonatomic) CGFloat topPointDraw;

@property (nonatomic) CGFloat indicatorWidth;//滑块宽度，滑动时indicator 宽度可能发生改变
@property (nonatomic) CGFloat indicatorHeight;//滑块高度
@property (nonatomic) CGFloat indicatorY;//滑块y坐标
@property (nonatomic) BOOL isEnableAutoScroll;

@property (nonatomic) NSUInteger contentHeight;//内容高度 item_height+tb_margin*2
@property (nonatomic) UIFont *contentFont;//内容字体

@property (nonatomic, strong) UIColor *textNormalColor;
@property (nonatomic, strong) UIColor *textLightColor;


@end

@implementation UIIndicatorView
{
    CGFloat currentIndicatorOfferX;
    CGFloat currentIndicatorWidth;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showsHorizontalScrollIndicator = FALSE;
        self.isEnableAutoScroll = YES;
        self.leftPointDraw = kINDICATOR_MARGIN_LR;
        self.topPointDraw = kINDICATOR_MARGIN_TB;
        self.itemArrays = [[NSMutableArray alloc] init];
        self.height = [NSString getSizeWithAttributes:@"K" font:self.contentFont].height+kITEM_MARGIN_TB*2+kINDICATOR_MARGIN_TB*2;//设定高度为item控件高度+边距
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor font:(UIFont *)font;
{
    self = [self init];
    if (self) {
        self.indicatorColor = indicatorColor;
        self.style = UIIndicatorViewDefaultStyle;
        self.contentFont = font;
        self.textNormalColor = kTEXTCOLOR;
        self.textLightColor = HEXCOLOR(0xdddddd);
        [self initIndicator];
    }
    return self;
}

- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor
                              frame:(CGRect)frame
                             arrays:(NSMutableArray *)arrays
                               font:(UIFont *)font
                    textNormalColor:(UIColor *)textNormalColor
                     textLightColor:(UIColor *)textLightColor
{
    self = [self init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor
                              style:(UIIndicatorViewStyle)style
                             arrays:(NSMutableArray *)arrays
                               font:(UIFont *)font
                    textNormalColor:(UIColor *)textNormalColor
                     textLightColor:(UIColor *)textLightColor
                 isEnableAutoScroll:(BOOL)isEnableAutoScroll;
{
    self = [self init];
    if (self) {
        self.indicatorColor = indicatorColor;
        self.style = style;
        self.contentFont = font;
        self.textNormalColor = textNormalColor;
        self.textLightColor = textLightColor;
        for (NSString *str in arrays) {
            [self addIndicatorItemByString:str];
        }
        self.isEnableAutoScroll = isEnableAutoScroll;
        [self initIndicator];
    }
    return self;
}

- (void)initIndicator
{
    self.indicatorView = [[UIView alloc] init];
    [self.indicatorView setBackgroundColor:self.indicatorColor];
    switch (self.style) {
        case UIIndicatorViewDefaultStyle:
            {
                self.indicatorView.layer.cornerRadius = (8+[NSString getSizeWithAttributes:@"K" font:self.contentFont].height)/2;
                self.indicatorHeight = [NSString getSizeWithAttributes:@"K" font:self.contentFont].height+kITEM_MARGIN_TB*2;
                self.indicatorY = self.topPointDraw;
                self.indicatorView.layer.masksToBounds = YES;
                break;
            }
        case UIIndicatorViewLineStyle:
            {
                self.indicatorHeight = kINDICATOR_MARGIN_LR/4;
                self.indicatorY = [NSString getSizeWithAttributes:@"K" font:self.contentFont].height+kITEM_MARGIN_TB*2 + kINDICATOR_MARGIN_LR;
                break;
            }
        default:
            break;
    }
    [self addSubview:self.indicatorView];
}

- (void)addIndicatorItemByString:(NSString *)item
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:item forState:UIControlStateNormal];
    button.titleLabel.font = self.contentFont;
    [button setTitleColor:self.textNormalColor forState:UIControlStateNormal];
    button.frame = CGRectMake(self.leftPointDraw,
                              self.topPointDraw,
                              [NSString getSizeWithAttributes:item font:self.contentFont].width+kITEM_MARGIN_LR*2,
                              [NSString getSizeWithAttributes:item font:self.contentFont].height+kITEM_MARGIN_TB*2);
    [super addSubview:button];
    [button setTag:self.itemArrays.count];
    [self.itemArrays addObject:button];
    self.leftPointDraw += button.frame.size.width;
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.contentSize = CGSizeMake(self.leftPointDraw+kINDICATOR_MARGIN_LR, 0);
}

- (IBAction)click:(id)sender
{
    UIButton *bt =  sender;
    if (self.currentIndicator != bt.tag) {
        self.currentIndicator = bt.tag;
        CGFloat width = bt.frame.size.width;
        CGFloat x = bt.frame.origin.x;
        if (self.style == UIIndicatorViewLineStyle) {
            width -= (kITEM_MARGIN_LR*2);
            x += (kITEM_MARGIN_LR);
        }
        self.indicatorView.frame = CGRectMake(x, self.indicatorY, width, self.indicatorHeight);
        [self updateItemTitleColor];
        [self autoScrollerRight];
        [self autoScrollerLeft];
        if (self.delegate) {
            [self.delegate indicatorItemsClick:bt.tag];
        }
    }
}

- (void)changeIndicatorViewSize:(BOOL)isRight scale:(CGFloat)scale;
{
    if (isRight) {
        if (self.currentIndicator!=self.itemArrays.count-1) {
            UIView *currentV =  [self.itemArrays objectAtIndex:self.currentIndicator];
            UIView *rightV = [self.itemArrays objectAtIndex:self.currentIndicator+1];
            CGFloat offsetX = currentV.frame.size.width * scale;
            CGFloat scaleWidth = (rightV.frame.size.width - currentV.frame.size.width) *scale;
            self.indicatorView.frame = CGRectMake(currentIndicatorOfferX + offsetX, self.indicatorY, currentIndicatorWidth + scaleWidth, self.indicatorHeight);
        }
    }else{
        if (self.currentIndicator!=0) {
            UIView *currentV =  [self.itemArrays objectAtIndex:self.currentIndicator];
            UIView *leftV = [self.itemArrays objectAtIndex:self.currentIndicator-1];
            CGFloat offsetX = leftV.frame.size.width * scale;
            CGFloat scaleWidth = (leftV.frame.size.width - currentV.frame.size.width) *scale;
            self.indicatorView.frame = CGRectMake(currentIndicatorOfferX - offsetX, self.indicatorY, currentIndicatorWidth + scaleWidth, self.indicatorHeight);
        }
    }
}

- (void)autoScrollerRight
{
    if (!self.isEnableAutoScroll) {
        return;
    }
    UIView *currentBt = [_itemArrays objectAtIndex:self.currentIndicator];
    if (currentBt.frame.size.width > (self.frame.size.width + self.contentOffset.x - (currentBt.frame.origin.x + currentBt.frame.size.width))) {
        if (self.currentIndicator == _itemArrays.count-1) {
            CGFloat offsetRight = (currentBt.frame.origin.x + currentBt.frame.size.width) - (self.frame.size.width + self.contentOffset.x);
              [self setContentOffset:CGPointMake(self.contentOffset.x+offsetRight, 0) animated:YES];
        }
        if (self.currentIndicator != _itemArrays.count-1) {
            currentBt = [_itemArrays objectAtIndex:self.currentIndicator+1];
            CGFloat offsetRight = currentBt.frame.origin.x+currentBt.frame.size.width - (self.contentOffset.x+self.frame.size.width);
            
            [self setContentOffset:CGPointMake(self.contentOffset.x+offsetRight, 0) animated:YES];
        }
    }
}

- (void)autoScrollerLeft
{
    if (!self.isEnableAutoScroll) {
        return;
    }
    UIView *currentBt = [_itemArrays objectAtIndex:self.currentIndicator];
    if (currentBt.frame.size.width > (currentBt.frame.origin.x - self.contentOffset.x)) {
        if (self.currentIndicator == 0) {
            CGFloat offsetLeft = self.contentOffset.x - currentBt.frame.origin.x;
            [self setContentOffset:CGPointMake(self.contentOffset.x-offsetLeft, 0) animated:YES];
        }
        if (self.currentIndicator != 0) {
             currentBt = [_itemArrays objectAtIndex:self.currentIndicator-1];
            CGFloat offsetLeft = self.contentOffset.x - currentBt.frame.origin.x;
            [self setContentOffset:CGPointMake(self.contentOffset.x-offsetLeft, 0) animated:YES];
        }
    }
}

- (void)addIndicatorItemByView:(UIButton *)item
{
    [super addSubview:item];
}

- (CGFloat)getUIHeight
{
    return [NSString getSizeWithAttributes:@"K" font:self.contentFont].height+kITEM_MARGIN_TB*2+kINDICATOR_MARGIN_TB*2;
}

- (CGFloat)getUIWidth
{
    CGFloat w = kINDICATOR_MARGIN_TB*2;
    for (UIView *v in self.itemArrays) {
        w += v.frame.size.width;
    }
    return w;
}

- (void)updateItemTitleColor
{
    for (UIButton *bt in _itemArrays) {
        if ([_itemArrays objectAtIndex:self.currentIndicator] == bt) {
            [bt setTitleColor:self.textLightColor forState:UIControlStateNormal];
        }else{
            [bt setTitleColor:self.textNormalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setShowIndicatorItem:(NSUInteger)index
{
    self.currentIndicator = index;
    UIButton *bt =  [self.itemArrays objectAtIndex:index];
    CGFloat width = bt.frame.size.width;
    CGFloat x = bt.frame.origin.x;
    if (self.style == UIIndicatorViewLineStyle) {
        width -= (kITEM_MARGIN_LR*2);
        x += (kITEM_MARGIN_LR);
    }
    self.indicatorView.frame = CGRectMake(x, self.indicatorY, width, self.indicatorHeight);
    self.currentIndicator = bt.tag;
    [self updateItemTitleColor];
    [self autoScrollerRight];
    [self autoScrollerLeft];
}

- (void)setCurrentIndicator:(NSUInteger)currentIndicator
{
    _currentIndicator = currentIndicator;
    UIView *v = [self.itemArrays objectAtIndex:self.currentIndicator];
    if (self.style == UIIndicatorViewLineStyle) {
        currentIndicatorOfferX = v.frame.origin.x + kITEM_MARGIN_LR;
        currentIndicatorWidth = v.frame.size.width - (kITEM_MARGIN_LR*2);
    } else {
        currentIndicatorOfferX = v.frame.origin.x;
        currentIndicatorWidth = v.frame.size.width;
    }
}

@end
