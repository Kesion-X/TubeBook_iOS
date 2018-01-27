//
//  UIWaterfallCollectionViewLayout.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIWaterfallCollectionViewLayoutDelegate <NSObject>

@optional
- (CGFloat)collectionViewLayout:(UICollectionViewLayout *)collectionViewLayout heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface UIWaterfallCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) id<UIWaterfallCollectionViewLayoutDelegate> delegate;

- (instancetype)initUIWaterfallCollectionViewLayout:(NSUInteger)colNumber;

@end
