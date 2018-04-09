//
//  TubeArticleConst.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/31.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

// 关注或全部
typedef NS_ENUM(NSInteger, FouseType)
{
    FouseTypeAttrent,
    FouseTypeAll
};

// 文章类型 普通 专题 连载
typedef NS_ENUM(NSInteger, ArticleType)
{
    ArticleTypeMornal = 0x001,
    ArticleTypeTopic = 0x010,
    ArticleTypeSerial = 0x100
};


@interface TubeArticleConst : NSObject

@end
