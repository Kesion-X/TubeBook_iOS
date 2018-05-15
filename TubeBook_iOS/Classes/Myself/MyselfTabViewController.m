//
//  MyselfTabViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "MyselfTabViewController.h"
#import "Masonry.h"
#import "CKMacros.h"
#import "TubeTableView.h"
#import "UITableImageWithLableCell.h"
#import "TubeSDK.h"
#import "ReactiveObjC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CreateTopicOrSerialViewController.h"
#import "DetialArticleListViewController.h"
#import "AuthorViewController.h"
#import "UserLikeArticleViewController.h"
#import "TopicViewController.h"
#import "SerialViewController.h"
#import "AltertControllerUtil.h"
#import "TubeAlterCenter.h"
#import "TubePhotoUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UploadImageUtil.h"
#import "MyThirdCollectionController.h"

@interface MyselfTabViewController () <TubeTableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel *navigationtitleLable;
@property (nonatomic, strong) UIScrollView *spaceBackScrollView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userTitleLable;
@property (nonatomic, strong) UILabel *userDescriptionLable;
@property (nonatomic, strong) UILabel *countArticleLable;
@property (nonatomic, strong) UILabel *countAttentLable;
@property (nonatomic, strong) UILabel *countAttentedLable;
@property (nonatomic, strong) TubeTableView *tableView;
@property (nonatomic, strong) UITableImageWithLableCell *likeArticleCell;
@property (nonatomic, strong) UITableImageWithLableCell *attenTopicCell;
@property (nonatomic, strong) UITableImageWithLableCell *createSerialCell;
@property (nonatomic, strong) UITableImageWithLableCell *attenSerialCell;
@property (nonatomic, strong) UITableImageWithLableCell *createTopicOrSerialCell;

@property (nonatomic,assign) NSInteger countArticle;
@property (nonatomic,assign) NSInteger countAttentUser;
@property (nonatomic,assign) NSInteger countAttentedUser;

@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, strong) NSString *avaterUrl;

@end

@implementation MyselfTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewAndConstraints];
}

- (void)addViewAndConstraints
{
    self.spaceBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.spaceBackScrollView];
    self.spaceBackScrollView.backgroundColor = HEXCOLOR(0xf9f9f9);
    self.spaceBackScrollView.scrollEnabled = YES;
    self.spaceBackScrollView.alwaysBounceVertical = YES;
    UIView *spaceUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    [self.spaceBackScrollView addSubview:spaceUser];
    [spaceUser addSubview:self.userImageView];
    [spaceUser addSubview:self.userTitleLable];
    [spaceUser addSubview:self.userDescriptionLable];
    spaceUser.backgroundColor = [UIColor whiteColor];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spaceUser).offset(24);
        make.left.equalTo(spaceUser).offset(16);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    [self.userDescriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.userImageView);
        make.left.equalTo(self.userImageView.mas_right).offset(8);
    }];
    [self.userTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(8);
        make.bottom.equalTo(self.userDescriptionLable.mas_top).offset(-8);
    }];

    UIView *spaceArticleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 80)];
    [spaceUser addSubview:spaceArticleView];
    [spaceArticleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(spaceUser);
        make.left.equalTo(spaceUser);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *articleVLable = [[UILabel alloc] init];
    articleVLable.text = @"文章";
    articleVLable.font = Font(12);
    articleVLable.textColor = HEXCOLOR(0xcdcdcd);
    [spaceArticleView addSubview:articleVLable];
    
    [articleVLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(spaceArticleView);
        make.bottom.equalTo(spaceArticleView).offset(-8);
    }];
    [spaceArticleView addSubview:self.countArticleLable];
    [self.countArticleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(spaceArticleView);
        make.bottom.equalTo(articleVLable.mas_top).offset(-8);
    }];
    
    
    UIView *spaceAttentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 80)];
    [spaceUser addSubview:spaceAttentView];
    [spaceAttentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(spaceUser);
        make.left.equalTo(spaceArticleView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *attentVLable = [[UILabel alloc] init];
    attentVLable.text = @"关注";
    attentVLable.font = Font(12);
    attentVLable.textColor = HEXCOLOR(0xcdcdcd);
    [spaceAttentView addSubview:attentVLable];
    
    [attentVLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(spaceAttentView);
        make.bottom.equalTo(spaceAttentView).offset(-8);
    }];
    [spaceAttentView addSubview:self.countAttentLable];
    [self.countAttentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(spaceAttentView);
        make.bottom.equalTo(attentVLable.mas_top).offset(-8);
    }];
    
    UIView *spaceAttentedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 80)];
    [spaceUser addSubview:spaceAttentedView];
    [spaceAttentedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(spaceUser);
        make.left.equalTo(spaceAttentView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *attentedVLable = [[UILabel alloc] init];
    attentedVLable.text = @"粉丝";
    attentedVLable.font = Font(12);
    attentedVLable.textColor = HEXCOLOR(0xcdcdcd);
    [spaceAttentedView addSubview:attentedVLable];
    
    [attentedVLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(spaceAttentedView);
        make.bottom.equalTo(spaceAttentedView).offset(-8);
    }];
    [spaceAttentedView addSubview:self.countAttentedLable];
    [self.countAttentedLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(spaceAttentedView);
        make.bottom.equalTo(attentedVLable.mas_top).offset(-8);
    }];
    
    UIView *spaceLineUser = [[UIView alloc] init];
    [spaceUser addSubview:spaceLineUser];
    [spaceLineUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(spaceUser).offset(-0.5);
        make.left.equalTo(spaceUser);
        make.right.equalTo(spaceUser);
        make.height.mas_equalTo(0.5);
    }];
    spaceLineUser.backgroundColor = HEXCOLOR(0xcdcdcd);
    // 喜欢的文章 关注的专题 关注的连载 我的连载
    self.tableView = [[TubeTableView alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 0)];
    [self.tableView addItemView:self.likeArticleCell];
    [self.tableView addItemView:self.attenTopicCell];
    [self.tableView addItemView:self.createSerialCell];
    [self.tableView addItemView:self.attenSerialCell];
    [self.tableView addItemView:self.createTopicOrSerialCell];
    UITableImageWithLableCell *thridArticleCell = [[UITableImageWithLableCell alloc] initUITableImageWithLableCellWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) title:@"我的外文收藏" iconName:@"icon_hezi"];
    [self.tableView addItemView:thridArticleCell];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    [self.spaceBackScrollView addSubview:self.tableView];
    
    [self setAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    if (self.navigationController.navigationBar.isHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    if (!self.navigationtitleLable) {
        self.navigationtitleLable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];
        self.navigationtitleLable.text = @"个人信息";
        [self.navigationController.navigationBar addSubview:self.navigationtitleLable];
        [self.navigationtitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navigationController.navigationBar);
            make.centerY.equalTo(self.navigationController.navigationBar);
        }];
    }
    self.navigationtitleLable.hidden = NO;
    [self requestData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationtitleLable.hidden = YES;
    NSLog(@"%s ",__func__);
}

#pragma mark - private

- (void)setAction
{
    UITapGestureRecognizer *tapCountArticleLableGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCountArticleLable)];
    [self.countArticleLable addGestureRecognizer:tapCountArticleLableGesturRecognizer];
    [self.countArticleLable setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapcountAttentLableGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCountAttentLable)];
    [self.countAttentLable addGestureRecognizer:tapcountAttentLableGesturRecognizer];
    [self.countAttentLable setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapCountAttentedLableGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCountAttentedLable)];
    [self.countAttentedLable addGestureRecognizer:tapCountAttentedLableGesturRecognizer];
    [self.countAttentedLable setUserInteractionEnabled:YES];

    UITapGestureRecognizer *tapAvaterImageViewGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserImageView)];
    [self.userImageView addGestureRecognizer:tapAvaterImageViewGesturRecognizer];
    [self.userImageView setUserInteractionEnabled:YES];
}

- (void)requestData
{
    [self requestUserinfo];
    [self requestArticleCount];
    [self requestUserAttentCount];
    [self requestUserAttentedCount];
}

#pragma mark - action
- (void)tapCountArticleLable
{
    UIViewController *c = [[DetialArticleListViewController alloc] initDetialArticleListViewControllerWithDetailType:TubeDetailTypeUser uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]];
    c.title = @"我的文章";
    [self.navigationController pushViewController:c animated:YES] ;
}

- (void)tapCountAttentLable
{
    UIViewController *c = [[AuthorViewController alloc] initAuthorViewControllerWithAutorType:AuthorTypeAttent];
    c.title = @"我关注的";
    [self.navigationController pushViewController:c animated:YES] ;
}

- (void)tapCountAttentedLable
{
    UIViewController *c = [[AuthorViewController alloc] initAuthorViewControllerWithAutorType:AuthorTypeAttented];
    c.title = @"我的粉丝";
    [self.navigationController pushViewController:c animated:YES] ;
}

- (void)tapUserImageView
{
    if ([TubePhotoUtil isCanUsePhotos]) {
        NSLog(@"%s primary yes", __func__);
        self.pickerController = [[UIImagePickerController alloc] init];
        self.pickerController.delegate = self;
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.pickerController animated:YES completion:nil];
        
    } else {
        [AltertControllerUtil showAlertTitle:@"警告" message:@"没有访问相册的权限！请到设置中设置权限！" confirmTitle:@"确定" confirmBlock:nil cancelTitle:nil cancelBlock:nil fromControler:self];
    }
}

#pragma mark - request

- (void)requestUserinfo
{
    @weakify(self);
    [[TubeSDK sharedInstance].tubeUserSDK fetchedUserInfoWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] isSelf:YES callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        @strongify(self);
        if ( status==DataCallBackStatusSuccess ) {
            NSDictionary *contentDic = page.content.contentData;
            NSDictionary *userinfo = [contentDic objectForKey:@"userinfo"];
            NSString *avatar = [userinfo objectForKey:@"avatar"];
            NSString *userName = [userinfo objectForKey:@"account"];
            NSString *nick = [userinfo objectForKey:@"nick"];
            if ( nick && nick.length>0 ) {
                userName = [userinfo objectForKey:@"nick"];
            }
            NSString *motto = [userinfo objectForKey:@"description"];
            if (!motto || motto.length==0) {
                motto = @"暂无简介";
            }
            self.userTitleLable.text = userName;
            self.userDescriptionLable.text = motto;
            if (!self.avaterUrl && ![self.avaterUrl isEqualToString:avatar]) {
                self.avaterUrl = avatar;
                [self.userImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"default_loadimage"]];
            }
        }
    }];
}

- (void)requestArticleCount
{
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedUserCreateArticleCountWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            NSInteger count = [[content objectForKey:@"count"] integerValue];
            self.countArticle = count;
        }
    }];
}

- (void)requestUserAttentCount
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedUserAttenteUserCountWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            NSInteger count = [[content objectForKey:@"count"] integerValue];
            self.countAttentUser = count;
        }
    }];
}

- (void)requestUserAttentedCount
{
    [[TubeSDK sharedInstance].tubeUserSDK fetchedUserAttentedCountWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            NSInteger count = [[content objectForKey:@"count"] integerValue];
            self.countAttentedUser = count;
        }
    }];
}

#pragma mark - delegate

- (void)tableItemView:(UIView *)itemView index:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            UIViewController *c = [[UserLikeArticleViewController alloc] initUserLikeArticleViewControllerWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]];
            c.title = @"我喜欢的文章";
            [self.navigationController pushViewController:c animated:YES] ;
            break;
        }
        case 1:
        {
            UIViewController *c = [[TopicViewController alloc] initTopicViewControllerWithFouseType:FouseTypeAttrent
                                                                                                uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]];
            c.title = @"我关注的专题";
            [self.navigationController pushViewController:c animated:YES] ;
            break;
        }
        case 2:
        {
            UIViewController *c = [[SerialViewController alloc] initSerialViewControllerWithFouseType:FouseTypeCreate
                                                                                                uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]];
            c.title = @"我的连载";
            [self.navigationController pushViewController:c animated:YES];
            break;
        }
        case 3:
        {
            UIViewController *c = [[SerialViewController alloc] initSerialViewControllerWithFouseType:FouseTypeAttrent
                                                                                                  uid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]];
            c.title = @"我关注的连载";
            [self.navigationController pushViewController:c animated:YES] ;
            break;
        }
        case 4:
        {
            UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[[CreateTopicOrSerialViewController alloc] init]];
            [self presentViewController:vc animated:YES completion:nil];
            break;
        }
        case 5:
        {
            UIViewController *c = [[MyThirdCollectionController alloc] initMyThirdCollectionControllerWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey]];
            c.title = @"我的收藏";
            [self.navigationController pushViewController:c animated:YES] ;
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.userImageView setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    });
    [UploadImageUtil uploadImage:[info objectForKey:UIImagePickerControllerOriginalImage] success:^(NSDictionary *dic) {


        NSString *fileName = [dic objectForKey:@"fileName"];
        NSString *message = [dic objectForKey:@"message"];
        if ([message containsString:@"success"]) {
            // [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传成功" duration:1.0f fromeVC:self];
            self.avaterUrl = [NSString stringWithFormat:@"http://127.0.0.1:8084/TubeBook_Web/upload/%@",fileName];
            [[TubeSDK sharedInstance].tubeUserSDK setUserAvaterWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] imageUrl:self.avaterUrl callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
                if (status == DataCallBackStatusSuccess) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"修改成功" duration:1.0f completion:nil];
                    });
                }
            }];
            
        } else {
            [[TubeAlterCenter sharedInstance] dismissAlterIndicatorViewController];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传失败，请查看网络！" duration:1.0f fromeVC:self];
            });
        }
    } fail:^(NSError *error) {
        // [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传失败" duration:1.0f fromeVC:self];
        NSLog(@"%@",error);
        [[TubeAlterCenter sharedInstance] dismissAlterIndicatorViewController];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传失败，请查看网络！" duration:1.0f fromeVC:self];
        });
    }];
}

#pragma mark - set
- (void)setCountArticle:(NSInteger)countArticle
{
    _countArticle = countArticle;
    self.countArticleLable.text = [NSString stringWithFormat:@"%lu",countArticle];
}

- (void)setCountAttentUser:(NSInteger)countAttentUser
{
    _countAttentUser = countAttentUser;
    self.countAttentLable.text = [NSString stringWithFormat:@"%lu",countAttentUser];
}

- (void)setCountAttentedUser:(NSInteger)countAttentedUser
{
    _countAttentedUser = countAttentedUser;
    self.countAttentedLable.text = [NSString stringWithFormat:@"%lu",countAttentedUser];
}

#pragma mark - get
- (UITableImageWithLableCell *)createTopicOrSerialCell
{
    if (!_createTopicOrSerialCell) {
        _createTopicOrSerialCell = [[UITableImageWithLableCell alloc] initUITableImageWithLableCellWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) title:@"创建连载/专题" iconName:@"icon_add_tab"];
    }
    return _createTopicOrSerialCell;
}

-(UITableImageWithLableCell *)attenSerialCell
{
    if (!_attenSerialCell) {
        _attenSerialCell = [[UITableImageWithLableCell alloc] initUITableImageWithLableCellWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) title:@"关注的连载" iconName:@"icon_star"];
    }
    return _attenSerialCell;
}

-(UITableImageWithLableCell *)createSerialCell
{
    if (!_createSerialCell) {
        _createSerialCell = [[UITableImageWithLableCell alloc] initUITableImageWithLableCellWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) title:@"我的连载" iconName:@"icon_book"];
    }
    return _createSerialCell;
}

-(UITableImageWithLableCell *)attenTopicCell
{
    if (!_attenTopicCell) {
        _attenTopicCell = [[UITableImageWithLableCell alloc] initUITableImageWithLableCellWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) title:@"关注的专题" iconName:@"icon_collecting"];
    }
    return _attenTopicCell;
}

- (UITableImageWithLableCell *)likeArticleCell
{
    if (!_likeArticleCell) {
        _likeArticleCell = [[UITableImageWithLableCell alloc] initUITableImageWithLableCellWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) title:@"喜欢的文章" iconName:@"icon_my_like_article"];
    }
    return _likeArticleCell;
}

- (UILabel *)countAttentedLable
{
    if (!_countAttentedLable) {
        _countAttentedLable = [[UILabel alloc] init];
        _countAttentedLable.textColor = kTEXTCOLOR;
        _countAttentedLable.text = @"3";
    }
    return _countAttentedLable;
}

- (UILabel *)countArticleLable
{
    if (!_countArticleLable) {
        _countArticleLable = [[UILabel alloc] init];
        _countArticleLable.textColor = kTEXTCOLOR;
        _countArticleLable.text = @"2";
    }
    return _countArticleLable;
}

- (UILabel *)countAttentLable
{
    if (!_countAttentLable) {
        _countAttentLable = [[UILabel alloc] init];
        _countAttentLable.textColor = kTEXTCOLOR;
        _countAttentLable.text = @"1";
    }
    return _countAttentLable;
}

- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.layer.cornerRadius = 30;
        _userImageView.layer.borderWidth = 0.5;
        _userImageView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _userImageView.layer.masksToBounds = YES;
    }
    return _userImageView;
}

- (UILabel *)userTitleLable
{
    if (!_userTitleLable) {
        _userTitleLable = [[UILabel alloc] init];
        _userTitleLable.textColor = kTEXTCOLOR;
        _userTitleLable.font = Font(14);
        _userTitleLable.text = @"title";
    }
    return _userTitleLable;
}

- (UILabel *)userDescriptionLable
{
    if (!_userDescriptionLable) {
        _userDescriptionLable = [[UILabel alloc] init];
        _userDescriptionLable.textColor = HEXCOLOR(0xcdcdcd);
        _userDescriptionLable.font = Font(12);
        _userDescriptionLable.text = @"userDescription";
    }
    return _userDescriptionLable;
}

@end
