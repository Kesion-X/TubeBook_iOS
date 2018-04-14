//
//  CKCollectionViewCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKCollectionViewCell.h"

@implementation CKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (NSString *)getDequeueId:(CKDataType *)type // 暂时不要改动
{
    return NSStringFromClass(self);
}


@end
