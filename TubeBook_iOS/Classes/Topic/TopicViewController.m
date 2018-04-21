//
//  TopicViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicTagContent.h"
#import "UITopicTableCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "DetailViewController.h"
#import "TubeRootViewController.h"

@interface TopicViewController () <RefreshTableViewControllerDelegate>

@end

@implementation TopicViewController
{
    NSInteger index;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UITopicTableCell class] forKeyContent:[TopicTagContent class]];
//    for (int i=0; i<5; ++i) {
//        [self.contentData addObject:[[TopicTagContent alloc] init]];
//    }
    [self requestData];
}

- (void)loadData
{
    
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleTopicTitleListWithIndex:index
                                                                                    uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]
                                                                            fouseType:FouseTypeAttrent
                                                                            conditionDic:nil
                                                                                callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
                                                                                     
                                                                                     if ( index==0 && weakSelf.contentData.count>0) {
                                                                                         [weakSelf.contentData removeAllObjects];
                                                                                         [weakSelf.refreshTableView reloadData];
                                                                                     }
                                                                                     
                                                                                     if ( status==DataCallBackStatusSuccess ) {
                                                                                         NSDictionary *content = page.content.contentData;
                                                                                         NSArray *array = [content objectForKey:@"tabTapList"];
                                                                                         if (array.count == 0) {
                                                                                             return ;
                                                                                         }
                                                                                         for (NSDictionary *dic in array) {
                                                                                             NSString *time = [dic objectForKey:@"create_time"];
                                                                                             NSString *create_uid = [dic objectForKey:@"create_userid"];
                                                                                             NSString *description = [dic objectForKey:@"description"];
                                                                                             NSString *pic = [dic objectForKey:@"pic"];
                                                                                             NSString *title = [dic objectForKey:@"title"];
                                                                                             NSInteger id = [[dic objectForKey:@"id"] integerValue];
                                                                                             CKContent *ckContent = nil;
                                                                                             ckContent = [[TopicTagContent alloc] init];
                                                                                             ckContent.topicTitle = title;
                                                                                             ckContent.topicImageUrl = pic;
                                                                                             ckContent.topicDescription = description;
                                                                                             ckContent.userUid = create_uid;
                                                                                             ckContent.time = time;
                                                                                             ckContent.id = id;
                                                                                             [weakSelf.contentData addObject:ckContent];
                                                                                     }
                                                                                     index ++;
                                                                                     [weakSelf.refreshTableView reloadData];
                                                                                }
                                                                            }];
}

#pragma mark - delegate

- (void)refreshData
{
    index = 0;
    [self requestData];
    NSLog(@"refreshData");
}

- (void)loadMoreData
{
    [self requestData];
    NSLog(@"loadMoreData");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *content = self.contentData[indexPath.row];
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        TubeRootViewController *vc = [[TubeRootViewController alloc] initWithRootViewController:[[DetailViewController alloc] initTopicDetailViewControllerWithTabid:content.id uid:content.userUid]];
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    });

}

@end
