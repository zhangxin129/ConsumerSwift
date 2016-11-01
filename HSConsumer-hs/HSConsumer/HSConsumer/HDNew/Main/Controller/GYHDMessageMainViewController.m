//
//  GYHDMessageMainViewController.m
//  HSConsumer
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageMainViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDMessageModel.h"
#import "GYHDMessageCell.h"
#import "GYHDBasicViewController.h"
#import "GYHDPopView.h"
#import "GYHDPopMessageTopView.h"
#import "GYHDNavigationController.h"
#import "GYAlertView.h"
#import "GYHDUserSetingViewController.h"
#import "GYSlideMenuController.h"
#import "GYHDUserInfoViewController.h"
#import "GYHSLoginViewController.h"
#import "GYHDSeachMessageViewController.h"
#import "GYHDContactsViewController.h"
#import "GYHDSearchFriendViewController.h"
#import "GYHDMainBasicInfoView.h"
//#import "GYHDMainHeadView.h"
#import "GYHDMainMobileBasicInfoView.h"
#import "GYHDRealNameMainViewController.h"
#import "GYHDImportantChangeMainViewController.h"
#import "GYHSReportLossViewController.h"
#import "GYHSPhoneBandingVC.h"
#import "GYHSPhoneBandStateViewController.h"
#import "GYHSEmailBandingViewController.h"
#import "GYHSEmailBandStateViewController.h"
#import "GYHSUncouplingViewController.h"
#import "GYHSMakeUpCardViewController.h"
#import "GYHDMainNoLoginView.h"
#import "GYSamplePictureModel.h"
#import "GYSamplePictureManager.h"
#import "GYConsumerAnimate.h"
#import "GYHDSetingInfoViewController.h"

@interface GYHDMessageMainViewController () <UITableViewDelegate, UITableViewDataSource, GYHDMainBasicInfoViewDelegate, GYHDMainMobileBasicInfoViewDelegate>

@property (nonatomic, strong) UIButton* headView;
@property (nonatomic, strong) GYHDMainBasicInfoView* headBasicInfoView;
@property (nonatomic, strong) GYHDMainMobileBasicInfoView* headMobileInfoView;
@property (nonatomic, strong) GYHDMainNoLoginView* noLoginView;
//互生卡当前状态  1：正常 2挂失
@property (nonatomic, assign) NSInteger countNumber;

@property (nonatomic, copy) NSString* realNameSatusNumber;

@property (nonatomic, strong) NSMutableArray* MessageArrayM;
@property (nonatomic, weak) UITableView* lastMessageView;
@property (nonatomic, weak) UILabel* zeroMessageLabel;
/**连接状态Label*/
@property (nonatomic, weak) UIButton* linkTitleButton;
@property (nonatomic, weak) UIImageView* userImageView;

@property (nonatomic, strong) GYHSLoginMainVC* loginVC;
@property (nonatomic, assign) BOOL existLoginView;
@property(nonatomic ,weak)UILabel *nameBarLabel;
@property(nonatomic ,weak)UIImageView *cardBarImageView;
@property(nonatomic ,weak)UILabel *hushengBarLabel;
@property(nonatomic ,weak)UIView  *titleView;
@property(nonatomic ,weak)UIImageView *showUpImageView;
//@property (nonatomic, assign) UIButton *nameButton;
//@property (nonatomic, strong)NSArray *barBttonArray;

@end

@implementation GYHDMessageMainViewController
- (NSMutableArray*)MessageArrayM
{
    if (!_MessageArrayM) {
        _MessageArrayM = [NSMutableArray array];
    }
    return _MessageArrayM;
}

#pragma mark -生命周期
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[GYHDMessageCenter sharedInstance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        //
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self changeLinkButton];
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

    _noLoginView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHDMainNoLoginView class]) owner:self options:nil] firstObject];
    _noLoginView.frame = CGRectMake(0, 0, kScreenWidth, 37);
    [self.view addSubview:_noLoginView];
    _noLoginView.hidden = YES;

    if (!globalData.isLogined) {
        if ([self showLoginView]) {
            return;
        }
    }
    
    //获取互生卡当前的状态
    if (globalData.loginModel.cardHolder) {
        [self setHScardStatus];
    }
    [self.linkTitleButton bringSubviewToFront:self.view];
    [self messageCenterDataBaseChange];
    
    globalData.viewController.animationType = SlideAnimationTypeMove;
    globalData.viewController.needSwipeShowMenu = YES;
    globalData.viewController.needShowBoundsShadow = YES;
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    globalData.viewController.needSwipeShowMenu = NO;

}

- (void)setRealNameStatus
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : globalData.loginModel.cardHolder ? @"2" : @"1" };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kQueryAuthRealNameWithUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {

        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        _realNameSatusNumber = responseObject[@"data"];
        [self setDetailData];
        [self.view addSubview:_headBasicInfoView];

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    request.animateObj = [[GYConsumerAnimate alloc] init];
    [request start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self upArrowTouch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginShowAgain) name:kGYHDToLoginMainVCNotification object:nil];
    //接收重新登录收缩
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginShow) name:@"notHideSlideMenuNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setInfoClick:) name:@"com.SetInfoClick" object:nil];

    //1. 添加最后已条信息控制器
    UIButton* searchBtn = [[UIButton alloc] init];
    [searchBtn setImage:[UIImage imageNamed:@"gyhd_search_icon"] forState:UIControlStateNormal];
    [searchBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_search"] forState:UIControlStateNormal];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 16;
    [searchBtn setTitleColor:[UIColor colorWithRed:186 / 255.0f green:186 / 255.0f blue:186 / 255.0f alpha:1] forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _headView = searchBtn;
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(32);

    }];

    [self setupNav];
    UITableView* lastMessageView = [[UITableView alloc] init];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressGestureRecognized:)];
    [lastMessageView addGestureRecognizer:longPress];
    lastMessageView.delegate = self;
    lastMessageView.dataSource = self;
    lastMessageView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    [lastMessageView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [lastMessageView registerClass:[GYHDMessageCell class] forCellReuseIdentifier:@"GYHDMessageCellID"];
    [self.view addSubview:lastMessageView];
    _lastMessageView = lastMessageView;
    [lastMessageView mas_updateConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(44);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    UILabel* zeroMessageLabel = [[UILabel alloc] init];
    zeroMessageLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_message"];
    zeroMessageLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    zeroMessageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:zeroMessageLabel];
    _zeroMessageLabel = zeroMessageLabel;
    WS(weakSelf);
    [zeroMessageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.view);
    }];
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChange)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucessedAction) name:kGYHSLoginMainVCLoginSucessedNotification object:nil];
    [self queryImageDocListUrlString];
}
- (void)searchBtnClick
{
    GYHDSeachMessageViewController* seachMessageViewController = [[GYHDSeachMessageViewController alloc] init];
    [self.navigationController pushViewController:seachMessageViewController animated:YES];
}
- (void)setLoginShow
{
    _headView.hidden = YES;
    _headBasicInfoView.hidden = YES;
    _headMobileInfoView.hidden = YES;

    if (!globalData.isLogined) {
        [self showLoginView];
    }
}

- (void)setInfoClick:(NSNotification*)noti
{
    [globalData.viewController hideSlideMenuViewController:YES];
    GYHDUserSetingHeaderModel* model = noti.object;
    GYHDSetingInfoViewController* setingInfoViewController = [[GYHDSetingInfoViewController alloc] init];
    setingInfoViewController.model = model;
    [self.navigationController pushViewController:setingInfoViewController animated:YES];
    //    GYHDNavigationController* nav = [[GYHDNavigationController alloc] initWithRootViewController:setingInfoViewController];
    //    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setLoginShowAgain
{
    if (!globalData.isLogined) {
        //未登录回跟视图登录界面，抢登后置刷新状态为yes
        GYHDUserSetingViewController* vc = (GYHDUserSetingViewController*)globalData.viewController.leftViewController;
        vc.haveToRefresh = YES;
        [globalData.viewController hideSlideMenuViewController:YES];

        [self showLoginView];
    }
}

- (BOOL)showLoginView
{
    if (self.existLoginView) {
        return YES;
    }
    
    self.existLoginView = YES;
    self.loginVC.view.frame = self.view.bounds;
    [self.view addSubview:self.loginVC.view];
    [self addChildViewController:self.loginVC];
    
    return YES;
}

#pragma mark - 导航栏设置
- (void)setupNav
{
    //1. 设置左边

    UIImageView* userImageView = [[UIImageView alloc] init];
    userImageView.userInteractionEnabled = YES;
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.cornerRadius = 14;
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImageViewClick:)];
    [userImageView addGestureRecognizer:tapGR];
    userImageView.frame = CGRectMake(0, 0, 28, 28);
    _userImageView = userImageView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userImageView];
    //2. 设置中间
//    UIButton* searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn.frame = CGRectMake(0, 0, kScreenWidth - 150, 32);
//    [searchBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_search"] forState:UIControlStateNormal];
//    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    searchBtn.backgroundColor = [UIColor colorWithHexString:@"#f2675e"];
//    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.frame = CGRectMake(0, 0, kScreenWidth - 150, 32);
//    UIButton *nameButton = [[UIButton alloc] init];
//    nameButton.frame =  CGRectMake(0, 0, kScreenWidth , 32);
//    [nameButton addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [nameButton setImage:[UIImage imageNamed:@"gyhd_down_icon"] forState:UIControlStateNormal];
////    nameButton.imageView.frame = CGRectMake(kScreenWidth/2, 0, 20, 20);
//    [nameButton setImageEdgeInsets:UIEdgeInsetsMake(25, kScreenWidth/3, 0, 0)];
//    _nameButton = nameButton;
//    self.navigationItem.titleView = nameButton;

    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(100, 0,kScreenWidth-200, 44);
    UITapGestureRecognizer* titlViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewTap:)];
    [titleView addGestureRecognizer:titlViewTap];
    self.navigationItem.titleView = titleView;
    _titleView = titleView;

    UILabel *nameBarLabel = [[UILabel alloc] init];
    nameBarLabel.textColor = [UIColor whiteColor];
    nameBarLabel.font = [UIFont systemFontOfSize:12.0f];
    [titleView addSubview:nameBarLabel];
    _nameBarLabel = nameBarLabel;
    
    UIImageView *cardBarImageView = [[UIImageView alloc] init];
    cardBarImageView.contentMode = UIViewContentModeCenter;
    [titleView addSubview:cardBarImageView];
    _cardBarImageView = cardBarImageView;
    
    UILabel *hushengBarLabel = [[UILabel alloc] init];
    hushengBarLabel.textColor = [UIColor whiteColor];
    hushengBarLabel.font = [UIFont systemFontOfSize:12.0f];
    [titleView addSubview:hushengBarLabel];
    _hushengBarLabel = hushengBarLabel;
    
    UIImageView *showUpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_down_icon"]];
    [titleView addSubview:showUpImageView];
    _showUpImageView = showUpImageView;


    [cardBarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.centerX.equalTo(titleView).offset(-20);
    }];
    
    [showUpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView);
        make.bottom.equalTo(titleView).offset(-2);
    }];
    [nameBarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(cardBarImageView.mas_left).offset(-10);
    }];

    [hushengBarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(cardBarImageView.mas_right).offset(5);
        make.height.mas_equalTo(titleView);
//        make.right.mas_equalTo(0);
    }];
//      nameBarLabel.backgroundColor =[UIColor randomColor];
//      cardBarImageView.backgroundColor =[UIColor randomColor];
//      hushengBarLabel.backgroundColor =[UIColor randomColor];
    //3. 设置右边
    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 28, 28);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"gyhd_main_add_icon"] forState:UIControlStateNormal];

    [addBtn addTarget:self action:@selector(addContantsClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton* contactsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactsBtn.frame = CGRectMake(0, 0, 28, 28);
    [contactsBtn setBackgroundImage:[UIImage imageNamed:@"gyhd_contants_icon"] forState:UIControlStateNormal];

    [contactsBtn addTarget:self action:@selector(contactsClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    UIBarButtonItem* contactsItem = [[UIBarButtonItem alloc] initWithCustomView:contactsBtn];
    self.navigationItem.rightBarButtonItems = @[ addItem, contactsItem ];
    //   self.barBttonArray = @[ addItem, contactsItem ];

    UIButton* linkTitleButton = [[UIButton alloc] init];
    linkTitleButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    [linkTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    linkTitleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    linkTitleButton.titleLabel.numberOfLines = 0;
    [linkTitleButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_network_failed"] forState:UIControlStateNormal];
    [linkTitleButton setImage:[UIImage imageNamed:@"gyhd_network_fialed"] forState:UIControlStateNormal];
    [linkTitleButton setBackgroundColor:[UIColor colorWithRed:253 / 255.0f green:239 / 255.0f blue:219 / 255.0f alpha:1]];
    [self.view addSubview:linkTitleButton];
    _linkTitleButton = linkTitleButton;
    linkTitleButton.frame = CGRectMake(0, 0, kScreenWidth, 40);
}
- (void)titleViewTap:(NSNotification *)noti {
    self.titleView.userInteractionEnabled = NO;
    self.showUpImageView.image = nil;
    [self downArrowTouch];
}
- (void)nameBtnClick:(UIButton*)btn
{
    btn.userInteractionEnabled = btn.selected;
    btn.selected = !btn.selected;

    if (btn.selected) {

        [self downArrowTouch];
        //    }else {
        //
        //        [self upArrowTouch];
    }
}

#pragma mark--设置互生private methods
//互生卡状态
- (void)setHScardStatus
{
    GlobalData* data;
    data = globalData;

    NSDictionary* allParas = @{ @"resNo" : kSaftToNSString(data.loginModel.resNo) };
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:ksearchHsCardInfoByResNoUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        if (![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            if ([responseObject[@"data"] isEqualToNumber:@1]) {
                _countNumber = 1;
                
            } else if ([responseObject[@"data"] isEqualToNumber:@2]) {
                _countNumber = 2;
            
            } else {
                _headBasicInfoView.hsCardStatusLabel.text = kLocalized(@"GYHD_HDNew_Stop");
            }
        } else {
            _headBasicInfoView.hsCardStatusLabel.text = kLocalized(@"GYHD_HDNew_Normal");
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//获取邮箱状态
- (void)setEmailStatus
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSqueryCustomerStatusUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error == nil) {
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                NSDictionary *dit = responseObject[@"data"];
                
                if ([dit[@"authMobile"] isEqualToNumber:@1]) {
                    globalData.loginModel.isAuthMobile = @"1";
                } else {
                    globalData.loginModel.isAuthMobile = @"0";
                }
                if ([dit[@"authEmail"] isEqualToNumber:@1]) {
                    globalData.loginModel.isAuthEmail = @"1";
                } else {
                    globalData.loginModel.isAuthEmail = @"0";
                }
                NSString *email = dit[@"GYHS_Banding_Email"];
                if (![GYUtils checkStringInvalid:email]) {
                    globalData.loginModel.email = email;
                }
            }
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

- (void)setHeadView
{
    if (_headView) {
        [_headView removeFromSuperview];
        _headView = nil;
    }
    //    //设置合并的View
    //    _headView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHDMainHeadView class]) owner:self options:nil] firstObject];
    //    _headView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    //    [self setNumberData];
    //    //展开btn
    //    [_headView.upArrowTouchBtn addTarget:self action:@selector(downArrowTouch) forControlEvents:UIControlEventTouchUpInside];
    //    [_headView.upTouchBtn addTarget:self action:@selector(downArrowTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_headView];
}

- (void)setNumberData
{
    //    _headView.nickNameLabel.text = globalData.loginModel.custName;
    //    if (globalData.loginModel.cardHolder) {
    //        _headView.iconImage.image = [UIImage imageNamed:@"gy_hd_hscard"];
    //        _headView.hsNumberLabel.text = [GYUtils formatCardNo:globalData.loginModel.resNo];
    //    }
    //    else {
    //        _headView.iconImage.image = [UIImage imageNamed:@"gy_hd_mobile"];
    //        _headView.hsNumberLabel.text = globalData.loginModel.resNo;
    //    }
}

- (void)downArrowTouch
{
//    [self.nameButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.headView setHidden:YES];
    [self setEmailStatus];
    //设置展开的View
    if (globalData.loginModel.cardHolder) { //持卡人登录
        _headBasicInfoView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHDMainBasicInfoView class]) owner:self options:nil] firstObject];
        _headBasicInfoView.delegate = self;
        _headBasicInfoView.frame = CGRectMake(0, 0, kScreenWidth, 230);
        //        [self setDetailData];
        //闭合btn
        [_headBasicInfoView.upArrowTouchBtn addTarget:self action:@selector(upArrowTouch) forControlEvents:UIControlEventTouchUpInside];
        [_headBasicInfoView.upTouchBtn addTarget:self action:@selector(upArrowTouch) forControlEvents:UIControlEventTouchUpInside];
        //互生卡状态btn
        [_headBasicInfoView.hsCardStatusBtn addTarget:self action:@selector(statusTouch) forControlEvents:UIControlEventTouchUpInside];
        //互生卡用户btn
        [_headBasicInfoView.hsCardUserBtn addTarget:self action:@selector(userTouch) forControlEvents:UIControlEventTouchUpInside];
        //绑定手机号btn
        [_headBasicInfoView.hsCardMobileBindBtn addTarget:self action:@selector(mobileBindTouch) forControlEvents:UIControlEventTouchUpInside];
        //绑定邮箱btn
        [_headBasicInfoView.hsCardEmailBindBtn addTarget:self action:@selector(emailBindTouch) forControlEvents:UIControlEventTouchUpInside];
        //补卡btn
        [_headBasicInfoView.fillCardBtn addTarget:self action:@selector(fillCarTouch) forControlEvents:UIControlEventTouchUpInside];
        //重置tableview的初始高度
        [_lastMessageView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(230);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-49);
        }];
        [self setRealNameStatus];
    }
    else { //非持卡人登录
        _headMobileInfoView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHDMainMobileBasicInfoView class]) owner:self options:nil] firstObject];
        _headMobileInfoView.delegate = self;
        _headMobileInfoView.frame = CGRectMake(0, 0, kScreenWidth, 107);
        [self setMobileDetailData];
        //绑定邮箱btn
        [_headMobileInfoView.bindEmailBtn addTarget:self action:@selector(emailBindTouch) forControlEvents:UIControlEventTouchUpInside];
        //闭合btn
        [_headMobileInfoView.upArrowClickBtn addTarget:self action:@selector(upArrowTouch) forControlEvents:UIControlEventTouchUpInside];
        [_lastMessageView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(107);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-49);
        }];
        [self.view addSubview:_headMobileInfoView];
    }
}
//非持卡人详细信息
- (void)setMobileDetailData
{
    _headMobileInfoView.mobileLabel.text = globalData.loginModel.resNo;
    // 是否验证邮件1:已验证 0: 未验证 isAuthEmail;
    if ([globalData.loginModel.isAuthEmail isEqualToString:@"0"]) {

        _headMobileInfoView.emailLabel.text = kLocalized(@"GYHD_HDNew_EmailNoBinding");
        [_headMobileInfoView.bindEmailBtn setTitle:kLocalized(@"GYHD_HDNew_Binding") forState:UIControlStateNormal];
        _headMobileInfoView.bindEmailImage.hidden = YES;
    }
    else if ([globalData.loginModel.isAuthEmail isEqualToString:@"1"]) {

        _headMobileInfoView.emailLabel.text = globalData.loginModel.email;
        [_headMobileInfoView.bindEmailBtn setTitle:kLocalized(@"GYHD_HDNew_Modify") forState:UIControlStateNormal];
        _headMobileInfoView.bindEmailImage.hidden = NO;
        _headMobileInfoView.distanceLeftConstraint.constant = 40;
    }
}
//持卡人详细信息
- (void)setDetailData
{
    if (_countNumber == 1) {
        _headBasicInfoView.hsCardStatusLabel.text = kLocalized(@"GYHD_HDNew_Normal");
        _headBasicInfoView.fillCardBtn.hidden = YES;
        _headBasicInfoView.hsCardStatusBtn.titleLabel.text = kLocalized(@"GYHD_HDNew_ReportTheLoss");
    }
    else if (_countNumber == 2) {

        _headBasicInfoView.hsCardStatusLabel.text = kLocalized(@"GYHD_HDNew_ReportTheLoss");
        _headBasicInfoView.fillCardBtn.hidden = NO;
        [_headBasicInfoView.hsCardStatusBtn setTitle:kLocalized(@"GYHD_HDNew_HangingSolution") forState:UIControlStateNormal];
    }
    // 1：未实名注册 2：已实名注册（有名字和身份证）3:已实名认证 isRealnameAuth;
    if ([_realNameSatusNumber isEqualToString:@"1"]) {

        _headBasicInfoView.realNameLabel.text = kLocalized(@"GYHD_HDNew_NoRegisterRealName");
        _headBasicInfoView.hsNotRegisterLabel.hidden = YES;
        _headBasicInfoView.hasAlreadyRealNameImage.hidden = YES;
        _headBasicInfoView.hasAlreadyRegiisterNameImage.hidden = YES;
        [_headBasicInfoView.hsCardUserBtn setTitle:kLocalized(@"GYHD_HDNew_RealNameRegister") forState:UIControlStateNormal];
        _headBasicInfoView.realNameRegisteristanceLeftConnstraint.constant = 5;
    }
    else if ([_realNameSatusNumber isEqualToString:@"2"]) {

        _headBasicInfoView.realNameLabel.text = globalData.loginModel.custName;
        _headBasicInfoView.hsNotRegisterLabel.text = kLocalized(@"未认证");
        _headBasicInfoView.hsNotRegisterLabel.hidden = NO;
        _headBasicInfoView.hasAlreadyRealNameImage.hidden = NO;
        _headBasicInfoView.hasAlreadyRegiisterNameImage.hidden = YES;
        [_headBasicInfoView.hsCardUserBtn setTitle:kLocalized(@"GYHD_HDNew_HasAuthentication") forState:UIControlStateNormal];
        _headBasicInfoView.realNameRegisteristanceLeftConnstraint.constant = 80;
    }
    else if ([_realNameSatusNumber isEqualToString:@"3"]) {

        _headBasicInfoView.realNameLabel.text = globalData.loginModel.custName;
        _headBasicInfoView.hsNotRegisterLabel.hidden = YES;
        _headBasicInfoView.hasAlreadyRealNameImage.hidden = NO;
        _headBasicInfoView.hasAlreadyRegiisterNameImage.hidden = NO;
        [_headBasicInfoView.hsCardUserBtn setTitle:kLocalized(@"GYHD_HDNew_ImportMessageModify") forState:UIControlStateNormal];
        _headBasicInfoView.realNameRegisteristanceLeftConnstraint.constant = 80;
    }

    _headBasicInfoView.hsNumberLabel.text = [GYUtils formatCardNo:globalData.loginModel.resNo];
    //是否验证手机1:已验证 0: 未验证  isAuthMobile
    if ([globalData.loginModel.isAuthMobile isEqualToString:@"0"]) {

        _headBasicInfoView.mobileBindLabel.text = kLocalized(@"GYHD_HDNew_MobileNoBinding");
        [_headBasicInfoView.hsCardMobileBindBtn setTitle:kLocalized(@"GYHD_HDNew_Binding") forState:UIControlStateNormal];
        _headBasicInfoView.hasAlreadyBindMobileImage.hidden = YES;
    }
    else if ([globalData.loginModel.isAuthMobile isEqualToString:@"1"]) {

        _headBasicInfoView.mobileBindLabel.text = globalData.loginModel.mobile;
        [_headBasicInfoView.hsCardMobileBindBtn setTitle:kLocalized(@"GYHD_HDNew_Modify") forState:UIControlStateNormal];
        _headBasicInfoView.hasAlreadyBindMobileImage.hidden = NO;
        _headBasicInfoView.bindMobiledistanceLeftConstraint.constant = 40;
    }
    // 是否验证邮件1:已验证 0: 未验证 isAuthEmail;
    if ([globalData.loginModel.isAuthEmail isEqualToString:@"0"]) {

        _headBasicInfoView.emailBindLabel.text = kLocalized(@"GYHD_HDNew_EmailNoBinding");
        [_headBasicInfoView.hsCardEmailBindBtn setTitle:kLocalized(@"GYHD_HDNew_Binding") forState:UIControlStateNormal];
        _headBasicInfoView.hasAlreadyBindEmailImage.hidden = YES;
    }
    else if ([globalData.loginModel.isAuthEmail isEqualToString:@"1"]) {

        _headBasicInfoView.emailBindLabel.text = globalData.loginModel.email;
        [_headBasicInfoView.hsCardEmailBindBtn setTitle:kLocalized(@"GYHD_HDNew_Modify") forState:UIControlStateNormal];
        _headBasicInfoView.hasAlreadyBindEmailImage.hidden = NO;
        _headBasicInfoView.bindEmaildistanceLeftConstraint.constant = 40;
    }
}

//闭合view
- (void)upArrowTouch
{
//    [self.nameButton setImage:[UIImage imageNamed:@"gyhd_down_icon"] forState:UIControlStateNormal];
//    self.nameButton.userInteractionEnabled = YES;
//    self.nameButton.selected = NO;
    self.showUpImageView.image= [UIImage imageNamed:@"gyhd_down_icon"];
    self.titleView.userInteractionEnabled = YES;
    if (!globalData.loginModel.cardHolder) { //非持卡人

        [self.headMobileInfoView setHidden:YES];
        //重置tableview的初始高度
        [_lastMessageView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(44);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-49);
        }];
        [self.headView setHidden:NO];
    }
    else { //持卡人

        if (_headBasicInfoView) {
            [_headBasicInfoView removeFromSuperview];
        }
        //        [self.headBasicInfoView setHidden:YES];
        //重置tableview的初始高度
        [_lastMessageView mas_updateConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(44);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-49);
        }];
        [self.headView setHidden:NO];
    }
}
//互生卡状态
- (void)statusTouch
{
    if (_countNumber == 1) { //正常状态

        NSLog(@"点击挂失");
        if (!globalData.isLogined) {

            return;
        }

        GYHSReportLossViewController* vc = [[GYHSReportLossViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_countNumber == 2) { //挂失状态

        NSLog(@"点击解挂");
        if (!globalData.isLogined) {

            return;
        }
        GYHSUncouplingViewController* vc = [[GYHSUncouplingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//用户点击
- (void)userTouch
{
    // 1：未实名注册 2：已实名注册（有名字和身份证）3:已实名认证 isRealnameAuth;
    if ([_realNameSatusNumber isEqualToString:@"1"]) {

        NSLog(@"点击实名认证注册");
        if (!globalData.isLogined) {

            return;
        }
        GYHDRealNameMainViewController* VC = [[GYHDRealNameMainViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if ([_realNameSatusNumber isEqualToString:@"2"]) {

        NSLog(@"点击认证");
        if (!globalData.isLogined) {

            return;
        }
        GYHDRealNameMainViewController* VC = [[GYHDRealNameMainViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if ([_realNameSatusNumber isEqualToString:@"3"]) {

        NSLog(@"点击重要信息变更");
        if (!globalData.isLogined) {

            return;
        }
        GYHDImportantChangeMainViewController* VC = [[GYHDImportantChangeMainViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
//绑定手机
- (void)mobileBindTouch
{
    if ([globalData.loginModel.isAuthMobile isEqualToString:@"0"]) {

        NSLog(@"点击绑定手机");
        if (!globalData.isLogined) {

            return;
        }
        GYHSPhoneBandingVC* vc = [[GYHSPhoneBandingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([globalData.loginModel.isAuthMobile isEqualToString:@"1"]) {

        NSLog(@"点击修改手机");
        if (!globalData.isLogined) {

            return;
        }
        GYHSPhoneBandStateViewController* vc = [[GYHSPhoneBandStateViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//绑定邮箱
- (void)emailBindTouch
{
    if ([globalData.loginModel.isAuthEmail isEqualToString:@"0"]) {
        NSLog(@"点击绑定邮箱");
        if (!globalData.isLogined) {

            return;
        }
        GYHSEmailBandingViewController* vc = [[GYHSEmailBandingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([globalData.loginModel.isAuthEmail isEqualToString:@"1"]) {

        NSLog(@"点击修改邮箱");
        if (!globalData.isLogined) {

            return;
        }
        GYHSEmailBandStateViewController* vc = [[GYHSEmailBandStateViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//补卡点击
- (void)fillCarTouch
{
    NSLog(@"补卡点击");
    if (!globalData.isLogined) {

        return;
    }
    GYHSMakeUpCardViewController* vc = [[GYHSMakeUpCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)isHideNoLoginView
{
    [_headView setHidden:YES];
    [_headBasicInfoView setHidden:YES];
    [_headMobileInfoView setHidden:YES];

    CATransition* transion = [CATransition animation];
    transion.type = @"push"; //设置动画方式
    transion.subtype = @"fade"; //设置动画从那个方向开始
    [_noLoginView.layer addAnimation:transion forKey:nil];
    self.loginVC.view.frame = CGRectMake(0, 37, kScreenWidth, kScreenHeight - 37 - 49);
    _noLoginView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _noLoginView.hidden = YES;
        self.loginVC.view.frame = self.view.bounds;
    });
}

#pragma mark--  获取图片示例列表
//获取图片示例列表（正常的数据）
- (void)queryImageDocListUrlString
{
    GYSamplePictureManager* manger = [GYSamplePictureManager shareInstance];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSqueryImageDocListUrlString parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSArray *array = responseObject[@"data"];
        if ([GYUtils checkArrayInvalid:array]) {
            return ;
        }
        for (NSDictionary *dic in array) {
            GYSamplePictureModel *model = [[GYSamplePictureModel alloc] initWithDictionary:dic error:nil];
            [manger insertIntoDB:model];
        }

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark--GYHDMainBasicInfoViewDelegate
- (void)upGestureClickDelegate
{
    [self upArrowTouch];
}
#pragma mark--GYHDMainMobileBasicInfoViewDelegate
- (void)upGestureMobileClickDelegate
{
    [self upArrowTouch];
}

#pragma mark - 点击头像method
- (void)checkLogin
{
    kRootMessageCheckLogined
}
- (void)iconImageViewClick:(UITapGestureRecognizer*)tap
{
    if (!globalData.isLogined) {
        [self checkLogin];

        [self isHideNoLoginView];

        return;
    }

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

#pragma mark - 进入通讯录
- (void)contactsClick:(UIButton*)sender
{

    if (!globalData.isLogined) {

        [self isHideNoLoginView];
        return;
    }

    GYHDContactsViewController* vc = [[GYHDContactsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加好友通讯录
- (void)addContantsClick
{
    if (!globalData.isLogined) {

        [self isHideNoLoginView];
        return;
    }

#warning 暂时屏蔽 待业务确认
    //    GYHDSearchFriendViewController*vc=[[GYHDSearchFriendViewController alloc]init];
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -搜索
- (void)searchClick:(UIButton*)sender
{
#warning 暂时屏蔽 待业务确认

    //    if (!globalData.isLogined) {
    //        [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
    //        return;
    //    }
    //
    //    GYHDSeachMessageViewController* seachMessageViewController = [[GYHDSeachMessageViewController alloc] init];
    //    seachMessageViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:seachMessageViewController animated:YES];
}

#pragma mark -消息列表数据加载
- (void)messageCenterDataBaseChange
{
    //1. 查询数据库
    if (globalData.isLogined) {
        NSMutableArray* messageArray = [NSMutableArray array];
        for (NSDictionary* lastDict in [[GYHDMessageCenter sharedInstance] selectLastGroupMessage]) {
            GYHDMessageModel* lastMsgModel = [GYHDMessageModel messageModelWithDictionary:lastDict];
            [messageArray addObject:lastMsgModel];
        }
        //2. 刷表
        NSSortDescriptor* dateSort = [NSSortDescriptor sortDescriptorWithKey:@"messgeTopString" ascending:NO];
        [messageArray sortUsingDescriptors:@[ dateSort ]];
        self.MessageArrayM = messageArray;
        if (self.MessageArrayM.count > 0) {

            self.zeroMessageLabel.hidden = YES;
        }
        else {

            self.zeroMessageLabel.hidden = NO;
        }
        [self.lastMessageView reloadData];
    }

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

        NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
        if ([dict[GYHDDataBaseCenterFriendIcon] hasPrefix:@"http"]) {
            [self.userImageView setImageWithURL:[NSURL URLWithString:dict[GYHDDataBaseCenterFriendIcon]] placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
        }
        else {
            NSString* imageUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, dict[GYHDDataBaseCenterFriendIcon]];
            [self.userImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:kLoadPng(@"gyhd_defaultheadimg") options:kNilOptions completion:nil];
            ;
        }
    }
}

#pragma mark - 监听网络状态
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"state"]) {
        [self changeLinkButton];
    }
}
#pragma mark - 设置联网状态相关提示
- (void)changeLinkButton
{

    //    NSLog(@"xxx = %@",self.tabBarController.selectedViewController.);

    //    NSLog(@"xxx = %luu",self.tabBarController.selectedIndex);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (globalData.loginModel.token == nil) {
            self.titleView.hidden = YES;
            self.linkTitleButton.hidden = NO;
            return;
        }else {
            self.titleView.hidden = NO;
        }
        
        if (globalData.loginModel.custName.length > 5) {
            self.nameBarLabel.text = [NSString stringWithFormat:@"%@\n%@",[globalData.loginModel.custName substringToIndex:5],[globalData.loginModel.custName substringFromIndex:5]];
        }else {
            self.nameBarLabel.text = globalData.loginModel.custName;
        }
        if (globalData.loginModel.cardHolder) {
            self.cardBarImageView.image =[UIImage imageNamed:@"gyhd_hsCard_icon"];
            self.hushengBarLabel.text = [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:globalData.loginModel.resNo];
        }else {
            self.cardBarImageView.image =[UIImage imageNamed:@"gyhd_hsNoCard_icon"];
            self.hushengBarLabel.text = globalData.loginModel.resNo;
        }
//        self.nameBarLabel.text = @"啊啊啊啊啊啊啊啊啊啊";
//        self.cardBarImageView.image = [UIImage imageNamed:@"gyhd_hsCard_icon"];
//        self.hushengBarLabel.text = @"06 012 110 993";
//        NSMutableDictionary *nikeNameDict = [NSMutableDictionary dictionary];
//        nikeNameDict[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
//        nikeNameDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        NSString *name = [NSString stringWithFormat:@"%@  ",globalData.loginModel.custName];
//        NSMutableAttributedString *nikeNameAtt = [[NSMutableAttributedString alloc] initWithString:name attributes:nikeNameDict];
//        
//        NSTextAttachment *imagement = [[NSTextAttachment alloc] init];
//        imagement.image = [UIImage imageNamed:@"gyhd_hsCard_icon"];
//        NSAttributedString *imageAtt = [NSMutableAttributedString  attributedStringWithAttachment:imagement];
//        NSString *hushengCard = nil;
//        if (globalData.loginModel.cardHolder) {
//            hushengCard = [NSString stringWithFormat:@" %@",[[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:globalData.loginModel.resNo]];
//        }else {
//            hushengCard = [NSString stringWithFormat:@" %@",globalData.loginModel.resNo];
//        }
// 
//        
//        NSMutableDictionary *hushengDict = [NSMutableDictionary dictionary];
//        hushengDict[NSFontAttributeName] = [UIFont systemFontOfSize:12.0f];
//        hushengDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        NSAttributedString *hushengAtt = [[NSAttributedString alloc] initWithString:hushengCard attributes:hushengDict];
//        
//        NSMutableAttributedString *nameatt = [[NSMutableAttributedString alloc ] init];
//        if (globalData.loginModel.custName.length) {
//            [nameatt appendAttributedString:nikeNameAtt];
//        }
//
//        [nameatt appendAttributedString:imageAtt];
//        [nameatt appendAttributedString:hushengAtt];
//        [self.nameButton setAttributedTitle:nameatt forState:UIControlStateNormal];
        
        switch ([GYHDMessageCenter sharedInstance].state) {
            case   GYHDMessageLoginStateAuthenticateSucced://登录验证成功
            {
                self.linkTitleButton.hidden = YES;
                self.linkTitleButton.frame = CGRectMake(0,0, 0, 0);
                

                break;
            }
            case   GYHDMessageLoginStateUnknowError:
            case   GYHDMessageLoginStateConnetToServerSucced:
            case   GYHDMessageLoginStateConnetToServerTimeout:
            {
                self.linkTitleButton.hidden = NO;
                self.linkTitleButton.frame = CGRectMake(0,0, kScreenWidth, 40);
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
                self.linkTitleButton.frame = CGRectMake(0,0, kScreenWidth, 40);
                break;
            }
            case   GYHDMessageLoginStateAuthenticateFailure:
            {
                self.tabBarItem.badgeValue = nil;
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                self.linkTitleButton.hidden = NO;
                self.linkTitleButton.frame = CGRectMake(0,0, kScreenWidth, 40);
                [self.linkTitleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_Failure_Identity"] forState:UIControlStateNormal];
//                id seleVC =  self.tabBarController.selectedViewController;
//                if ([seleVC isKindOfClass:[GYHDNavigationController class]]) {
//                    [GYAlertView showMessage:[GYUtils localizedStringWithKey:@"GYHD_Main_reLogin"] cancleButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] confirmButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_Main_log_in_immediately"] cancleBlock:nil confirmBlock:^{
//                        [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:NO];
//                    }];
//                }
                
                break;
            }
            case GYHDMessageLoginStateOtherLogin:
            {
                self.tabBarItem.badgeValue = nil;
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                self.linkTitleButton.hidden = NO;
                self.linkTitleButton.frame = CGRectMake(0,0, kScreenWidth, 40);
                [self.linkTitleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_other_login"] forState:UIControlStateNormal];
//                id seleVC =  self.tabBarController.selectedViewController;
//                if ([seleVC isKindOfClass:[GYHDNavigationController class]]) {
//                    [GYAlertView showMessage:[GYUtils localizedStringWithKey:@"GYHD_Main_reLogin"] cancleButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_cancel"] confirmButtonTitle:[GYUtils localizedStringWithKey:@"GYHD_Main_log_in_immediately"] cancleBlock:nil confirmBlock:^{
//                        //                        [GYLoginManager showLoginView:0 otherLogin:YES];
//                        [[GYHSLoginManager shareInstance] showLoginView:0 otherLogin:YES];
//                    }];
//                }
                break;
            }
            default:
                break;
        }
    });
}

#pragma mark -tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MessageArrayM.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHDMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDMessageCellID"];
    cell.messageModel = self.MessageArrayM[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 68.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYHDMessageModel* lastMsgMode = self.MessageArrayM[indexPath.row];
    [[GYHDMessageCenter sharedInstance] ClearUnreadMessageWithCard:lastMsgMode.messageCard];
    GYHDBasicViewController* NextVC = [[lastMsgMode.pushNextController alloc] init];
    NextVC.messageCard = lastMsgMode.messageCard;
    NextVC.title = [NSString stringWithFormat:@"%@", lastMsgMode.userNameStr];
    NextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:NextVC animated:YES];
}

#pragma mark - 置顶和删除
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint location = [longPress locationInView:self.lastMessageView];
    NSIndexPath* indexPath = [self.lastMessageView indexPathForRowAtPoint:location];
    if (!indexPath)
        return;
    GYHDMessageModel* messageModel = self.MessageArrayM[indexPath.row];

    NSArray* messageArray = @[ [GYUtils saftToNSString:messageModel.userNameStr],
        messageModel.messageState == GYHDPopMessageStateClearTop ? [GYUtils localizedStringWithKey:@"GYHD_clear_message_top"] : [GYUtils localizedStringWithKey:@"GYHD_message_top"],
        [GYUtils localizedStringWithKey:@"GYHD_delete_message"] ];
    GYHDPopMessageTopView* messageTopView = [[GYHDPopMessageTopView alloc] initWithMessageArray:messageArray];
    [messageTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
    messageTopView.block = ^(NSString* messageString) {
        if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_message_top"]]) {
            
            if ([[GYHDMessageCenter sharedInstance] selectCountMessageTop] > 25) {
                
                [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Message_top_25_tips"] duration:1.0 position:CSToastPositionCenter];
            }else {
                [[GYHDMessageCenter sharedInstance] messageTopWithMessageCard:messageModel.messageCard];
            }
            
        }else if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_clear_message_top"]]) {
            [[GYHDMessageCenter sharedInstance] messageClearTopWithMessageCard:messageModel.messageCard];
        }else if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_delete_message"]]) {
            [[GYHDMessageCenter sharedInstance] setMessageHidenWithCustID:messageModel.messageCard];
            [[GYHDMessageCenter sharedInstance] messageClearTopWithMessageCard:messageModel.messageCard];
            
            [self messageCenterDataBaseChange];
        }
        [topView disMiss];
    };
    [topView showToView:self.navigationController.view];
}

- (void)dealloc
{
    [[GYHDMessageCenter sharedInstance] removeObserver:self forKeyPath:@"state"];
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginSucessedAction
{
    if (!self.existLoginView) {
        DDLogDebug(@"%s, the login view is not exist.", __FUNCTION__);
        return;
    }
//    [self setHeadView];
    //获取互生卡当前的状态
    if (globalData.loginModel.cardHolder) {
        [self setHScardStatus];
    }
    [self.loginVC.view removeFromSuperview];
    [self.loginVC removeFromParentViewController];
    self.loginVC = nil;
    self.existLoginView = NO;
}

- (GYHSLoginMainVC*)loginVC
{
    if (_loginVC == nil) {
        _loginVC = [[GYHSLoginMainVC alloc] init];
        _loginVC.popType = GYHSLoginVCNoShowPopView;
        _loginVC.pageType = GYHSLoginVCPageTypeHD;
        _loginVC.loginType = GYHSLoginViewControllerTypeHashsCard;
    }
    
    return _loginVC;
}

@end
