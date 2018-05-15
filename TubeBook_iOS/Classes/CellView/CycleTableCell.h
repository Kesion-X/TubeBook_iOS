//
//  CycleTableCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"
#import "SDCycleScrollView.h"
#define kCycleTableCellCycleImageTap [NSStringFromClass([CycleTableCell class]) stringByAppendingString:@"cycleImageTap"]

@interface CycleTableCell : CKTableCell <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

- (void)loadData:(NSArray *)titles imageUrls:(NSArray *)imagesURLs;

@end
