//
//  TubeSearchTableViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/9.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "TubeSearchTableViewController.h"
#import "TopicTagContent.h"
#import "UITopicTableCell.h"
#import "UISerialTableCell.h"
#import "SerialTagContent.h"
#import "TubeSDK.h"

@interface TubeSearchTableViewController ()  <RefreshTableViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *searchBt;
@property (nonatomic, strong) callBackSelectedContentBlock contentCallBackBlock;
@property (nonatomic, assign) NSInteger indexPage;

@end

@implementation TubeSearchTableViewController
{
    UIView *spaceV;
    NSInteger refeshCount;
    NSInteger loadCount;
}

- (instancetype)initTubeSearchTableViewControllerWithType:(TubeSearchType)searchType fouseType:(FouseType)fouse contentCallBack:(callBackSelectedContentBlock)contentCallBackBlock
{
    self = [self initTubeSearchTableViewControllerWithType:searchType contentCallBack:contentCallBackBlock];
    if (self) {
        self.fouseType = fouse;
    }
    return self;
}

- (instancetype)initTubeSearchTableViewControllerWithType:(TubeSearchType)searchType contentCallBack:(callBackSelectedContentBlock)contentCallBackBlock
{
    self = [super init];
    if (self) {
        self.searchType = searchType;
        self.contentCallBackBlock = contentCallBackBlock;
        self.fouseType = FouseTypeAll;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshLayout];
    self.refreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshTableViewControllerDelegate = self;
    [self registerCell:[UITopicTableCell class] forKeyContent:[TopicTagContent class]];
    [self registerCell:[UISerialTableCell class] forKeyContent:[SerialTagContent class]];
    [self refreshTableData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    [self configNavigation];
}

- (void)configNavigation
{
    spaceV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 30)];
    [spaceV addSubview:self.searchField];
    self.searchField.delegate = self;
    spaceV.layer.cornerRadius = 15.0f;
    spaceV.layer.borderWidth = 0.5f;
    spaceV.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
    spaceV.layer.masksToBounds = YES;
    self.navigationItem.titleView = spaceV;
}

#pragma mark - private

- (void)refreshTableData
{
    __weak typeof(self) weakSelf = self;
    
    if ( self.searchType == TubeSearchTypeTopicTitle || self.searchType == TubeSearchTypeSerialTitle ) {
        ArticleType type = ArticleTypeTopic;
        FouseType fouseType = FouseTypeAttrent;
        if ( self.searchType == TubeSearchTypeSerialTitle ) {
            type = ArticleTypeSerial;
            fouseType = FouseTypeCreate;
        }
        NSString *uid = [[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey];
        if (type == ArticleTypeTopic) {
            uid = nil;
        }
        [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleTopicOrSerialTitleListWithType:type
                                                                                        index:self.indexPage
                                                                                          uid:uid
                                                                                    fouseType:self.fouseType
                                                                                conditionDic:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                                                                self.searchField.text,@"title", nil]
                                                                                    callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
                                                                                          
                                                                                          if ( weakSelf.indexPage==0 && weakSelf.contentData.count>0) {
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
                                                                                                  if ( self.searchType == TubeSearchTypeTopicTitle ) {
                                                                                                      ckContent = [[TopicTagContent alloc] init];
                                                                                                      ckContent.topicTitle = title;
                                                                                                      ckContent.topicImageUrl = pic;
                                                                                                      ckContent.topicDescription = description;
                                                                                                      ckContent.userUid = create_uid;
                                                                                                      ckContent.time = time;
                                                                                                      ckContent.id = id;
                                                                                                      [weakSelf.contentData addObject:ckContent];
                                                                                                  } else if ( self.searchType == TubeSearchTypeSerialTitle ) {
                                                                                                      ckContent = [[SerialTagContent alloc] init];
                                                                                                      ckContent.serialTitle = title;
                                                                                                      ckContent.serialImageUrl = pic;
                                                                                                      ckContent.serialDescription = description;
                                                                                                      ckContent.userUid = create_uid;
                                                                                                      ckContent.time = time;
                                                                                                      ckContent.id = id;
                                                                                                      [weakSelf.contentData addObject:ckContent];
                                                                                                  }
                                                                                                  
                                                                                              }
                                                                                              self.indexPage ++;
                                                                                              [weakSelf.refreshTableView reloadData];
                                                                                          }
                                                                                      }];
    }
 
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.contentCallBackBlock) {
        NSLog(@"%s select item %@",__func__, self.contentData[indexPath.row]);
        self.contentCallBackBlock(self.contentData[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

# pragma mark - RefreshTableViewControllerDelegate

- (void)refreshData
{
    NSLog(@"%s refreshData",__func__);
//    refeshCount ++;
//    if ( refeshCount<=1 ) {
//        return ;
//    }
    self.indexPage = 0;
    [self refreshTableData];

}

- (void)loadMoreData
{
    NSLog(@"%s loadMoreData",__func__);
//    loadCount ++;
//    if ( loadCount<=2 ) {
//        return ;
//    }
    if (self.contentData.count==0) {
        return ;
    }

    [self refreshTableData];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{

    NSLog(@"search field %@",textField.text);
}

#pragma mark - get

- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 110, 30)];
        _searchField.placeholder = @"搜索";
    }
    return _searchField;
}


@end
