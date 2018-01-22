//
//  TopicArticleContent.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKContent.h"

@interface TopicArticleContent : CKContent

@property (nonatomic, strong) NSString *tagImageUrl;//专题/连载图片
@property (nonatomic, strong) NSString *title;//专题/连载标题
@property (nonatomic, strong) NSString *articleTag;//专题/连载标签

@end
