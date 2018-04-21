//
//  UIWaterfallCollectionViewLayout.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "UIWaterfallCollectionViewLayout.h"

#define colMargin 16
#define colCount 2
#define rolMargin 16

@interface UIWaterfallCollectionViewLayout ()

//数组存放每列的总高度
@property(nonatomic,strong)NSMutableArray* colsHeight;
//单元格宽度
@property(nonatomic,assign)CGFloat colWidth;
@property(nonatomic)NSUInteger colNumber;

@end

@implementation UIWaterfallCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.colNumber = colCount;
    }
    return self;
}

- (instancetype)initUIWaterfallCollectionViewLayout:(NSUInteger)colNumber
{
    self = [super init];
    if (self) {
        self.colNumber = colNumber;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.colWidth =( self.collectionView.frame.size.width - (self.colNumber+1)*colMargin )/self.colNumber;
    self.colsHeight = nil;
}

-(CGSize)collectionViewContentSize{
    NSNumber * longest = self.colsHeight[0];
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(longest.floatValue<rolHeight.floatValue){
            longest = rolHeight;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, longest.floatValue);
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSNumber * shortest = self.colsHeight[0];
    NSInteger  shortCol = 0;
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(shortest.floatValue>rolHeight.floatValue){
            shortest = rolHeight;
            shortCol=i;
        }
    }
    CGFloat x = (shortCol+1)*colMargin+ shortCol * self.colWidth;
    CGFloat y = shortest.floatValue+colMargin;
    CGFloat height=0;
   // NSAssert(self.delegate==nil, @"未实现计算高度的block ");
    if(self.delegate){
        height = [self.delegate collectionViewLayout:self heightForRowAtIndexPath:indexPath];
    }
    attr.frame= CGRectMake(x, y, self.colWidth, height);
    self.colsHeight[shortCol]=@(shortest.floatValue+colMargin+height);
    
    return attr;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* array = [NSMutableArray array];
//    NSInteger sessions = [self.collectionView numberOfSections];
//    for (int j=0; j<sessions; ++j) {
        NSInteger items = [self.collectionView numberOfItemsInSection:0];
        for (int i = 0; i<items;i++) {
            UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [array addObject:attr];
        }
//    }
    return array;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(NSMutableArray *)colsHeight{
    if(!_colsHeight){
        NSMutableArray * array = [NSMutableArray array];
        for(int i =0;i<self.colNumber;i++){
            [array addObject:@(0)];
        }
        _colsHeight = [array mutableCopy];
    }
    return _colsHeight;
}

@end
