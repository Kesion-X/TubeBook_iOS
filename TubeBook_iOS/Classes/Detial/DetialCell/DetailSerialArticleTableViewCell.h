//
//  DetailSerialArticleTableViewCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKContent.h"
#import "CKTableCell.h"

@interface DetailSerialArticleTableViewCell : CKTableCell

@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleTime;

@property (nonatomic, strong) UILabel *articleTitleLable;
@property (nonatomic, strong) UILabel *articleTimeLable;

@end
