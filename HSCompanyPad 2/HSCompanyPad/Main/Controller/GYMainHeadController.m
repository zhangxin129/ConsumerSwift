//
//  GYMainHeadViewController.m
//  HSCompanyPad
//
//  Created by User on 16/7/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYMainHeadController.h"
#import "AppDelegate.h"
#import "GYAlertView.h"
#import "GYDBManager.h"
#import "GYHDSDK.h"
#import "GYLabel.h"
#import "GYLockView.h"
#import "GYLoginHttpTool.h"
#import "GYLoginView.h"
#import "GYMainBodyController.h"
#import "GYMainViewController.h"
#import "GYTitleViewController.h"
#import "GYUtils+companyPad.h"
#import "KxMenu.h"
#import <YYKit/UIButton+YYWebImage.h>
#import <YYKit/UIView+YYAdd.h>
#import "GYHDDataBaseCenter.h"
//#define kHeadBtnWidth 50
#define kHeadBtnWidth 30

#define kHeadLeftMarignWidth 12
#define kHeadRightMarignWidth 20
#define kLogoWidth 215

#define kHeadMarginWidth 12
#define kHeadMarinTop 18

@interface GYMainHeadController ()
@property (weak, nonatomic) IBOutlet UIButton* managerBtn; //管理
@property (weak, nonatomic) IBOutlet UIButton* homeBtn; //主页
@property (weak, nonatomic) IBOutlet UIImageView* logoImageView; //企业logo图片
@property (weak, nonatomic) IBOutlet UIButton* messageBtn; //消息
@property (weak, nonatomic) IBOutlet UIButton* leftBtn;
@property (weak, nonatomic) IBOutlet GYLabel* nameLabel; //管理员名称
@property (nonatomic, assign) BOOL isLocked;

@property (nonatomic, strong) UIView* maskView;
@property (nonatomic, assign)NSInteger messageuUreadCount;//数据库消息未读数量
@property (nonatomic, strong)UILabel *messageUreadLabel;//消息未读显示
@end
@interface GYMainHeadController () <GYLoginViewDelegate>

@end

@implementation GYMainHeadController

#
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self  checkMessageUreadCount];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self  addmessageUreadLabel];
    [self configUI];
    [self addAction];
    [self autoLogin];
    [self checkLogin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recheckLogin) name:GYCommonLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recheckLogin) name:GYChangeHeadImageNotification object:nil];
    [kDefaultNotificationCenter addObserver:self selector:@selector(checkLogin) name:GYCommonLogoutNotification object:nil];

    //    接收推送消息通知 显示消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkMessageUreadCount) name:GYHDPushMessageChageNotification object:nil];
    
    //  接收聊天消息通知，显示消息数量
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(checkMessageUreadCount)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenMessageUreadCount) name:GYHDOtherLoginNotification object:nil];
    [self  checkMessageUreadCount];
    
}

//添加消息未读显示
- (void)addmessageUreadLabel{

    self.messageUreadLabel=[[UILabel alloc]init];
    self.messageUreadLabel.hidden=YES;
    self.messageUreadLabel.backgroundColor=[UIColor redColor];
    self.messageUreadLabel.layer.cornerRadius=6;
    self.messageUreadLabel.layer.masksToBounds=YES;
    [self.view addSubview: self.messageUreadLabel];
    
}

-(void)hidenMessageUreadCount{

    self.messageUreadLabel.hidden=YES;
    
}

//即时通知显示到消息按钮右上角
- (void)checkMessageUreadCount{
    
    // 刷新 数据库 取所有消息个数
    self.messageuUreadCount = [[GYHDDataBaseCenter sharedInstance]UnreadAllMessageCountWithCard:globalData.loginModel.custId];
    //            推送到app图片角标
    if (self.messageuUreadCount>=99) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber=99;
        
        self.messageUreadLabel.hidden=NO;
    }else{
        
        if (self.messageuUreadCount>0) {
            
            self.messageUreadLabel.hidden=NO;
            
        }else{
        
            self.messageUreadLabel.hidden=YES;
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber=self.messageuUreadCount;
    }
    
}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self name:GYCommonLoginSuccessNotification object:nil];
    [kDefaultNotificationCenter removeObserver:self name:GYChangeHeadImageNotification object:nil];
    [kDefaultNotificationCenter removeObserver:self name:GYHDPushMessageChageNotification object:nil];
    [kDefaultNotificationCenter removeObserver:self name:GYHDOtherLoginNotification object:nil];
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
}

#pragma mark -method

- (void)configUI
{

    @weakify(self);
    
    [self.headView mas_remakeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.right.top.bottom.equalTo(self.view).mas_equalTo(0);
        
    }];
    self.headView.backgroundColor = kPurple000024;
    
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker* make) {
    
        make.left.mas_equalTo(kHeadLeftMarignWidth);
        make.top.mas_equalTo(kHeadMarinTop);
        make.bottom.mas_equalTo(-kHeadMarinTop);
        
        make.height.mas_equalTo(self.leftBtn.mas_width);
        
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker* make) {
    
        @strongify(self);
        make.top.mas_equalTo(11);
        make.bottom.mas_equalTo(-11);
        make.left.equalTo(self.leftBtn.mas_right).offset(30);
        make.width.mas_equalTo(kLogoWidth);
        
    }];
    
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.leftBtn);
        make.right.mas_equalTo(-kHeadBtnWidth);
        make.height.width.mas_equalTo(kHeadBtnWidth);
        
    }];
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.leftBtn);
        make.right.mas_equalTo(self.homeBtn.mas_left).offset(-kHeadBtnWidth);
        make.height.width.mas_equalTo(kHeadBtnWidth);
    }];
    
    [self.messageUreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.messageBtn.mas_right);
        make.centerY.equalTo(self.messageBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        
    }];
    
    [self.managerBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.equalTo(self.leftBtn);
        make.right.mas_equalTo(self.messageBtn.mas_left).offset(-kHeadBtnWidth);
        make.height.width.mas_equalTo(kHeadBtnWidth);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
    
        @strongify(self);
        make.right.equalTo(self.managerBtn.mas_left).offset(-10);
        make.top.bottom.equalTo(self.managerBtn);
        make.left.equalTo(self.logoImageView.mas_right);
    }];
    self.nameLabel.textColor = kWhiteFFFFFF;
    self.nameLabel.font = kFont36;
    
  
}

- (void)autoLogin
{

    //    [GYLoginHttpTool autoLogin];
}

- (void)addAction
{

    [self.managerBtn addTarget:self action:@selector(managerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.messageBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkLogin
{

    if (globalData.isLogined) {
        self.nameLabel.hidden = NO;
        Role* roleName = (Role*)[globalData.loginModel.roles firstObject].roleName;
        NSString* showName;
        if (globalData.loginModel.entCustName.length > 10) {
            showName = [NSString stringWithFormat:@"%@···(%@)", [globalData.loginModel.entCustName substringToIndex:10], roleName];
        } else {
            showName = [NSString stringWithFormat:@"%@(%@)", globalData.loginModel.entCustName, roleName];
        }
        self.nameLabel.text = showName;
        self.nameLabel.fullText = globalData.loginModel.entCustName;
        self.nameLabel.userInteractionEnabled = YES;
        
        [self.managerBtn setBackgroundImageWithURL:[NSURL URLWithString:GYHE_PICTUREAPPENDING(globalData.loginModel.vshopLogo)] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"btn_login_gray"]];
    } else {
        self.nameLabel.text = @"";
        self.nameLabel.fullText = @"";
        self.nameLabel.hidden = YES;
        
        [self.managerBtn setBackgroundImage:kLoadPng(@"btn_login_gray") forState:UIControlStateNormal];
    }
}

- (void)recheckLogin
{

    [self checkLogin];
}

- (void)managerAction
{
    if (!globalData.isLogined) {
        GYLoginView* loginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYLoginView class]) owner:self options:nil][0];
        loginView.delegate = self;
        [loginView show];
        return;
    }
    [globalData.timer invalidate];
    globalData.timer = nil;
    NSArray* menuItems =
        @[
           [KxMenuItem menuItem:kLocalized(@"注销")
                          image:nil
                         target:self
                         action:@selector(loginOut)],
           [KxMenuItem menuItem:kLocalized(@"锁屏")
                          image:nil
                         target:self
                         action:@selector(lockScreen)],
                         
        ];
        
    KxMenuItem* first = menuItems[0];
    first.foreColor = [UIColor blackColor];
    first.alignment = NSTextAlignmentCenter;
    KxMenuItem* second = menuItems[1];
    second.foreColor = [UIColor blackColor];
    //由于状态栏的关系，这里要下移20个像素
    CGRect frame = self.managerBtn.frame;
    frame.origin.y += 20;
    [KxMenu showMenuInWindowfromRect:frame menuItems:menuItems];
}
- (void)messageAction
{

    [[NSNotificationCenter defaultCenter] postNotificationName:GYCommonMessageBtnClickNotification object:nil];
}

- (void)homeAction
{
    if (!globalData.isLogined) {
        GYLoginView* loginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYLoginView class]) owner:self options:nil][0];
        loginView.delegate = self;
        [loginView show];
    } else {
    
        [kDefaultNotificationCenter postNotificationName:GYCommonPopRootNotification object:nil];
    }
}

- (void)lockScreen
{

    [GYLockShowTipView show];
}

- (void)loginOut
{
    [GYAlertView alertWithTitle:nil
                        Message:kLocalized(@"确定要注销吗?")
                       topColor:TopColorRed
                   comfirmBlock:^{
                   
                       [GYLoginHttpTool logoutWithSuccess:^(id responsObject) {
                           [GYUtils showToast:@"注销成功!"];
                           [[GYHDSDK sharedInstance] logout];
                         
                           self.messageUreadLabel.hidden=YES;
                           
                           [kDefaultNotificationCenter postNotificationName:GYCommonPopRootNotification object:nil];
                           [self checkLogin];
                           
                       }
                           failure:^{
                           
                               [self checkLogin];
                           }];
                           
                   }];
}

//左侧滑菜单
- (IBAction)leftMenuAction:(id)sender
{

    if (!globalData.isLogined) {
        GYLoginView* loginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYLoginView class]) owner:self options:nil][0];
        ;
        loginView.delegate = self;
        [loginView show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GYCommonHistoryBtnClickNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - DB Method-初始化浏览历史数据库
- (void)createHistoryDB
{
    [[GYDBManager sharedInstance] createHistoryTable];
}

#pragma mark - loginView Delegate
- (void)loginView:(GYLoginView*)loginView resNo:(NSString*)resNo userName:(NSString*)username password:(NSString*)password
{

    [GYLoginHttpTool loginWithResNo:resNo
        userName:username
        password:password
        success:^(id responsObject) {
        
            if (kHTTPSuccessResponse(responsObject)) {
            
                [loginView dismiss];
                
                globalData.isLogined = YES;
                
                [self createHistoryDB];
                
                [self checkLogin];
                
            }
            
            //msg:登录验证失败，您今天还剩19次尝试机会
            //       else if ([responsObject[GYNetWorkCodeKey]isEqualToNumber:@160108]) {
            //
            //            [loginView showWrongLabel];
            //        }
            
        }
        failure:^{
        
            [self checkLogin];
        }];
}


@end
