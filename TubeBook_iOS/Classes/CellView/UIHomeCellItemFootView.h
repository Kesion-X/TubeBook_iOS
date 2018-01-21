//
//  UIHomeCellItemFootView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHomeCellItemFootView : UIView

@property(nonatomic, strong) NSString *pulibshUserName;
@property(nonatomic) NSUInteger commentCount;
@property(nonatomic) NSUInteger likeCount;

@property(nonatomic, strong) UILabel *pulibshUserNameLable;
@property(nonatomic, strong) UILabel *commentCountLable;
@property(nonatomic, strong) UILabel *likeCountLable;

- (instancetype)initUIHomeCellItemFootView:(NSString *)pulibshUserName commentCount:(NSUInteger)commentCount likeCount:(NSUInteger)likeCount;
- (NSUInteger)getUIHeight;

@end
