//
//  CKIndicatorMessageCenterView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CKCenterView.h"

@interface CKIndicatorMessageCenterView : CKCenterView

@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (instancetype)initIndicatorMessageCenterViewWithMessage:(NSString *)message;


@end
