//
//  TagCollectionView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITagView.h"

@interface TagCollectionView : UIScrollView

- (void)addTagsObject:(UITagView *)tag;
- (NSArray *)getSelectesArray; // string
- (NSArray *)getSelectesArrayTagView; // tagview

@end
