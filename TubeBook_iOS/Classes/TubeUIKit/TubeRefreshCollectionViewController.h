//
//  TubeRefreshCollectionViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/26.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIWaterfallCollectionViewLayout.h"
#import "CKContent.h"
#import "CKCollectionViewCell.h"
#import "UIRefreshTableView.h"
#import "TubeRefreshTableViewController.h"

@interface TubeRefreshCollectionViewController : UIViewController

@property(nonatomic, strong) NSMutableArray *contentData;
@property(nonatomic, strong) NSMutableDictionary *classMap;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIWaterfallCollectionViewLayout *layout;

@property(nonatomic, strong) UIRefreshHeadView *refreshHeadView;
@property(nonatomic, strong) UIActivityIndicatorView *loadMoreIndicatorView;
@property(nonatomic, strong) id<RefreshTableViewControllerDelegate> refreshTableViewControllerDelegate;

- (void)registerCell:(Class _Nonnull )cellClass forKeyContent:(Class _Nullable )contentClass;
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *_Nullable)identifier;

@end
