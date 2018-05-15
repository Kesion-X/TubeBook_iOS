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
#import "Masonry.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import "DetailViewController.h"
#import "TubeRootViewController.h"
#import "TubeNavigationUITool.h"

@interface TopicViewController () <RefreshTableViewControllerDelegate>

@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation TopicViewController
{
    NSInteger index;
}

- (instancetype)initTopicViewControllerWithFouseType:(FouseType)fouseType uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self.uid = uid;
        self.fouseType = fouseType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UITopicTableCell class] forKeyContent:[TopicTagContent class]];
    [self requestData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s ",__func__);
    [self.titleLable removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    if (self.navigationController.viewControllers.count > 1){
        self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
        
        [self.navigationController.navigationBar addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navigationController.navigationBar);
            make.centerY.equalTo(self.navigationController.navigationBar);
        }];
    }
}

- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        NSLog(@"%s pop view controller",__func__);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"%s dismiss view controller",__func__);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - request

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleTopicTitleListWithIndex:index
                                                                                    uid:self.uid
                                                                            fouseType:self.fouseType
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
    NSLog(@"%s refreshData, index = %lu",__func__, index);
}

- (void)loadMoreData
{
    [self requestData];
    NSLog(@"%s loadMoreData, index = %lu",__func__, index);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKContent *content = self.contentData[indexPath.row];
    NSLog(@"%s select item %@",__func__, content);
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        TubeRootViewController *vc = [[TubeRootViewController alloc] initWithRootViewController:[[DetailViewController alloc] initTopicDetailViewControllerWithTabid:content.id uid:content.userUid]];
        [self presentViewController:vc animated:YES completion:nil];
    });

}

#pragma mark - get
- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        _titleLable.text = self.title;
    }
    return _titleLable;
}


@end
