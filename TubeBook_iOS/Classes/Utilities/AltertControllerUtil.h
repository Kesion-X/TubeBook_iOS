//
//  AltertControllerUtil.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AltertControllerUtil : NSObject

+ (void)showAlertTitle:(NSString *)title
               message:(NSString *)message
          confirmTitle:(NSString *)confirmTitle
          confirmBlock:(void (^)(void))confirmBlock
           cancelTitle:(NSString *)cancelTitle
           cancelBlock:(void (^)(void))cancelBlock
         fromControler:(UIViewController *)sourceController;
    
@end
