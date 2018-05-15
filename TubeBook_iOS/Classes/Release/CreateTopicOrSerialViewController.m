//
//  CreateTopicOrSerialViewController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/4/20.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "CreateTopicOrSerialViewController.h"
#import "TubeNavigationUITool.h"
#import "CKMacros.h"
#import "Masonry.h"
#import "LCActionSheet.h"
#import "UITubeButton.h"
#import "TubeAlterCenter.h"
#import "TubePhotoUtil.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AltertControllerUtil.h"
#import "UploadImageUtil.h"
#import "TubeSDK.h"

@interface CreateTopicOrSerialViewController () < UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) ArticleType type;
@property (nonatomic, strong) UIButton *chioseTabButton;
@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UIButton *addPicButton;
@property (nonatomic, strong) UITubeButton *createButton;
@property (nonatomic, strong) UIImagePickerController *pickerController;

@property (nonatomic, strong) NSString *tabPic;

@end

@implementation CreateTopicOrSerialViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = ArticleTypeMornal;
    }
    return self;
}

- (instancetype)initCreateTopicOrSerialViewControllerWithType:(ArticleType)type
{
    self = [self init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *tabLable = [[UILabel alloc] init];
    tabLable.font = CKTextViewFont;
    tabLable.text = @"专题/连载:";
    tabLable.textColor = kTEXTCOLOR;
    [self.view addSubview:tabLable];
    [tabLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.top.equalTo(self.view).offset(16+64);
    }];
    
    self.chioseTabButton = [[UIButton alloc] init];
    [self.chioseTabButton setTitle:@"选择专题/连载" forState:UIControlStateNormal];
    [self.chioseTabButton setTitleColor:HEXCOLOR(0xcdcdcd) forState:UIControlStateNormal];
    self.chioseTabButton.titleLabel.font = CKTextViewFont;
    [self.chioseTabButton addTarget:self action:@selector(chioseType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chioseTabButton];
    [self.chioseTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tabLable.mas_right).offset(8);
        make.centerY.equalTo(tabLable);
    }];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.font = CKTextViewFont;
    titleLable.text = @"输入标题:";
    titleLable.textColor = kTEXTCOLOR;
    [self.view addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.top.equalTo(tabLable.mas_bottom).offset(8);
    }];
    
    self.titleField = [[UITextField alloc] init];
    self.titleField.placeholder = @"请输入标题...";
    [self.view addSubview:self.titleField];
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLable.mas_right).offset(8);
        make.centerY.equalTo(titleLable);
    }];
    
    UILabel *descriptionLable = [[UILabel alloc] init];
    descriptionLable.font = CKTextViewFont;
    descriptionLable.text = @"描述:";
    descriptionLable.textColor = kTEXTCOLOR;
    [self.view addSubview:descriptionLable];
    [descriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.top.equalTo(titleLable.mas_bottom).offset(8);
    }];
    
    [self.view addSubview:self.descriptionTextView];
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionLable.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-8);
        make.height.mas_equalTo(100);
    }];
    
    UILabel *picLable = [[UILabel alloc] init];
    picLable.font = CKTextViewFont;
    picLable.text = @"选择封面:";
    picLable.textColor = kTEXTCOLOR;
    [self.view addSubview:picLable];
    [picLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.top.equalTo(self.descriptionTextView.mas_bottom).offset(8);
    }];
    
    [self.view addSubview:self.addPicButton];
    [self.addPicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(picLable.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(8);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.createButton];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPicButton.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-100);
        make.height.mas_equalTo(40);
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s ",__func__);
    self.navigationItem.leftBarButtonItem = [TubeNavigationUITool itemWithIconImage:[UIImage imageNamed:@"icon_back"] title:@"返回" titleColor:kTUBEBOOK_THEME_NORMAL_COLOR target:self action:@selector(back)];
    self.navigationItem.title = @"专题/连载 创建";
    
}

#pragma mark - action
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

- (IBAction)chioseType:(id)sender
{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"选择类型" cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1:
            {
                self.type = ArticleTypeTopic;
                [self.chioseTabButton setTitle:@"专题" forState:UIControlStateNormal];
                [self.chioseTabButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
                break;
            }
            case 2:
            {
                self.type = ArticleTypeSerial;
                [self.chioseTabButton setTitle:@"连载" forState:UIControlStateNormal];
                [self.chioseTabButton setTitleColor:kTUBEBOOK_THEME_NORMAL_COLOR forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
    } otherButtonTitleArray:@[@"专题", @"连载"] ];
    [sheet show];
}

- (IBAction)createTab:(id)sender
{
    if ( self.type == ArticleTypeMornal ) {
        [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"请选择专题/连载" duration:1.0f fromeVC:self];
        return ;
    }
    
    if (  self.titleField.text.length==0 ) {
        [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"请输入标题" duration:1.0f fromeVC:self];
        return ;
    }
    [[TubeSDK sharedInstance].tubeArticleSDK createTopicOrSerialTabWithUid:[[UserInfoUtil sharedInstance].userInfo objectForKey:kAccountKey] type:self.type title:self.titleField.text description:self.descriptionTextView.text pic:self.tabPic allBack:^(DataCallBackStatus status, BaseSocketPackage *page) {
        if ( status == DataCallBackStatusSuccess ) {
            //[[TubeAlterCenter sharedInstance] postAlterWithMessage:@"创建成功" duration:2.0f fromeVC:self];

            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"创建成功" duration:2.0f completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];

        } else {
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"创建失败" duration:2.0f fromeVC:self];
        }
    }];

}

- (IBAction)addPic:(id)sender
{
    if ([TubePhotoUtil isCanUsePhotos]) {
        NSLog(@"%s primary success", __func__);
        self.pickerController = [[UIImagePickerController alloc] init];
        self.pickerController.delegate = self;
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.pickerController animated:YES completion:nil];
        
    } else {
        NSLog(@"%s primary fail",__func__);
        [AltertControllerUtil showAlertTitle:@"警告" message:@"没有访问相册的权限！请到设置中设置权限！" confirmTitle:@"确定" confirmBlock:nil cancelTitle:nil cancelBlock:nil fromControler:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
    //[[TubeAlterCenter sharedInstance] showAlterIndicatorWithMessage:@"正在上传图片" fromeVC:self];
    [self.addPicButton setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    [UploadImageUtil uploadImage:[info objectForKey:UIImagePickerControllerOriginalImage] success:^(NSDictionary *dic) {
        [[TubeAlterCenter sharedInstance] dismissAlterIndicatorViewController];
        NSLog(@"%s picker image success: %@",__func__, dic);
        NSString *fileName = [dic objectForKey:@"fileName"];
        NSString *message = [dic objectForKey:@"message"];
        if ([message containsString:@"success"]) {
            // [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传成功" duration:1.0f fromeVC:self];
            self.tabPic = [NSString stringWithFormat:@"http://127.0.0.1:8084/TubeBook_Web/upload/%@",fileName];
        } else {
            [[TubeAlterCenter sharedInstance] dismissAlterIndicatorViewController];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传失败，请查看网络！" duration:1.0f fromeVC:self];
            });
        }
    } fail:^(NSError *error) {
        // [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传失败" duration:1.0f fromeVC:self];
        NSLog(@"%s picker image fail: %@",__func__, error);
        [[TubeAlterCenter sharedInstance] dismissAlterIndicatorViewController];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[TubeAlterCenter sharedInstance] postAlterWithMessage:@"上传失败，请查看网络！" duration:1.0f fromeVC:self];
        });
    }];
}


#pragma mark - get
- (UITextView *)descriptionTextView
{
    if (!_descriptionTextView) {
        _descriptionTextView = [[UITextView alloc] init];
        _descriptionTextView.layer.borderWidth = 0.5f;
        _descriptionTextView.layer.cornerRadius = 4.0f;
        _descriptionTextView.layer.borderColor = kTAB_TEXT_COLOR.CGColor;
        _descriptionTextView.layer.masksToBounds = YES;
    }
    return _descriptionTextView;
}

- (UIButton *)addPicButton
{
    if (!_addPicButton) {
        _addPicButton = [[UIButton alloc] init];
        [_addPicButton setBackgroundImage:[UIImage imageNamed:@"icon_add_pic"] forState:UIControlStateNormal];
        [_addPicButton addTarget:self action:@selector(addPic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPicButton;
}

- (UITubeButton *)createButton
{
    if (!_createButton) {
        _createButton = [[UITubeButton alloc] initUITubeButton:@"发布" normalColor:kTUBEBOOK_THEME_NORMAL_COLOR lightColor:kTUBEBOOK_THEME_ALPHA_COLOR];
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_createButton addTarget:self action:@selector(createTab:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createButton;
}

@end
