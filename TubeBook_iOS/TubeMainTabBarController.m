//
//  TubeMainTabBarController.m
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/15.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import "AppDelegate.h"
#import "TubeMainTabBarController.h"
#import "TubeBundleImageTool.h"
#import "CKMacros.h"
#import "UIView+TubeFrameMargin.h"
#import "UIImage+ScaleToSize.h"
#import "ReleaseViewController.h"

@interface TubeMainTabBarController ()

@property (nonatomic, strong) ReleaseViewController *releaseViewController;

@end

@implementation TubeMainTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewControllers = [NSArray arrayWithObjects:self.homeTabViewController,
                                self.descoverTabViewController,
                                self.releaseTabViewController,
                                self.messageTabViewController,
                                self.myselfTabViewController,nil];
         self.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.toolbar.hidden = YES;
    self.navigationController.view.backgroundColor = HEXCOLOR(0xffffff);
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = (id<UITabBarControllerDelegate>)self;
    self.tabBar.barTintColor = HEXCOLOR(0xffffff);
    self.tabBar.tintColor = HEXCOLOR(0xffffff);
    self.tabBar.translucent = NO;

    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_view.frame"])
    {
        [self removeObserver:self forKeyPath:@"_view.frame"];
        
        CGFloat mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
        UIWindow *window = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window;
        
        if ([self.view isDescendantOfView:window]) { // View已在Window上时，使用convertPoint处理更安全可靠
            CGPoint point  = [self.view convertPoint:CGPointZero toView:nil];
            
            if (point.y + self.view.height != mainScreenHeight) {
                self.view.height = mainScreenHeight - point.y;
            }
        } else {
            CGFloat y = CGRectGetMinY(self.navigationController.view.frame);
            
            if (y + CGRectGetMaxY(self.view.frame) != mainScreenHeight) {
                self.view.height = mainScreenHeight - y - CGRectGetMinY(self.view.frame);
            }
        }
        
        [self addObserver:self forKeyPath:@"_view.frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
//    [self.tabBarController.navigationController setNavigationBarHidden:selectedIndex == 0];
//    [self.navigationController setNavigationBarHidden:selectedIndex == 0];
}

- (void)saveTabbarSetting:(NSString *)Appid showSign:(BOOL)bsign
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:(bsign ? Appid : nil) forKey:@"tabbarAppID"];
    [userDefaults synchronize];
}

#pragma mark - get
- (UIViewController *)homeTabViewController
{
    if (!_homeTabViewController) {
        _homeTabViewController = [[HomeTabViewController alloc] init];
        _homeTabViewController.title = @"主页";
        [self configureViewController:_homeTabViewController
                                title:@"主页"
                            imageName:@"icon_normal_home"
                    selectedImageName:@"icon_light_home"];
    }
    return _homeTabViewController;
}

- (UIViewController *)descoverTabViewController
{
    if (!_descoverTabViewController) {
        _descoverTabViewController = [[DescoverTabViewController alloc] init];
        _descoverTabViewController.title = @"发现";
        [self configureViewController:_descoverTabViewController
                                title:@"发现"
                            imageName:@"icon_normal_discover"
                    selectedImageName:@"icon_light_discover"];
    }
    return _descoverTabViewController;
}

- (UIViewController *)messageTabViewController
{
    if (!_messageTabViewController) {
        _messageTabViewController = [[MessageTabViewController alloc] init];
        _messageTabViewController.title = @"消息";
        [self configureViewController:_messageTabViewController
                                title:@"消息"
                            imageName:@"icon_normal_message"
                    selectedImageName:@"icon_light_message"];
    }
    return _messageTabViewController;
}

- (UIViewController *)myselfTabViewController
{
    if (!_myselfTabViewController) {
        _myselfTabViewController = [[MyselfTabViewController alloc] init];
        _myselfTabViewController.title = @"我的";
        [self configureViewController:_myselfTabViewController
                                title:@"我的"
                            imageName:@"icon_normal_myself"
                    selectedImageName:@"icon_light_myself"];
    }
    return _myselfTabViewController;
}

- (UIViewController *)releaseTabViewController
{
    if (!_releaseTabViewController) {
        _releaseTabViewController = [[MessageTabViewController alloc] init];
        _releaseTabViewController.title = @"发布";
        _releaseTabViewController.tabBarItem.title = @"";
        _releaseTabViewController.tabBarItem.image = [[UIImage imageNamed:@"icon_add@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        _releaseTabViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6 , 0, -6 , 0);
    }
    return _releaseTabViewController;
}

- (UIViewController *)releaseViewController
{
    if (!_releaseViewController) {
        _releaseViewController = [[ReleaseViewController alloc] init];
    }
    return _releaseViewController;
}

#pragma mark - private
- (void)configureViewController:(UIViewController *)viewController
                          title:(NSString *)title
                      imageName:(NSString *)imageName
              selectedImageName:(NSString *)selectedImageName
{
    viewController.title = title;
    viewController.tabBarItem.image = [[TubeBundleImageTool imageFromMainBundleNamed:imageName]
                                       imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[TubeBundleImageTool imageFromMainBundleNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    CGFloat delta = TUBE_FOOTER_BAR_HEIGHT;
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -4 - delta);
    delta /= 2;
    viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(-3 - delta, 0, 3 + delta, 0);
    
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       HEXCOLOR(0xbfbfbf),
                                                       NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:9],
                                                       NSFontAttributeName, nil]
                                             forState:UIControlStateNormal];
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       HEXCOLOR(0xe74c3c),
                                                       NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:9],
                                                       NSFontAttributeName, nil]
                                             forState:UIControlStateSelected];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController==self.releaseTabViewController) {
        [self presentViewController:self.releaseViewController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}

@end
