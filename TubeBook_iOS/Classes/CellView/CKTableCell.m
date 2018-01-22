//
//  CKTableCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"
#import "UINormalArticleCell.h"

@implementation CKTableCell

- (instancetype)initWithDateType:(CKDataType *)type{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CKTableCell getDequeueId:type]];
    if (self) {
        
    }
    return self;
}

+ (NSString *)getDequeueId:(CKDataType *)type
{
    if ([self isKindOfClass:[UINormalArticleCell class]]) {
        return [NSString stringWithFormat:@"%@%d",NSStringFromClass([self class]),type.isHaveImage] ;
    }
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
