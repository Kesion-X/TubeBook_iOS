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

#define kINDICATOR_MARGIN_TB 8
#define kINDICATOR_MARGIN_LR 8
#define kITEM_MARGIN_LR 16
#define kITEM_MARGIN_TB 4
#define kITEM_HEIGHT 18
#define kINDICATOR_VIEW_HEIGHT (kITEM_HEIGHT+kITEM_MARGIN_TB*2+kINDICATOR_MARGIN_TB*2)


@interface UIIndicatorView ()

@property (nonatomic) CGFloat leftPointDraw;
@property (nonatomic) CGFloat topPointDraw;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIColor *indicatorColor;//滑块背景
@property (nonatomic) CGFloat indicatorWidth;//滑块宽度，滑动时indicator 宽度可能发生改变
@property (nonatomic) CGFloat indicatorHeight;//滑块高度
@property (nonatomic) NSUInteger currentIndicator;//当前滑块位置

@property (nonatomic) NSUInteger contentHeight;//内容高度 item_height+tb_margin*2
@property (nonatomic) UIFont *contentFont;//内容字体
@property (nonatomic,strong) NSMutableArray *itemArrays;

@end

@implementation UIIndicatorView

- (instancetype)initUIIndicatorView:(UIColor *)indicatorColor font:(UIFont *)font;
{
    self = [super init];
    if (self) {
        self.indicatorColor = indicatorColor;
        self.leftPointDraw = kINDICATOR_MARGIN_LR;
        self.topPointDraw = kINDICATOR_MARGIN_TB;
        self.contentFont = font;
        self.currentIndicator = -1;
        self.itemArrays = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.size.height =  [NSString getSizeWithAttributes:@"K" font:self.contentFont].height+kITEM_MARGIN_TB*2+kINDICATOR_MARGIN_TB*2;
        self.frame = frame;//设定高度为item控件高度+边距
        [self setBackgroundColor:[UIColor whiteColor]];
        [self initIndicator];
    }
    return self;
}

- (void)initIndicator
{
    _indicatorView = [[UIView alloc] init];
    [_indicatorView setBackgroundColor:kTUBEBOOK_THEME_NORMAL_COLOR];
    _indicatorView.layer.cornerRadius = [NSString getSizeWithAttributes:@"K" font:self.contentFont].height;
    _indicatorView.layer.masksToBounds = YES;
    [self addSubview:self.indicatorView];
}

- (void)addIndicatorItemByString:(NSString *)item
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:item forState:UIControlStateNormal];
    [button setTitleColor:kTEXTCOLOR forState:UIControlStateNormal];
    button.frame = CGRectMake(self.leftPointDraw, self.topPointDraw, [NSString getSizeWithAttributes:item font:self.contentFont].width+kITEM_MARGIN_LR*2, [NSString getSizeWithAttributes:item font:self.contentFont].height+kITEM_MARGIN_TB*2);
    [super addSubview:button];
    [button setTag:self.itemArrays.count];
    [self.itemArrays addObject:button];
    self.leftPointDraw += button.frame.size.width;
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.contentSize = CGSizeMake(self.leftPointDraw+kINDICATOR_MARGIN_LR, 0);
    //self.contentOffset
   
}

- (IBAction)click:(id)sender
{
    UIButton *bt =  sender;
    self.indicatorView.frame = bt.frame;
    self.currentIndicator = bt.tag;
    [self updateItemTitleColor];
    [self autoScrollerRight];
    [self autoScrollerLeft];
}

- (void)autoScrollerRight
{
    UIView *currentBt = [_itemArrays objectAtIndex:self.currentIndicator];
    if (currentBt.frame.size.width > (self.frame.size.width + self.contentOffset.x - (currentBt.frame.origin.x + currentBt.frame.size.width))) {
        if (self.currentIndicator!=_itemArrays.count-1) {
            currentBt = [_itemArrays objectAtIndex:++self.currentIndicator];
            CGFloat offsetRight = currentBt.frame.origin.x+currentBt.frame.size.width - (self.contentOffset.x+self.frame.size.width);
            
            [self setContentOffset:CGPointMake(self.contentOffset.x+offsetRight, 0) animated:YES];
        }
    }
}

- (void)autoScrollerLeft
{
    UIView *currentBt = [_itemArrays objectAtIndex:self.currentIndicator];
    if (currentBt.frame.size.width > (currentBt.frame.origin.x - self.contentOffset.x)) {
        if (self.currentIndicator!=0) {
             currentBt = [_itemArrays objectAtIndex:--self.currentIndicator];
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

- (void)updateItemTitleColor
{
    for (UIButton *bt in _itemArrays) {
        if ([_itemArrays objectAtIndex:self.currentIndicator]==bt) {
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [bt setTitleColor:kTEXTCOLOR forState:UIControlStateNormal];
        }
    }
}

@end