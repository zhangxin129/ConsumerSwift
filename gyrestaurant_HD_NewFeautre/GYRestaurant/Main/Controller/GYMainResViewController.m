//
//  GYMainResViewController.m
//  GYCompany
//
//  Created by apple on 15/9/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMainResViewController.h"
#import "GYSystemSettingsViewController.h"
//#import "GYMessageViewController.h"
#import "GYHDMainViewController.h"
#import "GYOrderViewController.h"
#import "GYQueryViewController.h"
#import "GYTakeOrderViewController.h"
#import "GYNotificationHub.h"
#import "FlatButton.h"
#import "GYGIFHUD.h"
#import "GYLoginEn.h"
#import "GYLoginViewController.h"
#import "GYNavigationController.h"
#import "GYSystemSettingViewModel.h"
#import "GYSelectedButton.h"
#import "GYHDMessageCenter.h"
#import "GYXMPP.h"
#import "GYLoginViewModel.h"
#import "GYHDNetWorkTool.h"

@interface GYMainResViewController ()<GYNotificationHubDelegate>
{
    GYNotificationHub * hubMsg; //显示新的消息个数
    GYNotificationHub * hubOrder; //显示新的订单个数
}
@property (nonatomic, weak) UIButton *btnSetting;
@property (nonatomic, weak) UIButton *btnQuit;
@property (nonatomic, weak) UIButton *btnQuery;
@property (nonatomic, weak) UIButton *btnOrder;
@property (nonatomic, weak) UIButton *btnTakeOrder;
@property (nonatomic, weak) UIButton *btnMessage;
@property (nonatomic, assign) NSInteger msgCount;
@property (nonatomic,strong) NSTimer *getOffTimer;
@property (nonatomic,strong) UIImageView *MallManagementImageView;
@property (nonatomic, strong) UILabel *MallManagementLable;

@end

@implementation GYMainResViewController
-(instancetype)init{

    if (self=[super init]) {
        
        [kDefaultNotificationCenter addObserver:self selector:@selector(postGetOffLinePushMessageTimer) name:@"startGetOfflineMsg" object:nil];
        [kDefaultNotificationCenter addObserver:self selector:@selector(stopGetOfflineMsg) name:@"stopGetOfflineMsg" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationSetting];
    [self viewSetting];
    
    [self postGetOffLinePushMessageTimer];
}

#pragma mark- 拉取离线消息
-(void)postGetOffLinePushMessageTimer{
   
    if (self.getOffTimer) {
        [self.getOffTimer invalidate];
        self.getOffTimer=nil;
    }
    self.getOffTimer= [NSTimer scheduledTimerWithTimeInterval:35.0 target:self selector:@selector(loadGetOffMessage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.getOffTimer forMode:NSRunLoopCommonModes];
}

-(void)loadGetOffMessage{
    
    [[GYHDNetWorkTool sharedInstance] postGetOffLinePushMessage];
}

-(void)stopGetOfflineMsg{
    
    [self.getOffTimer invalidate];
    self.getOffTimer =nil;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    // 刷新 数据库 取所有消息个数
    hubMsg.count = [[GYHDMessageCenter sharedInstance]UnreadAllMessageCountWithCard:globalData.loginModel.custId];
   
    //    接收推送消息通知 显示消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCenterDataBaseChange) name:@"pushMessage" object:nil];
    //  接收聊天消息通知，显示消息数量
    
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChange)];
    
    
    
    globalData.pop = NO;

}
-(void)messageCenterDataBaseChange{

    // 刷新 数据库 取所有消息个数
    hubMsg.count = [[GYHDMessageCenter sharedInstance]UnreadAllMessageCountWithCard:globalData.loginModel.custId];
    //            推送到app图片角标
    
    if (hubMsg.count>=99) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber=99;
    }else{
    
        [UIApplication sharedApplication].applicationIconBadgeNumber=hubMsg.count;
    }
    
}
/**导航栏*/
- (void)navigationSetting{
    
    //左
   UIButton *gybtn = [UIButton buttonWithType:UIButtonTypeCustom];
       gybtn.size = CGSizeMake(100, 44);
    [gybtn setTitle:kLocalized(@"LogOut") forState:UIControlStateNormal];
    [gybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gybtn addTarget:self action:@selector(leftQuit)forControlEvents:UIControlEventTouchUpInside];
    gybtn.titleLabel.font = [UIFont systemFontOfSize:kBackFont];
    UIBarButtonItem *bbiTitle = [[UIBarButtonItem alloc] initWithCustomView:gybtn];
    self.navigationItem.leftBarButtonItem = bbiTitle;
    self.btnQuit = gybtn;
    
    //中
    UIView *titleView = [[UIView alloc] init];
    titleView.size = CGSizeMake(300, 44);
    UILabel *lbTitle = [[UILabel alloc] init];
    lbTitle.font = [UIFont boldSystemFontOfSize:30];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    NSString *companyN = kLocalized(@"HSEnterpriseIndependentPlatform");

    lbTitle.text = companyN;
    [titleView addSubview:lbTitle];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.height.equalTo(@44);
        make.centerX.equalTo(titleView.mas_centerX);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    UIImageView *ivImgview =[[UIImageView alloc] init];
    ivImgview.image  = [UIImage imageNamed:@"logo"];
    [titleView addSubview:ivImgview];
    [ivImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@28);
        make.height.equalTo(@30);
        make.top.equalTo(titleView.mas_top).offset(7);
        make.right.equalTo(lbTitle.mas_left).offset(0);
    }];
    self.navigationItem.titleView = titleView;
    
    //右
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.size = CGSizeMake(60, 44);
    [btnSetting setTitle:kLocalized(@"SetUp") forState:UIControlStateNormal];
    [btnSetting setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    btnSetting.imageEdgeInsets = UIEdgeInsetsMake(9, 0, 9, 35);
    [btnSetting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(btnSettingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbiBtn3 = [[UIBarButtonItem alloc] initWithCustomView:btnSetting];
    self.btnSetting = btnSetting;
    //权限控制
    //送餐员权限控制
    if (globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
        self.btnSetting.hidden = YES;
        self.btnMessage.hidden = YES;
    }else{
        self.btnSetting.hidden = NO;
        self.btnMessage.hidden = NO;
    }
   
    
    UIView *lineView = [[UIView alloc] init];
    lineView.size = CGSizeMake(1, 21);
    lineView.contentMode = UIViewContentModeRedraw;
    lineView.backgroundColor = [UIColor whiteColor];
     UIBarButtonItem *bbiBtn2 = [[UIBarButtonItem alloc] initWithCustomView:lineView];
    
    UIButton *btnLock = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLock.size = CGSizeMake(60, 44);
    [btnLock setTitle:kLocalized(@"Lock") forState:UIControlStateNormal];
    [btnLock setTitle:kLocalized(@"Unlock") forState:UIControlStateSelected];
    [btnLock setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    [btnLock setImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateSelected];
    btnLock.imageEdgeInsets = UIEdgeInsetsMake(9, 0, 9, 35);
    [btnLock setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLock addTarget:self action:@selector(btnLock:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbiBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btnLock];
    
    self.navigationItem.rightBarButtonItems = @[bbiBtn3,bbiBtn2,bbiBtn1];
}



/**视图*/
- (void)viewSetting{
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    iconImage.image = [UIImage imageNamed:@"background"];
    iconImage.userInteractionEnabled = YES;
    [self.view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.edges.equalTo(self.view);
        
    }];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.height.equalTo(@300);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    NSArray *arrImg = @[@"message" ,@"order" ,@"query" ,@"takeorder"];
    NSArray *arrClickImg = @[@"clickmessage", @"clickorder", @"clickquery", @"clicktakeorder"];
    for (int i = 0; i < arrImg.count; i++) {
        FlatButton *btn =[FlatButton button];
        btn.backgroundColor = kRedFontColor;
        if (i < 2) {
            btn.frame = CGRectMake(180 *i, 0, 120, 120);
        }else{
            btn.frame = CGRectMake(180 * (i-2), 180, 120, 120);
        }
        btn.tag = 100 +i;
        [btn setBackgroundImage:[UIImage imageNamed:arrImg[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:arrClickImg[i]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnMuneActon:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        
        if (i == 0) {
            hubMsg = [[GYNotificationHub alloc]initWithView:btn];
            [hubMsg moveCircleByX:-5 Y:5];
            
//            数据库 取所有消息个数 //
            hubMsg.count = [[GYHDMessageCenter sharedInstance]UnreadAllMessageCountWithCard:globalData.loginModel.custId];
            
             [hubMsg showCount];
            hubMsg.delegate=self;
            
             self.btnMessage = btn;
            
//            推送到app图片角标
            if (hubMsg.count>=99) {
                
                [UIApplication sharedApplication].applicationIconBadgeNumber=99;
            }else{
                
                [UIApplication sharedApplication].applicationIconBadgeNumber=hubMsg.count;
            }
            
        }
        
        if (i == 1) {
            hubOrder = [[GYNotificationHub alloc]initWithView:btn];
            [hubOrder moveCircleByX:-5 Y:5];
            [hubOrder pop];
            self.btnOrder = btn;
        }
        
        if (i == 2) {
            self.btnQuery = btn;
        }
        
        if (i == 3) {
            self.btnTakeOrder = btn;
        }
    }
//送餐员权限控制
    if (globalData.currentRole == roleTypeTrusteeshipCompanyDeliveryStaff || globalData.currentRole == roleTypeMemberCompanyDeliveryStaff) {
        self.btnTakeOrder.hidden = YES;
        self.btnQuery.hidden = YES;
      //  self.btnMessage.hidden = YES;
    }
   //服务员权限控制
    if (globalData.currentRole == roleTypeTrusteeshipCompanyWaiter || globalData.currentRole == roleTypeMemberCompanyWaiter ) {
        self.btnQuery.hidden = YES;
        self.btnMessage.hidden = YES;
    }
    
    //收银员权限控制
    if (globalData.currentRole == roleTypeTrusteeshipCompanyCashier || globalData.currentRole == roleTypeMemberCompanyCashier ) {
        self.btnQuery.hidden = YES;
        self.btnTakeOrder.frame = self.btnQuery.frame;
        
    }
    
    //管理员权限控制
    if (globalData.currentRole == roleTypeTrusteeshipCompanyStoreManger|| globalData.currentRole == roleTypeMemberCompanyStoreManger || globalData.currentRole == roleTypeTrusteeshipCompanySystemAdministrator || globalData.currentRole == roleTypeMemberCompanySystemAdministrator) {
        self.btnQuery.hidden = NO;
        self.btnMessage.hidden = NO;
        self.btnTakeOrder.hidden = NO;
        self.btnOrder.hidden = NO;
        
        
    }
    
    //增加未开通商城提示视图
    UIView *MallManagementView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 66, kScreenWidth, 66)];
    [MallManagementView setBackgroundColor:[UIColor whiteColor]];
    MallManagementView.alpha = 0.7f;
    [self.view addSubview:MallManagementView];
    
    self.MallManagementImageView = [[UIImageView alloc] init];
    [self.MallManagementImageView setImage:[UIImage imageNamed:@"MallManagement"]];
    [MallManagementView addSubview:self.MallManagementImageView];
    self.MallManagementImageView.frame = CGRectMake((kScreenWidth - 340)/2, 10, 50, 46);
    
    self.MallManagementLable = [[UILabel alloc] init];
    self.MallManagementLable.text = kLocalized(@"StoreDidNotOpen,PleaseOpen.");
    self.MallManagementLable.textColor = [UIColor colorWithRed:21/255.0 green:143/255.0 blue:228/255.0 alpha:1.0f];
    self.MallManagementLable.font = [UIFont systemFontOfSize:20];
    self.MallManagementLable.textAlignment = NSTextAlignmentLeft;
    [MallManagementView addSubview:self.MallManagementLable];
    self.MallManagementLable.frame = CGRectMake((kScreenWidth - 340)/2 + 10 + 46, 25 , 280, 20);
    MallManagementView.hidden = YES;
    if ([kGetNSUser(@"vshopStatus") isEqualToString:@"0"]) {
        MallManagementView.hidden = NO;
    }else if ([kGetNSUser(@"vshopStatus") isEqualToString:@"1"]){
        MallManagementView.hidden = YES;
    }
    
}
#pragma mark - GYNotificationHubDelegate

-(void)clearAllMessage{
    
    [[GYHDMessageCenter sharedInstance] ClearUnreadMessage];
    [[GYHDMessageCenter sharedInstance] ClearUnreadPushMessageWithCard:globalData.loginModel.custId];
    hubMsg.count=0;
    //            推送到app图片角标 暂时屏蔽
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushMessage" object:nil];
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
    [kDefaultNotificationCenter removeObserver:self name:@"startGetOfflineMsg" object:nil];
    [kDefaultNotificationCenter removeObserver:self name:@"stopGetOfflineMsg" object:nil];
}


#pragma mark - btnAction
/***点击设置按钮事件**/
- (void)btnSettingAction{
    GYSystemSettingsViewController *vcSystem =[[GYSystemSettingsViewController alloc] init];
    [self.navigationController pushViewController:vcSystem animated:NO];
    
}


- (void)btnLock:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        [UIApplication sharedApplication].idleTimerDisabled=YES;
        self.view.userInteractionEnabled = NO;
        self.btnQuit.enabled = NO;
        self.btnSetting.enabled = NO;
    }else{
    [UIApplication sharedApplication].idleTimerDisabled=NO;
        self.view.userInteractionEnabled = YES;
        self.btnSetting.enabled = YES;
        self.btnQuit.enabled = YES;
    }
    
}
- (void)btnMuneActon:(UIButton*)btn{
    NSString*shopId=kGetNSUser(@"shopId");
    
    if (btn.tag == 100) {
        
        if (shopId==nil) {
            
            [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
        }
        GYHDMainViewController *vcMessage = [[GYHDMainViewController alloc] init];
        [self.navigationController pushViewController:vcMessage animated:NO];
    }
    
    if (btn.tag == 101) {
        GYOrderViewController *vcOrder = [[GYOrderViewController alloc] init];
        [self.navigationController pushViewController:vcOrder animated:NO];
    }
    
    if (btn.tag == 102) {
        GYQueryViewController *vcQuery = [[GYQueryViewController alloc] init];
        [self.navigationController pushViewController:vcQuery animated:NO];
    }
    if (btn.tag == 103) {
        GYTakeOrderViewController *vcTakeOder = [[GYTakeOrderViewController alloc] init];
        [self.navigationController pushViewController:vcTakeOder animated:NO];
    }
}

/**退出登录*/
- (void)leftQuit{

    [GYGIFHUD show];
    NSDictionary *dic = @{
                          @"channelType":GYChannelType,
                          @"custId":globalData.loginModel.custId,
                          @"token":globalData.loginModel.token,
                         };
    [Network POST:GY_FOODLOGINAPPENDING(GYHEFoodOperatorLogout) parameter:dic success:^(id returnValue) {
        [self clearCach];

    } failure:^(id error) {
       [self clearCach];
    }];
    
   }

-(void)clearCach{
    [GYGIFHUD dismiss];
    GYLoginViewController *loginView = [[GYLoginViewController alloc] init];
    GYNavigationController *ncLogin = [[GYNavigationController alloc] initWithRootViewController:loginView];
    [UIApplication sharedApplication].delegate.window.rootViewController = ncLogin;
    
    NSString *shopId = kGetNSUser(@"shopId");
    NSString *shopName = kGetNSUser(@"shopName");
    if (shopId.length > 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shopId"];
    }
    if(shopName.length > 0){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"shopName"];
    }
    //清空菜品及分类
    GYSystemSettingViewModel *viewModel = [[GYSystemSettingViewModel alloc]init];
    [viewModel  writeModel:[NSDictionary dictionary] toPath:@"getFoodCategoryList"];
    [viewModel  writeModel:[NSDictionary dictionary]  toPath:@"foodsList"];
    //    退出xmpp登录
    [[GYXMPP sharedInstance] Logout];
    
    [self stopGetOfflineMsg];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}


@end
