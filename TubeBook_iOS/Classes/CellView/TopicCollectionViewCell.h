//
//  TopicCollectionViewCell.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/14.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKCollectionViewCell.h"

@interface TopicCollectionViewCell : CKCollectionViewCell

@property ( nonatomic, strong) NSString *title;
@property ( nonatomic, strong) NSString *countAttent;
@property ( nonatomic, strong) NSString *topicImageUrl;

@property ( nonatomic, strong) UILabel *countAttentLable;
@property ( nonatomic, strong) UILabel *titleLable;
@property ( nonatomic, strong) UIImageView *topicImageView;

@end
