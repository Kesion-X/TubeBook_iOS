//
//  TubeCollectionView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/18.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMegin 5

@protocol TubeCollectionViewDelegate  <NSObject>

- (void)collectionItemView:(UIView *)itemView index:(NSInteger)index;

@end

@interface TubeCollectionView : UIScrollView

@property (nonatomic, weak) id <TubeCollectionViewDelegate> tubeCollectionDelegate;
- (void)addItemView:(UIView *)view;

@end
