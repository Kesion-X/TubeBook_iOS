//
//  CKCollectionViewCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKDataType.h"
#import "CKContent.h"

@interface CKCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) CKContent *content;


- (CGFloat)getCellHeight;
+ (CGFloat)getCellHeight:(CKContent *)content;

+ (NSString *)getDequeueId:(CKDataType *)type;

@end
