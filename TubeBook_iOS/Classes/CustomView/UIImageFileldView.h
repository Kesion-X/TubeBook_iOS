//
//  UIImageFileldView.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/13.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIImageFileldViewDelegate <NSObject>

- (void)fieldChange:(NSString *)text;

@end

@interface UIImageFileldView : UIView

@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *seeButton;
@property (nonatomic, weak) id<UIImageFileldViewDelegate> delegate;

- (instancetype)initUIImageFileldView:( NSString * _Nonnull )imagePath placeholder:(NSString *_Nonnull)placeholder isSecret:(BOOL)isSecret ;
- (instancetype _Nonnull )initWithFrame:(CGRect)frame rightImage:( NSString * _Nonnull )imagePath placeholder:(NSString *_Nonnull)placeholder isSecret:(BOOL)isSecret;


@end
