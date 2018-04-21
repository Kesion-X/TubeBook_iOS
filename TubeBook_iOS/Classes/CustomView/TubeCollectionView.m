//
//  TubeCollectionView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/18.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeCollectionView.h"
#import "CKMacros.h"

@interface TubeCollectionView ()

@property (nonatomic, strong) NSMutableArray *itemViews;

@end


@implementation TubeCollectionView
{
    NSUInteger width;
    NSUInteger height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        width = frame.size.width;
        height = frame.size.height;
        self.itemViews = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)addItemView:(UIView *)view
{
    [view setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:singleTap];
    view.tag = self.itemViews.count;
    [self.itemViews addObject:view];
    [self addSubview:view];
    [self updataLayout];
}



- (void)updataLayout
{
    NSUInteger pointX = kMegin;
    NSUInteger pointY = kMegin;
    CGFloat maxHeight = 0;
    for (UIView *view in self.itemViews) {
        // 如果当前加入的view后，总体宽度小于父view的宽度
        if ( ( pointX + kMegin + view.frame.size.width ) <= self.frame.size.width) {
            view.frame = CGRectMake(pointX, pointY, view.frame.size.width , view.frame.size.height);
            pointX += ( view.frame.size.width + kMegin );
            if (maxHeight < view.frame.size.height ) {
                maxHeight = view.frame.size.height;
            }
        } else {
            pointX = kMegin;
            pointY += ( maxHeight + kMegin );
            view.frame = CGRectMake(pointX, pointY, view.frame.size.width, view.frame.size.height);
            pointX += ( view.frame.size.width + kMegin );
            // 如果当前加入的view后，总体高度大与父view的高度
            if ( (pointY + view.frame.size.height + kMegin) > self.frame.size.height ) {
                self.contentSize = CGSizeMake(self.frame.size.width , (pointY + view.frame.size.height + kMegin));
                [self setContentOffset:CGPointMake(0, self.contentSize.height - self.frame.size.height)];
            }
            maxHeight = 0;
        }
    }
    [self layoutIfNeeded];
//    [UIView animateWithDuration:0.5f animations:^{
//        
//    }];
}


- (void)tapClick:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSUInteger tag = [singleTap view].tag;
    if (self.tubeCollectionDelegate) {
        if ([self.tubeCollectionDelegate respondsToSelector:@selector(collectionItemView:index:)]) {
            [self.tubeCollectionDelegate collectionItemView:[singleTap view] index:tag];
        }
    }
}


@end
