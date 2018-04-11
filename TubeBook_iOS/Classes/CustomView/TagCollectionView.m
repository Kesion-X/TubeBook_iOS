//
//  TagCollectionView.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/12.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TagCollectionView.h"
#import "CKMacros.h"
#define kMegin 5

@interface TagCollectionView ()

// item UITagView
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *selectTags;

@end

@implementation TagCollectionView
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
        self.tags = [[NSMutableArray alloc] init];
        self.selectTags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addTagsObject:(UITagView *)tag
{
    tag.tagButton.tag = self.tags.count;
    [self.tags addObject:tag];
    [self addSubview:tag];
    [tag.tagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    [self updataLayout];
}

- (void)updataLayout
{
    NSUInteger pointX = kMegin;
    NSUInteger pointY = kMegin;
    for (UITagView *tagV in self.tags) {
        if ((pointX+kMegin+[tagV getUIWidht]) <= self.frame.size.width) {
            tagV.frame = CGRectMake(pointX, pointY, [tagV getUIWidht], [tagV getUIHeight]);
            pointX += ([tagV getUIWidht] + kMegin);
        } else {
            pointX = kMegin;
            pointY += ([tagV getUIHeight] + kMegin);
            tagV.frame = CGRectMake(pointX, pointY, [tagV getUIWidht], [tagV getUIHeight]);
            pointX += ([tagV getUIWidht] + kMegin);
            if ((pointY + [tagV getUIHeight] + kMegin) > self.frame.size.height) {
                self.contentSize = CGSizeMake(self.frame.size.width , (pointY + [tagV getUIHeight] + kMegin));
                [self setContentOffset:CGPointMake(0, self.contentSize.height - self.frame.size.height)];
            }
        }
    }
    [UIView animateWithDuration:0.5f animations:^{
        [self layoutIfNeeded];
    }];
}

- (IBAction)tagClick:(UIButton *)sender
{
    NSUInteger tag = sender.tag;
    UITagView *tagV = [self.tags objectAtIndex:tag];
    if ([self.selectTags containsObject:tagV]) {
        [self.selectTags removeObject:tagV];
        [tagV setTagColor:[UIColor grayColor]];
    } else {
        [self.selectTags addObject:tagV];
        [tagV setTagColor:kTUBEBOOK_THEME_NORMAL_COLOR];
    }
    //tagV setTagColor:<#(UIColor *)#>
}

- (NSArray *)getSelectesArray
{
    NSMutableArray *strArray = [[NSMutableArray alloc] init];
    for (UITagView *v in self.selectTags) {
        [strArray addObject:v.tagText];
    }
   // NSArray *array = [[NSArray init] initWithArray:strArray];
    return strArray;
}

- (NSArray *)getSelectesArrayTagView
{
    NSMutableArray *strArray = [[NSMutableArray alloc] init];
    for (UITagView *v in self.selectTags) {
        [strArray addObject:v];
    }
    //NSArray *array = [[NSArray init] initWithArray:strArray];
    return strArray;
}

@end
