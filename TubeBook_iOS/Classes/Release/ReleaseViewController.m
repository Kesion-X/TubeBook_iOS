//
//  ReleaseViewController.m
//  UItextViewTest
//
//  Created by 柯建芳 on 2018/3/5.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "ReleaseViewController.h"
#import "CKMacros.h"
#import "UITubeNavigationView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "AltertControllerUtil.h"
#import "AFNetworking.h"
#import "UploadImageUtil.h"
#define MormalColor [UIColor whiteColor]
#define LightColor kTUBEBOOK_THEME_NORMAL_COLOR
#define h1 @"<span style=\" font: 28.0px 'Times New Roman'; color: #000000; -webkit-text-stroke: #000000\"><b>"
#define h2 @"<span style=\" font: 24.0px 'Times New Roman'; color: #000000; -webkit-text-stroke: #000000\"><b>"
#define h3 @"<span style=\" font: 18.0px 'Times New Roman'; color: #000000; -webkit-text-stroke: #000000\"><b>"
#define span @"<span style=\" font: 14.0px 'Times New Roman'; color: #000000; -webkit-text-stroke: #000000\">"

typedef NS_ENUM(NSInteger, FontStyle) {
    SpanStyle,
    H1Style,
    H2Style,
    H3Style
};

@interface ReleaseViewController () <UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *spanbutton;
@property (nonatomic, strong) UIButton *h1Button;
@property (nonatomic, strong) UIButton *h2Button;
@property (nonatomic, strong) UIButton *h3Button;
@property (nonatomic, strong) UIButton *imgeButton;
@property (nonatomic, strong) UIView *board;
@property (nonatomic, strong) UIButton *hiddenBoardButton;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *releaseButton;
@property (nonatomic, strong) UITextField *titleField;
    
@end

@implementation ReleaseViewController
{
    FontStyle currentFontStyle;
    NSString *currentStyle;
    NSMutableAttributedString *contentAttributedString;
    NSAttributedString *currentAttributedString;
    NSUInteger location;
    bool isDelect;
    bool isComplete;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.textView.delegate = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationLayout];
    [self setupLayout];
    [self configTextView];
    [self notificationKeyBoard];
    NSLog(@"ddd");
}

- (void)navigationLayout
{
    UITubeNavigationView *view = [[UITubeNavigationView alloc] initUITubeNavigationView:self leftTitle:@"返回" leftBtCallback:nil rightTitle:@"发布" rightBtCallback:nil centerTitle:@"文章编辑"];
    [self.view addSubview:view];
}

- (void)configTextView
{
    contentAttributedString = [[NSMutableAttributedString alloc] init];
    self.textView.attributedText = contentAttributedString;
    self.textView.delegate = self;
    currentFontStyle = SpanStyle;
    currentStyle = span;
    isComplete = YES;
    isDelect = NO;
}

- (void)setupLayout
{
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 105, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-105 - 330)];
    [self.view addSubview:self.textView];
    
    self.board = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 320)];
    [self.board setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.board];
    self.board.hidden = YES;
    
    self.hiddenBoardButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50 , 0, 50, 40)];
    [self.hiddenBoardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hiddenBoardButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.hiddenBoardButton setTitleColor:LightColor forState:UIControlStateHighlighted];
    [self.hiddenBoardButton addTarget:self action:@selector(downKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [self.board addSubview:self.hiddenBoardButton];
    
    self.spanbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [self.spanbutton setTitleColor:MormalColor forState:UIControlStateNormal];
    [self.spanbutton setTitleColor:LightColor forState:UIControlStateHighlighted];
    [self.spanbutton setTitle:@"span" forState:UIControlStateNormal];
    [self.board addSubview:self.spanbutton];
    
    
    self.h1Button = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, 40)];
    [self.h1Button setTitleColor:MormalColor forState:UIControlStateNormal];
    [self.h1Button setTitleColor:LightColor forState:UIControlStateHighlighted];
    [self.h1Button setTitle:@"H1" forState:UIControlStateNormal];
    [self.board addSubview:self.h1Button];
    
    self.h2Button = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 50, 40)];
    [self.h2Button setTitleColor:MormalColor forState:UIControlStateNormal];
    [self.h2Button setTitleColor:LightColor forState:UIControlStateHighlighted];
    [self.h2Button setTitle:@"H2" forState:UIControlStateNormal];
    [self.board addSubview:self.h2Button];
    
    self.h3Button = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, 50, 40)];
    [self.h3Button setTitleColor:MormalColor forState:UIControlStateNormal];
    [self.h3Button setTitleColor:LightColor forState:UIControlStateHighlighted];
    [self.h3Button setTitle:@"H3" forState:UIControlStateNormal];
    [self.board addSubview:self.h3Button];
    
    [self.spanbutton addTarget:self action:@selector(spanStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.h1Button addTarget:self action:@selector(h1click:) forControlEvents:UIControlEventTouchUpInside];
    [self.h2Button addTarget:self action:@selector(h2click:) forControlEvents:UIControlEventTouchUpInside];
    [self.h3Button addTarget:self action:@selector(h3click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgeButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 40)];
    [self.imgeButton setTitleColor:MormalColor forState:UIControlStateNormal];
    [self.imgeButton setTitleColor:LightColor forState:UIControlStateHighlighted];
    [self.imgeButton setTitle:@"img" forState:UIControlStateNormal];
    [self.board addSubview:self.imgeButton];
    [self.imgeButton addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeSelectStyleButtonColor];
    
    [self configTitleField];
}

- (void)configTitleField
{
    self.titleField = [[UITextField alloc] initWithFrame:CGRectMake(5, 64 + 5, SCREEN_WIDTH - 10, 31)];
    [self.view addSubview:self.titleField];
    self.titleField.placeholder = @"标题";
    self.titleField.font = Font(24);
    self.titleField.textColor = kTEXTCOLOR;
   // [self.titleField setBackgroundColor:[UIColor grayColor]];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 105, SCREEN_WIDTH - 10, 1)];
    [lineView setBackgroundColor:HEXCOLOR(0xdddddd)];
    [self.view addSubview:lineView];
}

- (void)notificationKeyBoard
{
    //监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}



#pragma mark - private

- (NSString *)htmlStringByHtmlAttributeString:(NSAttributedString *)htmlAttributeString
{
    NSString *htmlString;
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [htmlAttributeString dataFromRange:NSMakeRange(0, htmlAttributeString.length) documentAttributes:exportParams error:nil];
    htmlString = [[NSString alloc] initWithData:htmlData encoding: NSUTF8StringEncoding];
    return htmlString;
}

// 显示富文本
- (NSAttributedString *)showAttributedToHtml:(NSString *)html withWidth:(float)width
{
    // 替换图片的高度为屏幕的高度
    NSString *newString = html;
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:[newString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attributeString;
    
}

- (void)changeSelectStyleButtonColor
{
    switch (currentFontStyle) {
        case SpanStyle:
            [self.spanbutton setTitleColor:LightColor forState:UIControlStateNormal];
            [self.h1Button setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h2Button setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h3Button setTitleColor:MormalColor forState:UIControlStateNormal];
            break;
        case H1Style:
            [self.spanbutton setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h1Button setTitleColor:LightColor forState:UIControlStateNormal];
            [self.h2Button setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h3Button setTitleColor:MormalColor forState:UIControlStateNormal];
            break;
        case H2Style:
            [self.spanbutton setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h1Button setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h2Button setTitleColor:LightColor forState:UIControlStateNormal];
            [self.h3Button setTitleColor:MormalColor forState:UIControlStateNormal];
            break;
        case H3Style:
            [self.spanbutton setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h1Button setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h2Button setTitleColor:MormalColor forState:UIControlStateNormal];
            [self.h3Button setTitleColor:LightColor forState:UIControlStateNormal];
            break;
    }
}

#pragma mark - listener

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    
    self.board.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - height - 40, [UIScreen mainScreen].bounds.size.width, height + 40);
    [self.board setNeedsUpdateConstraints]; //通知系统视图中的约束需要更新
    [self.board updateConstraintsIfNeeded]; //
    
    
    self.textView.frame = CGRectMake(10, 105, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-105 - 330);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.board.hidden = NO;
        [self.view layoutIfNeeded];
    }];

    
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    
    self.board.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, height + 40);
    [self.board setNeedsUpdateConstraints]; //通知系统视图中的约束需要更新
    [self.board updateConstraintsIfNeeded]; //
    
    
    self.textView.frame = CGRectMake(10, 105, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-105 -20);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.board.hidden = YES;
        [self.view layoutIfNeeded];
    }];
    
}

- (IBAction)downKeyBoard:(id)sender
{
    [self.textView resignFirstResponder];
}

- (IBAction)spanStyle:(id)sender
{
    currentFontStyle = SpanStyle;
    currentStyle = span;
    [self changeSelectStyleButtonColor];
    NSLog(@"%@",[self htmlStringByHtmlAttributeString:self.textView.attributedText]);
}
    
- (IBAction)h1click:(id)sender
{
    currentFontStyle = H1Style;
    currentStyle = h1;
    [self changeSelectStyleButtonColor];
}
        
- (IBAction)h2click:(id)sender
{
    currentFontStyle = H2Style;
    currentStyle = h2;
    [self changeSelectStyleButtonColor];
}

- (IBAction)h3click:(id)sender
{
    currentFontStyle = H3Style;
    currentStyle = h3;
    [self changeSelectStyleButtonColor];
}

- (BOOL)isCanUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author != ALAuthorizationStatusDenied || author != ALAuthorizationStatusAuthorized) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
}


- (IBAction)imageClick:(id)sender
{

    if ([self isCanUsePhotos]) {
        NSLog(@"primary yes");
        self.pickerController = [[UIImagePickerController alloc] init];
        self.pickerController.delegate = self;
        self.pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.pickerController animated:YES completion:nil];

    } else {
        [AltertControllerUtil showAlertTitle:@"警告" message:@"没有访问相册的权限！请到设置中设置权限！" confirmTitle:@"确定" confirmBlock:nil cancelTitle:nil cancelBlock:nil fromControler:self];
    }
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"select %@",self.textView.text);
    NSLog(@"shouldChangeTextInRange %ld %ld %@",range.location,range.length,text);
    if ([text isEqualToString:@""] && range.length>0) { // 删除
        NSLog(@"contentAttributedString %ld",contentAttributedString.length);
        if (contentAttributedString.length < range.location || contentAttributedString.length < range.location+range.length) {
            return YES;
        }
        NSLog(@"delect");
        isDelect = YES;
        @try {
            [contentAttributedString replaceCharactersInRange:range withString:@""];
        } @catch (NSException *error){
            NSLog(@"%@",error);
        }

    }else if ([text isEqualToString:@" "]) {
        isDelect = NO;
        isComplete = NO;
        NSLog(@"add &nbsp");
        NSString *str = @"";
        text = @"&nbsp";
        location = range.location;
        if ([currentStyle isEqualToString:span]) {
            str = [NSString stringWithFormat:@"%@%@</span>",currentStyle,text];
        } else {
            str = [NSString stringWithFormat:@"%@%@</b></span>",currentStyle,text];
        }
        currentAttributedString = [self showAttributedToHtml:str withWidth:0];
    }else if ([text isEqualToString:@"\n"] && range.length==0){//换行
        isDelect = NO;
        isComplete = NO;
        NSString *str = @"";
        location = range.location;
        str = [NSString stringWithFormat:@"<span>%@</span><br/>",text];
        currentAttributedString = [self showAttributedToHtml:str withWidth:0];
    }else if (text.length>=1 && range.length>0){ // 增加 可能增加一个字符，也可能是多个字符（因为自动输入法的关系）
        if ([[[self textInputMode] primaryLanguage] isEqualToString:@"zh-Hans"]) {
            NSLog(@"add");
            isDelect = NO;
            isComplete = NO;
            NSString *str = @"";
            location = range.location;
            if ([currentStyle isEqualToString:span]) {
                str = [NSString stringWithFormat:@"%@%@</span>",currentStyle,text];
            } else {
                str = [NSString stringWithFormat:@"%@%@</b></span>",currentStyle,text];
            }
            currentAttributedString = [self showAttributedToHtml:str withWidth:0];
        } else if ([[[self textInputMode] primaryLanguage] isEqualToString:@"en-US"]){
            [contentAttributedString replaceCharactersInRange:range withString:@""];
            NSLog(@"add");
            isDelect = NO;
            isComplete = NO;
            NSString *str = @"";
            location = range.location;
            if ([currentStyle isEqualToString:span]) {
                str = [NSString stringWithFormat:@"%@%@</span>",currentStyle,text];
            } else {
                str = [NSString stringWithFormat:@"%@%@</b></span>",currentStyle,text];
            }
            currentAttributedString = [self showAttributedToHtml:str withWidth:0];
        }
    } else if (text.length>=1 && range.length==0){
        int c =(int)[text characterAtIndex:0];
        if (c>256 && [[[self textInputMode] primaryLanguage] isEqualToString:@"zh-Hans"]) { //中文
            NSLog(@"add");
            isDelect = NO;
            isComplete = NO;
            NSString *str = @"";
            location = range.location;
            if ([currentStyle isEqualToString:span]) {
                str = [NSString stringWithFormat:@"%@%@</span>",currentStyle,text];
            } else {
                str = [NSString stringWithFormat:@"%@%@</b></span>",currentStyle,text];
            }
            currentAttributedString = [self showAttributedToHtml:str withWidth:0];
        } else if ([[[self textInputMode] primaryLanguage] isEqualToString:@"en-US"]) {
            NSLog(@"add");
            isDelect = NO;
            isComplete = NO;
            NSString *str = @"";
            location = range.location;
            if ([currentStyle isEqualToString:span]) {
                str = [NSString stringWithFormat:@"%@%@</span>",currentStyle,text];
            } else {
                str = [NSString stringWithFormat:@"%@%@</b></span>",currentStyle,text];
            }
            currentAttributedString = [self showAttributedToHtml:str withWidth:0];
        }
    }
    return YES;

}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (!isDelect) {
        if (!isComplete) {
            @try{
                isComplete = YES;
                NSLog(@"point %ld",location);
                [contentAttributedString insertAttributedString:currentAttributedString atIndex:location];
                //[contentAttributedString appendAttributedString:currentAttributedString];
                self.textView.attributedText = contentAttributedString;
            } @catch (NSException *e) {
                NSLog(@"exception %@",e);
            }
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
    [UploadImageUtil uploadImage:[info objectForKey:UIImagePickerControllerOriginalImage] success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        NSString *fileName = [dic objectForKey:@"fileName"];
        NSString *message = [dic objectForKey:@"message"];
        
        if ([message containsString:@"success"]) {
            CGRect rect_screen = [[UIScreen mainScreen]bounds];
            CGSize size_screen = rect_screen.size;
        
            CGFloat scale_screen = [UIScreen mainScreen].scale;
        
            CGFloat width = size_screen.width*scale_screen;
        
            NSString *str = [NSString stringWithFormat:@"<br/><div style=\"text-align: center; width: %fpx;\"><img src=\"http://127.0.0.1:8084/TubeBook_Web/upload/%@\" style=\"margin: 0 auto;\" /></div><br/>",width,fileName];
            currentAttributedString = [self showAttributedToHtml:str withWidth:0];
            @try{
                [contentAttributedString insertAttributedString:currentAttributedString atIndex:self.textView.selectedRange.location];
                //[contentAttributedString appendAttributedString:currentAttributedString];
                self.textView.attributedText = contentAttributedString;
    //            NSLog(@"imm %ld",self.textView.selectedRange.location);
                NSString *strp = @"";
                strp = [NSString stringWithFormat:@"<span>\n</span><br/>"];
                currentAttributedString = [self showAttributedToHtml:strp withWidth:0];
                [contentAttributedString insertAttributedString:currentAttributedString atIndex:self.textView.selectedRange.location];
                [self.textView becomeFirstResponder];
            } @catch (NSException *error){
                NSLog(@"%@",error);
            }
        }
        
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
   
}


@end
