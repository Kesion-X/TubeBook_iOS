//
//  TubeRefreshTableViewController.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/23.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRefreshTableView.h"
#import "Masonry.h"
#import "CKContent.h"
#import "CKTableCell.h"
#import "CKMacros.h"

typedef void(^tapForIndexBlock)(NSIndexPath *indexPath);
typedef void(^tapBlock)(NSIndexPath *indexPath, NSDictionary *dic);

@protocol RefreshTableViewControllerDelegate

@optional
- (void)refreshData;
- (void)loadMoreData;

@end

@interface TubeRefreshTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIRefreshTableView *refreshTableView;
@property (nonatomic, strong) NSMutableArray *contentData;
@property (nonatomic, strong) NSMutableDictionary *classMap;
@property (nonatomic, strong) NSMutableDictionary *keyForIndexBlockDictionary;
@property (nonatomic, strong) id<RefreshTableViewControllerDelegate> refreshTableViewControllerDelegate;

- (void)registerCell:(Class)cellClass forKeyContent:(Class)contentClass;
- (void)refreshLayout;
- (void)registerActionKey:(NSString *)actionKey forKeyBlock:(tapForIndexBlock)indexBlock;
- (void)registertapBlockKey:(NSString *)actionKey forKeyBlock:(tapBlock)block;

@end
