//
//  SerialViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "SerialViewController.h"
#import "SerialTagContent.h"
#import "UISerialTableCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "DetailViewController.h"
#import "TubeRootViewController.h"

@interface SerialViewController () <RefreshTableViewControllerDelegate>

@end

@implementation SerialViewController
{
    NSInteger index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UISerialTableCell class] forKeyContent:[SerialTagContent class]];
//    for (int i=0; i<10; ++i) {
//        [self.contentData addObject:[[SerialTagContent alloc] init]];
//    }
    [self requestData];
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleSerialTitleListWithIndex:index
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
                                                                                      ckContent = [[SerialTagContent alloc] init];
                                                                                      ckContent.serialTitle = title;
                                                                                      ckContent.serialImageUrl = pic;
                                                                                      ckContent.serialDescription = description;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *content = self.contentData[indexPath.row];
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        TubeRootViewController *vc = [[TubeRootViewController alloc] initWithRootViewController:[[DetailViewController alloc] initSerialDetailViewControllerWithTabid:content.id uid:content.userUid]];
        [self.tabBarController presentViewController:vc animated:YES completion:nil];
    });
    
}

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

@end
