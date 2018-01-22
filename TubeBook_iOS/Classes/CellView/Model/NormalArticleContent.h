//
//  NormalArticleContent.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/22.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKContent.h"

@interface NormalArticleContent : CKContent

@property(nonatomic, strong) NSString *contentUrl;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *contentDescription;

@end
