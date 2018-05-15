//
//  CycleTableCell.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CycleTableCell.h"
#import "Masonry.h"
#include "CKMacros.h"
#import "CycleContent.h"

@implementation CycleTableCell 

- (instancetype)initWithDateType:(CKDataType *)type
{
    self = [super initWithDateType:type];
    if (self) {
        [self addViewAndConstraint];
    }
    return self;
}

- (void)addViewAndConstraint
{
    [self.contentView addSubview:self.cycleScrollView];
    UIView *spaceportBottom = [[UIView alloc] init];
    [self.contentView addSubview:spaceportBottom];
    [spaceportBottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(5);
    }];
    [spaceportBottom setBackgroundColor:kTAB_TEXT_COLOR];
}

- (CGFloat)getCellHeight
{
    return 205;
}

+ (CGFloat)getCellHeight:(CKContent *)content
{
    return 205;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(CKContent *)content
{
    if ([content isKindOfClass:[CycleContent class]]) {
        CycleContent *c = (CycleContent *)content;
        [self loadData:c.titles imageUrls:c.imageUrls];
    }
}

- (void)loadData:(NSArray *)titles imageUrls:(NSArray *)imagesURLs
{
    self.cycleScrollView.titlesGroup = titles;
    self.cycleScrollView.imageURLStringsGroup = imagesURLs;
}

#pragma mark - get
- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) delegate:self placeholderImage:[UIImage imageNamed:@"loading.gif"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.autoScrollTimeInterval = 4;
        
        NSArray *imagesURLStrings = @[
                                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1516881495431&di=29a995a985ac3dccbbd822740a40e0ef&imgtype=0&src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farchive%2F3ae579b4cf122c667468d18c2d55a8c87adc261f.jpg",
                                      @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2206131340,312839085&fm=27&gp=0.jpg",
                                      @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2508875551,1607812083&fm=27&gp=0.jpg",
                                      @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=759595030,338383295&fm=27&gp=0.jpg"
                                      ];
        
        // 情景三：图片配文字
        NSArray *titles = @[@"hhh",
                            @"呵呵呵",
                            @"哈哈哈",
                            @"啦啦啦"
                            ];
        _cycleScrollView.titlesGroup = titles;
        _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        _cycleScrollView.delegate = self;
    }
    return _cycleScrollView;
}

#pragma mark - delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    TubeRefreshTableViewController *controller = self.viewController;
    if ([controller.keyForIndexBlockDictionary objectForKey:kCycleTableCellCycleImageTap]) {
        tapBlock block = [controller.keyForIndexBlockDictionary objectForKey:kCycleTableCellCycleImageTap];
        NSDictionary *dic = @{@"index":@(index)};
        block([controller.refreshTableView indexPathForCell:self], dic);
    }
}

@end
