//
//  ReleaseSetViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/25.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "ReleaseSetViewController.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "UITagView.h"
#import "TagCollectionView.h"
#import "TubeSDK.h"
#import "LCActionSheet.h"
#import "TubeSearchTableViewController.h"
#import "TubePhotoUtil.h"
#import "AltertControllerUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TubeAlterCenter.h"
#import "UploadImageUtil.h"
#import "UITubeButton.h"

@interface ReleaseSetViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *titleContentLable;
@property (nonatomic, strong) UILabel *articleDescriptionLable;
@property (nonatomic, strong) UITextView *articleDescriptionTextView;
@property (nonatomic, strong) UILabel *articleTypeLable;
@property (nonatomic, strong) UILabel *articleTypeChioseLable;
@property (nonatomic, strong) UIButton *articleTypeChioseButton;
@property (nonatomic, strong) UIButton *articleTypeTitleChioseButton;
@property (nonatomic, strong) UILabel *articleTabLable;
@property (nonatomic, strong) TagCollectionView *tagCollectionView;
@property (nonatomic, strong) UITextField *articleTagFiled;
@property (nonatomic, strong) UIButton *articleTagButton;
@property (nonatomic, strong) UILabel *articlePicLable;
@property (nonatomic, strong) UIButton *addArticlePicButton;
@property (nonatomic, strong) UITubeButton *releaseButton;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *atid;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleBody;
@property (nonatomic, assign) ArticleType type;
@property (nonatomic, strong) NSString *articlePic;
@property (nonatomic, strong) CKContent *chioseContent;


@property (nonatomic, strong) UIImagePickerController *pickerController;

@end

@implementation ReleaseSetViewController

- (instancetype)initReleaseSetViewControllerWith:(NSString *)articleTitle articleBody:(NSString *)articleBody
{
    self = [super init];
    if (self) {
        self.articleTitle = articleTitle;
        self.articleBody = articleBody;
        self.title = @"文章发布";
        self.type = ArticleTypeMornal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewAndConstraint];
    [self addAction];
    [self loadData];
}

- (void)addAction
{
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelfViewAction:)];
    [self.view addGestureRecognizer:tapGesturRecognizer];
}

- (void)addViewAndConstraint
{
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.titleContentLable];
    [self.contentView addSubview:self.articleDescriptionLable];
    [self.contentView addSubview:self.articleDescriptionTextView];
    [self.contentView addSubview:self.articleTypeLable];
    [self.contentView addSubview:self.articleTypeChioseLable];
    [self.contentView addSubview:self.articleTypeChioseButton];
    [self.contentView addSubview:self.articleTypeTitleChioseButton];
    [self.contentView addSubview:self.articleTabLable];
    [self.contentView addSubview:self.tagCollectionView];
    [self.contentView addSubview:self.articleTagButton];
    [self.contentView addSubview:self.articleTagFiled];
    [self.contentView addSubview:self.articlePicLable];
    [self.contentView addSubview:self.addArticlePicButton];
    [self.contentView addSubview:self.releaseButton];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
    [self.titleContentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.titleLable.mas_right).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(30);
    }];
    [self.articleDescriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(30);
    }];
    [self.articleDescriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleDescriptionLable.mas_bottom);
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.mas_equalTo(100);
    }];
    [self.articleTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleDescriptionTextView.mas_bottom);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(30);
    }];
    [self.articleTypeChioseLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleTypeLable.mas_bottom);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(110);
    }];
    [self.articleTypeChioseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleTypeLable.mas_bottom);
        make.left.equalTo(self.articleTypeChioseLable.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    [self.articleTypeTitleChioseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleTypeLable.mas_bottom);
        make.left.equalTo(self.articleTypeChioseButton.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    [self.articleTabLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleTypeChioseLable.mas_bottom);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(30);
    }];
    [self.tagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleTabLable.mas_bottom);
        make.left.equalTo(self.contentView.mas_right).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.mas_equalTo(50);
    }];
    [self.articleTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagCollectionView.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [self.articleTagFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagCollectionView.mas_bottom).offset(5);
        make.right.equalTo(self.articleTagButton.mas_left).offset(-8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    UIView *boardV = [[UIView alloc] init];
    boardV.backgroundColor = kTAB_TEXT_COLOR;
    [self.contentView addSubview:boardV];
    [boardV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articleTagButton.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.mas_equalTo(0.5f);
    }];
    [self.articlePicLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boardV.mas_bottom).offset(4);
        make.left.equalTo(self.view).offset(8);
        make.height.mas_equalTo(30);
    }];
    [self.addArticlePicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.articlePicLable.mas_bottom).offset(4);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    [self.releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.left.equalTo(self.contentView).offset(100);
        make.right.equalTo(self.view).offset(-100);
        make.height.mas_equalTo(40);
    }];

    [self.titleContentLable setText:self.articleTitle];
    self.articleTypeTitleChioseButton.hidden = YES;
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[TubeSDK sharedInstance].tubeArticleSDK fetchedArticleTagListWithCount:10 callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status == DataCallBackStatusSuccess) {
            NSDictionary *content = page.content.contentData;
            NSArray *list = [content objectForKey:@"tagList"];
            for (NSDictionary *dic in list) {
                UITagView *tagV = [[UITagView alloc] initUITagView:[dic objectForKey:@"tag"] color:[UIColor grayColor]];
                tagV.tagId = [[dic objectForKey:@"id"] integerValue];
                [weakSelf.tagCollectionView addTagsObject:tagV];
            }
        } else {
            
        }
    }];
}

#pragma action

- (IBAction)addTag:(id)sender
{
    if (self.articleTagFiled.text && self.articleTagFiled.text.length > 0) {
        [[TubeSDK sharedInstance].tubeArticleSDK addArticleTag:self.articleTagFiled.text callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
            if (status == DataCallBackStatusSuccess) {
                [self.tagCollectionView addTagsObject:[[UITagView alloc] initUITagView:self.articleTagFiled.text color:[UIColor grayColor]]];
            }
        }];
    }
}

- (void)tapSelfViewAction:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.articleDescriptionTextView resignFirstResponder];
        [self.articleTagFiled resignFirstResponder];
    }
}

- (IBAction)chioseType:(id)sender
{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"选择文章类型" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            buttonIndex = 1;
        }
        if (buttonIndex == 1) {
            self.articleTypeTitleChioseButton.hidden = YES;
        } else {
            self.articleTypeTitleChioseButton.hidden = NO;
        }
        switch (buttonIndex) {
            case 1:
            {
                self.type = ArticleTypeMornal;
                [self.articleTypeChioseButton setTitle:@"普通文章" forState:UIControlStateNormal];
                [self.articleTypeChioseButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
                break;
            }
            case 2:
            {
                self.type = ArticleTypeTopic;
                [self.articleTypeChioseButton setTitle:@"专题文章" forState:UIControlStateNormal];
                [self.articleTypeChioseButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
                break;
            }
            case 3:
            {
                self.type = ArticleTypeSerial;
                [self.articleTypeChioseButton setTitle:@"连载文章" forState:UIControlStateNormal];
                [self.articleTypeChioseButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
        NSLog(@"type %lu",buttonIndex);
    } otherButtonTitleArray:@[@"普通文章", @"专题文章", @"连载文章"] ];
    [sheet show];
}

- (IBAction)chioseTypeTitle:(id)sender
{
    TubeSearchTableViewController *vc = [[TubeSearchTableViewController alloc] initTubeSearchTableViewControllerWithType:TubeSearchTypeTopicTitle contentCallBack:^(CKContent *content) {
        self.chioseContent = content;
        [self.articleTypeTitleChioseButton setTitle:content.topicTitle forState:UIControlStateNormal];
        [self.articleTypeTitleChioseButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
    }];
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addArticlePic:(id)sender
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

- (IBAction)releaseArticle:(id)sender
{
    NSInteger time = [TimeUtil getNowTimeTimest];
    self.uid = [[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey];
    self.uid = @"12345678";
    self.atid = [self.uid stringByAppendingString:[TimeUtil getNowTimeTimestamp3]];
    [[TubeSDK sharedInstance].tubeArticleSDK uploadArticleWithTitle:self.articleTitle
                                                               atid:self.atid
                                                                uid:self.uid
                                                             detail:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                                     self.articleBody, @"body",
                                                                     self.articleDescriptionTextView.text, @"description",
                                                                     self.articlePic, @"articlepic",
                                                                     @(time), @"cratetime",nil]
                                                           callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
                                                               if ( status == DataCallBackStatusSuccess) {
                                                                   [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"发布成功" duration:2.0f fromeVC:self];
                                                                   [self requestSetTag:self.atid];
                                                                   [self requestSetTab:self.atid];
                                                               }
    }];
}


- (void)requestSetTag:(NSString *)atid
{
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    for (UITagView *v in [self.tagCollectionView getSelectesArrayTagView]) {
        [tags addObject:@(v.tagId)];
    }
    [[TubeSDK sharedInstance].tubeArticleSDK setArticleTagWithAtid:atid tags:tags callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if (status != DataCallBackStatusSuccess) {
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"标签设置失败" duration:1.0f fromeVC:self];
        }
    }];
}

- (void)requestSetTab:(NSString *)atid
{
    [[TubeSDK sharedInstance].tubeArticleSDK setArticleTabWithAtid:atid articleType:self.type tabid:self.chioseContent.id callBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
    //[[TubeAlterCenter sharedInstance] showAlterIndicatorWithMessage:@"正在上传图片" fromeVC:self];
    [_addArticlePicButton setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    [UploadImageUtil uploadImage:[info objectForKey:UIImagePickerControllerOriginalImage] success:^(NSDictionary *dic) {
        [[TubeAlterCenter sharedInstance] dismissAlterIndicatorViewController];
        NSLog(@"%@",dic);
        NSString *fileName = [dic objectForKey:@"fileName"];
        NSString *message = [dic objectForKey:@"message"];
        if ([message containsString:@"success"]) {
           // [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传成功" duration:1.0f fromeVC:self];
            self.articlePic = [NSString stringWithFormat:@"http://127.0.0.1:8084/TubeBook_Web/upload/%@",fileName];
        }
    } fail:^(NSError *error) {
       // [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传失败" duration:1.0f fromeVC:self];
        NSLog(@"%@",error);
    }];
}

#pragma mark - get

- (UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        //_contentView.backgroundColor = [UIColor grayColor];
    }
    return _contentView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = CKTextViewFont;
        _titleLable.text = @"标题:";
        _titleLable.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    }
    return _titleLable;
}

- (UILabel *)titleContentLable
{
    if (!_titleContentLable) {
        _titleContentLable = [[UILabel alloc] init];
    }
    return _titleContentLable;
}

- (UILabel *)articleDescriptionLable
{
    if (!_articleDescriptionLable) {
        _articleDescriptionLable = [[UILabel alloc] init];
        _articleDescriptionLable.font = CKTextViewFont;
        _articleDescriptionLable.text = @"文章描述";
        _articleDescriptionLable.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    }
    return _articleDescriptionLable;
}

- (UITextView *)articleDescriptionTextView
{
    if (!_articleDescriptionTextView) {
        _articleDescriptionTextView = [[UITextView alloc] init];
        _articleDescriptionTextView.layer.borderWidth = 0.5f;
        _articleDescriptionTextView.layer.cornerRadius = 4.0f;
        _articleDescriptionTextView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _articleDescriptionTextView.layer.masksToBounds = YES;
    }
    return _articleDescriptionTextView;
}

- (UILabel *)articleTypeLable
{
    if (!_articleTypeLable) {
        _articleTypeLable = [[UILabel alloc] init];
        _articleTypeLable.font = CKTextViewFont;
        _articleTypeLable.text = @"文章类型";
        _articleTypeLable.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    }
    return _articleTypeLable;
}

- (UILabel *)articleTypeChioseLable
{
    if (!_articleTypeChioseLable) {
        _articleTypeChioseLable = [[UILabel alloc] init];
        _articleTypeChioseLable.font = CKTextViewFont;
        _articleTypeChioseLable.text = @"选择文章类型:";
        _articleTypeChioseLable.textColor = kTEXTCOLOR;
    }
    return _articleTypeChioseLable;
}

- (UIButton *)articleTypeChioseButton
{
    if (!_articleTypeChioseButton) {
        _articleTypeChioseButton = [[UIButton alloc] init];
        [_articleTypeChioseButton setTitle:@"普通文章" forState:UIControlStateNormal];
        [_articleTypeChioseButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
        _articleTypeChioseButton.titleLabel.font = CKTextViewFont;
        [_articleTypeChioseButton addTarget:self action:@selector(chioseType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _articleTypeChioseButton;
}

- (UIButton *)articleTypeTitleChioseButton
{
    if (!_articleTypeTitleChioseButton) {
        _articleTypeTitleChioseButton = [[UIButton alloc] init];
        [_articleTypeTitleChioseButton setTitle:@"选择标题" forState:UIControlStateNormal];
        [_articleTypeTitleChioseButton setTitleColor:kTEXTCOLOR forState:UIControlStateNormal];
        _articleTypeTitleChioseButton.titleLabel.font = CKTextViewFont;
        [_articleTypeTitleChioseButton addTarget:self action:@selector(chioseTypeTitle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _articleTypeTitleChioseButton;
}

- (UILabel *)articleTabLable
{
    if (!_articleTabLable) {
        _articleTabLable = [[UILabel alloc] init];
        _articleTabLable.font = CKTextViewFont;
        _articleTabLable.text = @"文章标签";
        _articleTabLable.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    }
    return _articleTabLable;
}

- (TagCollectionView *)tagCollectionView
{
    if (!_tagCollectionView) {
        _tagCollectionView = [[TagCollectionView alloc] init];
        _tagCollectionView.layer.borderWidth = 0.5f;
        _tagCollectionView.layer.cornerRadius = 4.0f;
        _tagCollectionView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _tagCollectionView.layer.masksToBounds = YES;
    }
    return _tagCollectionView;
}

- (UITextField *)articleTagFiled
{
    if (!_articleTagFiled) {
        _articleTagFiled = [[UITextField alloc] init];
        _articleTagFiled.layer.borderWidth = 0.5f;
        _articleTagFiled.layer.cornerRadius = 4.0f;
        _articleTagFiled.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _articleTagFiled.layer.masksToBounds = YES;
    }
    return _articleTagFiled;
}

- (UIButton *)articleTagButton
{
    if (!_articleTagButton) {
        _articleTagButton = [[UIButton alloc] init];
        [_articleTagButton setTitle:@"添加标签" forState:UIControlStateNormal];
        [_articleTagButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
        [_articleTagButton setTitleColor:kTAB_TEXT_COLOR forState:UIControlStateHighlighted];
        _articleTagButton.titleLabel.font = CKTextViewFont;
        [_articleTagButton addTarget:self action:@selector(addTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _articleTagButton;
}

- (UILabel *)articlePicLable
{
    if (!_articlePicLable) {
        _articlePicLable = [[UILabel alloc] init];
        _articlePicLable.font = CKTextViewFont;
        _articlePicLable.text = @"文章封面";
        _articlePicLable.textColor = kTUBEBOOK_THEME_NORMAL_COLOR;
    }
    return _articlePicLable;
}

- (UIButton *)addArticlePicButton
{
    if (!_addArticlePicButton) {
        _addArticlePicButton = [[UIButton alloc] init];
        [_addArticlePicButton setBackgroundImage:[UIImage imageNamed:@"icon_add_pic"] forState:UIControlStateNormal];
        [_addArticlePicButton addTarget:self action:@selector(addArticlePic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addArticlePicButton;
}

- (UITubeButton *)releaseButton
{
    if (!_releaseButton) {
        _releaseButton = [[UITubeButton alloc] initUITubeButton:@"发布" normalColor:kTUBEBOOK_THEME_NORMAL_COLOR lightColor:kTUBEBOOK_THEME_ALPHA_COLOR];
        [_releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_releaseButton addTarget:self action:@selector(releaseArticle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _releaseButton;
}

@end
