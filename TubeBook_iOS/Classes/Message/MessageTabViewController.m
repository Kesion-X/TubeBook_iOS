//
//  MessageTabViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "MessageTabViewController.h"
#import "CKTextView.h"
#import "Masonry.h"
#import "TagCollectionView.h"
#import "UITagView.h"
#import "LCActionSheet.h"

@interface MessageTabViewController ()

@end

@implementation MessageTabViewController
CKTextView *ckTextView ;
UIView *board;

TagCollectionView *tagC;

- (void)viewDidLoad {
    [super viewDidLoad];
    ckTextView = [[CKTextView alloc] init];
    [self.view addSubview:ckTextView];
    [ckTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(72);
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
        make.height.equalTo(@42);
    }];
    ckTextView.layer.borderWidth = 0.5;
    ckTextView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UITextView *textView = [[UITextView alloc] init];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(120);
        make.left.equalTo(self.view).offset(32);
        make.right.equalTo(self.view).offset(-32);
        make.height.equalTo(@42);
    }];
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    //[ckTextView setBackgroundColor:[UIColor grayColor]];
    
    UIButton *show = [[UIButton alloc] init];
    [self.view addSubview:show];
    [show setTitle:@"show" forState:UIControlStateNormal];
    [show setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [show mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@140);
        make.left.equalTo(self.view).offset(120);
    }];
    [show addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    board = [[UIView alloc] init];
     [self.view addSubview:board];
    [board mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@210);
    }];
    [board setBackgroundColor:[UIColor blueColor]];
    board.hidden = YES;
    UILabel *b = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 60, 34)];
    b.text = @"ddad";
    b.textColor = [UIColor blackColor];
    [board addSubview:b];
    
    UIView *input = [[UIView alloc] init];
    [self.view addSubview:input];
    [input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(board.mas_top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@48);
    }];
    [input setBackgroundColor:[UIColor grayColor]];
    
    tagC = [[TagCollectionView alloc] initWithFrame:CGRectMake(20, 200, 300, 100)];
   // [tagC setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:tagC];
    
}

- (IBAction)click:(id)sender
{
    
    [tagC addTagsObject:[[UITagView alloc] initUITagView:@"kesion" color:[UIColor grayColor]]];
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"选择" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            NSLog(@"kkkk");
        } else if (buttonIndex == 2){
            NSLog(@"dddd");
            
        }
        
    } otherButtonTitleArray:@[@"K", @"D"] ];
    [sheet show];
   // [ckTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
//
//    if (board.hidden) {
//         [ckTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
//        board.hidden = NO;
//
//        [board mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_bottom).offset(-210);
//        }];
//        [board setNeedsUpdateConstraints]; //通知系统视图中的约束需要更新
//        [board updateConstraintsIfNeeded]; //
//        [UIView animateWithDuration:0.5f animations:^{
//            [self.view layoutIfNeeded];
//        }];
//
//    }else{
//        [ckTextView resignFirstResponder];
//        [board mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_bottom).offset(0);
//
//        }];
//        [board setNeedsUpdateConstraints]; //通知系统视图中的约束需要更新
//        [board updateConstraintsIfNeeded]; //
//        [UIView animateWithDuration:0.5f animations:^{
//            [self.view layoutIfNeeded];
//        } completion:^(BOOL finished) {
//                    board.hidden = YES;
//        }];
//    }

}

@end
