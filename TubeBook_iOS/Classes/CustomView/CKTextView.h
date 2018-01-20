//
//  CKTextView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/16.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKTextView : UITextView

@property (nonatomic, assign) BOOL showPlaceholderText; // 输入框PlaceholderText
@property (nonatomic, weak) UIResponder *overrideNextResponder;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end
