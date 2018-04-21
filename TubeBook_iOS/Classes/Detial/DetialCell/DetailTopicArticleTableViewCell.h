//
//  DetailTopicArticleTableViewCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKTableCell.h"

@interface DetailTopicArticleTableViewCell : CKTableCell

@property (nonatomic, strong) NSString *articleImageUrl;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleUserName;
@property (nonatomic, strong) NSString *articleTime;

@property (nonatomic, strong) UIImageView *articleImageView;
@property (nonatomic, strong) UILabel *articleTitleLable;
@property (nonatomic, strong) UILabel *articleUserNameLable;
@property (nonatomic, strong) UILabel *articleTimeLable;

@end
