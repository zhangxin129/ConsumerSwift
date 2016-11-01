//
//  GYHDMainViewController.m
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMainViewController.h"
//#import "GYReLogin.h"
//#import "GYHDMessageViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDMessageViewController.h"
#import "GYHDFriendsViewController.h"
#import "GYHDFocusCompanyViewController.h"
//#import "GYHDFocusCompanyViewController.h"
#import "GYHDGroupViewController.h"
#import "GYHDUserSetingViewController.h"
#import "GYSlideMenuController.h"
#import "GYHDUserInfoViewController.h"
#import "GYHSLoginViewController.h"
//#import "GYXMPP.h"
#import "GYHDSeachMessageViewController.h"
#import "GYHDChatViewController.h"
#import "GYHDSearchFriendViewController.h"
#import "GYHDFriendDetailViewController.h"
#import "GYShopAboutViewController.h"
#import "GYHDAttentionCompanyViewController.h"
#import "GYTabBarController.h"
#import "GYHSLoginManager.h"
#import "GYAlertView.h"
#import "UIView+Extension.h"
#import "GYHDNavigationController.h"

@interface GYHDMainViewController () <UIScrollViewDelegate>
/**
 * 主控制器
 */
@property (nonatomic, weak) UIScrollView* MainScrollView;
/**
 * 消息控制器
 */
@property (nonatomic, weak) GYHDMessageViewController* HDMessageViewController;
/**
 * 企业控制器
 */
@property (nonatomic, weak) GYHDFocusCompanyViewController* HDCompanyViewController;
/**
 * 好友控制器
 */
@property (nonatomic, weak) GYHDFriendsViewController* HDFriendsViewController;
/**
 * 群主控制器
 */
@property (nonatomic, weak) GYHDGroupViewController* HDGroupViewController;
/**
 * 选中的按钮
 */
@property (nonatomic, weak) UIButton* selectButton;
/**
 * 消息按钮
 */
@property (nonatomic, weak) UIButton* messageBtn;
/**
 * 企业按钮
 */
@property (nonatomic, weak) UIButton* companyBtn;
/**
 * 好友按钮
 */
@property (nonatomic, weak) UIButton* friendBtn;
/**
 * 群组按钮
 */
@property (nonatomic, weak) UIButton* groupBtn;
/**连接状态Label*/
@property (nonatomic, weak) UIButton* linkTitleButton;

/**
 */
@property (nonatomic, weak) UIImageView* userImageView;

@end

@implementation GYHDMainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[GYHDMessageCenter sharedInstance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    [self.view addSubview:scrollView];
    self.MainScrollView = scrollView;
    //1. 设置navi
    [self setupNav];
    //2.创建视图控制器
    [self createChlidVC];
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChange)];
}

- (void)changeLinkButton
{
    if (globalData.loginModel.token == nil) {

        self.HDMessageViewController.view.hidden = YES;
        self.HDCompanyViewController.view.hidden = YES;
        self.HDFriendsViewController.view.hidden = YES;
        self.linkTitleButton.hidden = NO;
        return;
    }

//    NSLog(@"xxx = %@",self.tabBarController.selectedViewController.);

//    NSLog(@"xxx = %luu",self.tabBarController.selectedIndex);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch ([GYHDMessageCenter sharedInstance].state) {
            case   GYHDMessageLoginStateAuthenticateSucced://登录验证成功
            {
                self.linkTitleButton.hidden = YES;
                self.HDMessageViewController.view.hidden = NO;
                self.HDCompanyViewController.view.hidden = NO;
                self.HDFriendsViewController.view.hidden = NO;
                self.MainScrollView.y = 0;
                break;
            }
            case   GYHDMessageLoginStateUnknowError:
            case   GYHDMessageLoginStateConnetToServerSucced:
            case   GYHDMessageLoginStateConnetToServerTimeout:
            {
                self.MainScrollView.y = 0;
                self.linkTitleButton.hidden = NO;
                break;
            }
                
            case   GYHDMessageLoginStateConnetToServerFailure:
            {
                if (globalData.isOnNet) {
                    [self.linkTitleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_network_failed"] forState:UIControlStateNormal];
                }else  {
                    [self.linkTitleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_network_Using"] forState:UIControlStateNormal];
                }

                self.linkTitleButton.hidden = NO;
                self.MainScrollView.y = 40;
                break;
            }
            case   GYHDMessageLoginStateAuthenticateFailure:
            {
                self.tabBarItem.badgeValue = nil;
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                self.linkTitleButton.hidden = NO;
                [self.linkTitleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_Failure_Identity"] forState:UIControlStateNormal];
                self.MainScrollView.y = 40;
                self.HDMessageViewController.view.hidden = YES;
                self.HDCompanyViewController.view.hidden = YES;
                self.HDFriendsViewController.view.hidden = YES;
                    id seleVC =  self.tabBarController.selectedViewController;
                    if ([seleVC isKindOfClass:[GYHDNavigationController class]]) {
                        [GYAlertView showMessage:[GYUtils localizedStringWithKey:@"GYHD_Main_reLogin"] cancleButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] confirmButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_Main_log_in_immediately"] cancleBlock:nil confirmBlock:^{
                            [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
                        }];
                    }
    
                break;
            }
            case GYHDMessageLoginStateOtherLogin:
            {
                self.tabBarItem.badgeValue = nil;
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                self.linkTitleButton.hidden = NO;
                [self.linkTitleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_other_login"] forState:UIControlStateNormal];
                self.MainScrollView.y = 40;
                self.HDMessageViewController.view.hidden = YES;
                self.HDCompanyViewController.view.hidden = YES;
                self.HDFriendsViewController.view.hidden = YES;
                id seleVC =  self.tabBarController.selectedViewController;
                if ([seleVC isKindOfClass:[GYHDNavigationController class]]) {
                    [GYAlertView showMessage:[GYUtils localizedStringWithKey:@"GYHD_Main_reLogin"] cancleButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] confirmButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_Main_log_in_immediately"] cancleBlock:nil confirmBlock:^{
//                        [GYLoginManager showLoginView:0 otherLogin:YES];
                    [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:YES];
                    }];
                }
                break;
            }
            default:
                break;
        }
    });
}
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"state"]) {
        //[self changeLinkButton];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // [self changeLinkButton];
    [self messageCenterDataBaseChange];
    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    if ([dict[GYHDDataBaseCenterFriendIcon] hasPrefix:@"http"]) {
        [self.userImageView setImageWithURL:[NSURL URLWithString:dict[GYHDDataBaseCenterFriendIcon]] placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
    }
    else {
        NSString* imageUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, dict[GYHDDataBaseCenterFriendIcon]];
        [self.userImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
        ;
    }
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
}

- (void)setupNav
{
    //1. 设置左边

    UIImageView* userImageView = [[UIImageView alloc] init];
    userImageView.userInteractionEnabled = YES;
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = 3;
    userImageView.layer.borderWidth = 1;
    userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick:)];
    [userImageView addGestureRecognizer:tapGR];
    userImageView.frame = CGRectMake(0, 0, 32, 32);
    _userImageView = userImageView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userImageView];
    //2. 设置中间
    UIView* segmentView = [[UIView alloc] init];
    segmentView.frame = CGRectMake(0, 0, 230 - 57, 25);
    self.navigationItem.titleView = segmentView;

    UIButton* messageBtn = [self setupTitleViewtitle: [GYUtils localizedStringWithKey:@"GYHD_message"] imageName:@"gyhd_nav_titleView_left_normal" selectImageName:@"gyhd_nav_titleView_left_selected"];
    messageBtn.selected = YES;
    messageBtn.userInteractionEnabled = NO;
    self.selectButton = messageBtn;
    messageBtn.frame = CGRectMake(0, 0, 57, 25);
    [segmentView addSubview:messageBtn];
    self.messageBtn = messageBtn;

    UIButton* companyBtn = [self setupTitleViewtitle: [GYUtils localizedStringWithKey:@"GYHD_Company"] imageName:@"gyhd_nav_titleView_center_normal" selectImageName:@"gyhd_nav_titleView_center_selected"];
    companyBtn.frame = CGRectMake(57, 0, 57, 25);
    [segmentView addSubview:companyBtn];
    self.companyBtn = companyBtn;

    UIButton* friendBtn = [self setupTitleViewtitle:[GYUtils localizedStringWithKey:@"GYHD_user_addfriedn_friend"] imageName:@"gyhd_nav_titleView_right_normal" selectImageName:@"gyhd_nav_titleView_right_selected"];
    friendBtn.frame = CGRectMake(114, 0, 57, 25);
    [segmentView addSubview:friendBtn];
    self.friendBtn = friendBtn;
    //3. 设置右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhd_nav_right_search"] style:UIBarButtonItemStylePlain target:self action:@selector(SearchClick)];
}

#pragma mark - 点击头像method
- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
    if (!globalData.isLogined) {
        [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
        return;
    }
    
    globalData.viewController.animationType = SlideAnimationTypeMove;
    globalData.viewController.needSwipeShowMenu = YES;
    globalData.viewController.needShowBoundsShadow = YES;
    
    [globalData.viewController showLeftViewController:YES];
    return;
    
    //旧数据交换
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    GYHDUserInfoViewController* userInfoViewController = [[GYHDUserInfoViewController alloc] init];
    if ([myDict[@"Friend_CustID"] isKindOfClass:[NSNull class]]) {
        userInfoViewController.custID = globalData.loginModel.custId;
    }
    else {
        userInfoViewController.custID = myDict[@"Friend_CustID"];
    }
    userInfoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfoViewController animated:YES];
}

- (UIButton*)setupTitleViewtitle:(NSString*)title imageName:(NSString*)imageName selectImageName:(NSString*)selectImageName
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    button.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    return button;
}

- (void)SearchClick
{
    if (!globalData.isLogined) {
        [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
        return;
    }

    GYHDSeachMessageViewController* seachMessageViewController = [[GYHDSeachMessageViewController alloc] init];
    seachMessageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seachMessageViewController animated:YES];
}

- (void)addFiendClick
{
    if (!globalData.isLogined) {
        [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
        return;
    }
    GYHDSearchFriendViewController* searchFriendViewController = [[GYHDSearchFriendViewController alloc] init];
    searchFriendViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchFriendViewController animated:YES];
}

- (void)addCompanyClick
{
    if (!globalData.isLogined) {
        [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
        return;
    }
    GYHDAttentionCompanyViewController* attcompanyViewController = [[GYHDAttentionCompanyViewController alloc] init];
    attcompanyViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:attcompanyViewController animated:YES];
}

- (void)createChlidVC
{
    CGRect MFrame = [UIScreen mainScreen].bounds;
    //1. 消息控制器
    GYHDMessageViewController* HDMessageViewController = [[GYHDMessageViewController alloc] init];
    [self addChildViewController:HDMessageViewController];
    [self.MainScrollView addSubview:HDMessageViewController.view];
    _HDMessageViewController = HDMessageViewController;
    //2. 企业控制器
    GYHDFocusCompanyViewController* HDCompanyViewController = [[GYHDFocusCompanyViewController alloc] init];
    [self addChildViewController:HDCompanyViewController];
    [self.MainScrollView addSubview:HDCompanyViewController.view];
    _HDCompanyViewController = HDCompanyViewController;
    //3. 好友控制器
    GYHDFriendsViewController* HDFriendViewController = [[GYHDFriendsViewController alloc] init];
    [self addChildViewController:HDFriendViewController];
    [self.MainScrollView addSubview:HDFriendViewController.view];
    _HDFriendsViewController = HDFriendViewController;

    self.MainScrollView.frame = CGRectMake(0, 0, MFrame.size.width, MFrame.size.height);
    self.HDMessageViewController.view.frame = CGRectMake(MFrame.size.width * 0, 0, MFrame.size.width, MFrame.size.height - 104);
    self.HDCompanyViewController.view.frame = CGRectMake(MFrame.size.width * 1, 0, MFrame.size.width, MFrame.size.height - 104);
    self.HDFriendsViewController.view.frame = CGRectMake(MFrame.size.width * 2, 0, MFrame.size.width, MFrame.size.height - 104);
    [self.MainScrollView setContentSize:CGSizeMake(MFrame.size.width * 3, 0)];

//    UIButton* linkTitleButton = [[UIButton alloc] init];
//    linkTitleButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
//    [linkTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    linkTitleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    linkTitleButton.titleLabel.numberOfLines = 0;
//    [linkTitleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_network_failed"] forState:UIControlStateNormal];
//    [linkTitleButton setImage:[UIImage imageNamed:@"gyhd_network_fialed"] forState:UIControlStateNormal];
//    [linkTitleButton setBackgroundColor:[UIColor colorWithRed:253 / 255.0f green:239 / 255.0f blue:219 / 255.0f alpha:1]];
//    [self.view addSubview:linkTitleButton];
//    _linkTitleButton = linkTitleButton;
//    linkTitleButton.frame = CGRectMake(0, 0, kScreenWidth, 40);
}

- (void)messageCenterDataBaseChange
{
    if (globalData.isLogined) {
        
    
    NSInteger count = [[GYHDMessageCenter sharedInstance] UnreadAllMessageCount];
    if (count == 0) {
        self.tabBarItem.badgeValue = nil;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    else {
        if (count > 99) {
            self.tabBarItem.badgeValue = @"99+";
            [UIApplication sharedApplication].applicationIconBadgeNumber = 99;
        }
        else {
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)count];
            [UIApplication sharedApplication].applicationIconBadgeNumber = count;
        }
    }
    }
}
- (void)dealloc
{
    [[GYHDMessageCenter sharedInstance] removeObserver:self forKeyPath:@"state"];
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark--UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSInteger selectInt = (int)scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;

    switch (selectInt) {
    case 0: {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhd_nav_right_search"] style:UIBarButtonItemStylePlain target:self action:@selector(SearchClick)];
        if ([self.messageBtn.currentTitle isEqualToString:self.selectButton.currentTitle])
            return;
        self.messageBtn.selected = YES;
        self.messageBtn.userInteractionEnabled = NO;
        self.selectButton.selected = NO;
        self.selectButton.userInteractionEnabled = YES;
        self.selectButton = self.messageBtn;
        break;
    }
    case 1: {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhd_nav_add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addCompanyClick)];
        if ([self.companyBtn.currentTitle isEqualToString:self.selectButton.currentTitle])
            return;
        self.companyBtn.selected = YES;
        self.companyBtn.userInteractionEnabled = NO;
        self.selectButton.selected = NO;
        self.selectButton.userInteractionEnabled = YES;
        self.selectButton = self.companyBtn;
        break;
    }
    case 2: {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhd_nav_add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addFiendClick)];
        if ([self.friendBtn.currentTitle isEqualToString:self.selectButton.currentTitle])
            return;
        self.friendBtn.selected = YES;
        self.friendBtn.userInteractionEnabled = NO;
        self.selectButton.selected = NO;
        self.selectButton.userInteractionEnabled = YES;
        self.selectButton = self.friendBtn;
        break;
    }
    case 3: {
        if ([self.groupBtn.currentTitle isEqualToString:self.selectButton.currentTitle])
            return;
        self.groupBtn.selected = YES;
        self.groupBtn.userInteractionEnabled = NO;
        self.selectButton.selected = NO;
        self.selectButton.userInteractionEnabled = YES;
        self.selectButton = self.groupBtn;
        break;
    }
    default:
        break;
    }
}

#pragma mark--NavButton
- (void)buttonClick:(UIButton*)button
{
    self.selectButton.selected = NO;
    self.selectButton.userInteractionEnabled = YES;
    button.selected = YES;
    button.userInteractionEnabled = NO;
    self.selectButton = button;
    if ([button.currentTitle isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_message"]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhd_nav_right_search"] style:UIBarButtonItemStylePlain target:self action:@selector(SearchClick)];
        self.MainScrollView.contentOffset = CGPointMake(0 * [UIScreen mainScreen].bounds.size.width, 0);
    }
    else if ([button.currentTitle isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_Company"]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhd_nav_add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addCompanyClick)];
        self.MainScrollView.contentOffset = CGPointMake(1 * [UIScreen mainScreen].bounds.size.width, 0);
    }
    else if ([button.currentTitle isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_user_addfriedn_friend"]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhd_nav_add_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addFiendClick)];
        self.MainScrollView.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width, 0);
        [self.HDFriendsViewController reloadTableView];
    } else if ([button.currentTitle isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_Groups"]]) {
        self.MainScrollView.contentOffset = CGPointMake(3 * [UIScreen mainScreen].bounds.size.width, 0);
    }
}
@end
