//
//  AltertControllerUtil.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AltertControllerUtil.h"
#import "CKMacros.h"

@implementation AltertControllerUtil

+ (void)showAlertTitle:(NSString *)title
               message:(NSString *)message
          confirmTitle:(NSString *)confirmTitle
          confirmBlock:(void (^)(void))confirmBlock
           cancelTitle:(NSString *)cancelTitle
           cancelBlock:(void (^)(void))cancelBlock
         fromControler:(UIViewController *)sourceController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = HEXCOLOR(0x396FCC);
    if (confirmTitle) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmBlock) {
                confirmBlock();
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [alertController addAction:confirmAction];
    }
    
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [alertController addAction:cancelAction];
    }
    [sourceController presentViewController:alertController animated:YES completion:nil];
}
    
@end
