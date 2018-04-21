//
//  TubeTableView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeTableView.h"
#import "CKMacros.h"
#import "Masonry.h"
#define kLineHeight 0.5f
#define kMargin 8
#define kItemHeight 40

@interface TubeTableView ()

@property (nonatomic, strong) NSMutableArray *itemLineViews;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *downLine;

@end


@implementation TubeTableView
{
    CGFloat width;
}

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [self initWithFrame:CGRectMake(0, 0, width, 0)];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemViews = [[NSMutableArray alloc] init];
        self.itemLineViews = [[NSMutableArray alloc] init];

        width = frame.size.width;
        
        self.topLine = [self createLineView];
        [self.itemLineViews addObject:self.topLine];
        [self addSubview:self.topLine];
        self.downLine = [self createLineView];
        [self.itemLineViews addObject:self.downLine];
        [self addSubview:self.downLine];
    }
    return self;
}

- (void)addItemView:(UIView *)view
{
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:singleTap];
    view.tag = self.itemViews.count;
    
    if (self.itemViews.count >= 1) {
        UIView *line = [self createLineView];
        [self.itemLineViews addObject:line];
        [self addSubview:line];
    }
    [self.itemViews addObject:view];
    [self addSubview:view];
    [self updateLayout];
}

- (void)updateLayout
{
    CGFloat y = kLineHeight;
    self.topLine.frame = CGRectMake(0, 0, width, kLineHeight);
    for (int i=0; i<self.itemViews.count; ++i) {
        UIView *itemV = [self.itemViews objectAtIndex:i];
        itemV.frame = CGRectMake( kMargin, y, width - kMargin*2, itemV.frame.size.height);
        y += itemV.frame.size.height+1;
        if ( i!=self.itemViews.count-1 ) {
            UIView *lineV = [self.itemLineViews objectAtIndex:i];
            lineV.frame = CGRectMake( kMargin, y, width - kMargin, kLineHeight);
            y += kLineHeight+1;
        }
    }
    self.downLine.frame = CGRectMake(0, y, SCREEN_WIDTH, kLineHeight);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, y);

    [self layoutIfNeeded];
}

- (UIView *)createLineView
{
    UIView *lineV= [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kLineHeight)];
    lineV.backgroundColor = HEXCOLOR(0xcdcdcd);
    return lineV;
}


- (void)tapClick:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSUInteger tag = [singleTap view].tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableItemView:index:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate tableItemView:[singleTap view] index:tag];
        });
    }
}

@end
