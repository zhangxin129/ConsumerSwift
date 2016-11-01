
//
//  GYHSAccountViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  我的互生 首页

#define kKeyAccName @"accName"
#define kKeyAccBal @"accBal"
#define kKeyAccIcon @"accIcon"
#define kKeyNextVcName @"accNextVc"

#import "GYHSAccountViewController.h"
#import "CellTypeImagelabel.h"
#import "CellUserInfo.h"
#import "GYBusinessProcessVC.h"
#import "GYCashAccountViewController.h"
#import "GYEPMyCouponsMainViewController.h"
#import "GYEasyBuyModel.h"
#import "GYHSBasicInfomationController.h"
#import "GYHSBasicInformationModel.h"
#import "GYHSBindCardInfoVC.h"
#import "GYHSCardInfoVC.h"
#import "GYHSGeneralController.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginViewController.h"
#import "GYHSNewBaseQueryController.h"
#import "GYInvestAccoutViewController.h"
#import "GYMyInfoNoCardViewController.h"
#import "GYMyInfoViewController.h"
#import "GYHSOrderPayConfirmVC.h"
#import "GYPointAccoutViewController.h"
#import "GYQRCodeReaderViewController.h"
#import "GYQRPayModel.h"


#import "GYShopDescribeController.h"
#import "GYViewControllerDelegate.h"
#import "IQKeyboardManager.h"
#import "MJExtension.h"
#import "MenuTabView.h"
#import "UIButton+YYWebImage.h"
#import "YYKit.h"
#import "GYHDRealNameRegisterViewController.h"
#define kCellMyAccountCellIdentifier @"kCellMyAccountCellIdentifie"

@interface GYHSAccountViewController () <UITableViewDataSource, UITableViewDelegate, GYViewControllerDelegate, MenuTabViewDelegate, GYQRCodeReaderDelegate> {
    CellUserInfo *cellUserInfo; //个人信息cell
    GYMyInfoViewController *vcMyProfile; //我的个人资料VC
    GYMyInfoNoCardViewController *vcMyProfileNoCard;
    GYBusinessProcessVC *vcBusiness; //业务办理vc
    GYHSNewBaseQueryController *vcNewBusiness;
    MenuTabView *menu; //菜单视图
    NSArray *menuTitles; //菜单标题数组
    UIScrollView *_scrollV; //滚动视图，用于装载各vc view
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrResult;
@property (nonatomic, strong) NSArray *NoHSCardAry;
@property (nonatomic, strong) NSArray *hasHSCardAry;

@property (nonatomic, strong) GYHSBasicInformationModel *BasicInformationModel;

@end

@implementation GYHSAccountViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    //对必要视图数据进行初始化
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 30, 30);
    btnBack.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setImage:[UIImage imageNamed:@"hs_nav_btn_scan"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];

    self.navigationItem.title = kLocalized(@"GYHS_Main_My_Account");

    self.hasHSCardAry = @[ @{ kKeyAccIcon : @"hs_cell_img_points_account",
                              kKeyAccName : kLocalized(@"GYHS_Main_Points_Account"),
                              kKeyAccBal : [NSNumber numberWithDouble:globalData.user.pointAccBal],
                              kKeyNextVcName : NSStringFromClass([GYPointAccoutViewController class]) },
                           @{  },
                           @{ kKeyAccIcon : @"hs_cell_img_cash_account",
                              kKeyAccName : kLocalized(@"GYHS_Main_Cash_Account"),
                              kKeyAccBal : [NSNumber numberWithDouble:globalData.user.cashAccBal],
                              kKeyNextVcName : NSStringFromClass([GYCashAccountViewController class]) },
                           @{ kKeyAccIcon : @"hs_img_investment_account_big",
                              kKeyAccName : kLocalized(@"GYHS_Main_Investment_Account"),
                              kKeyAccBal : [NSNumber numberWithDouble:globalData.user.investAccTotal],
                              kKeyNextVcName : NSStringFromClass([GYInvestAccoutViewController class]) },
                           @{ kKeyAccIcon : @"hs_counpon",
                              kKeyAccName : kLocalized(@"GYHS_Main_Ar_Send_Ticket"),
                              kKeyAccBal : [NSNumber numberWithDouble:globalData.user.investAccTotal],
                              kKeyNextVcName : NSStringFromClass([GYEPMyCouponsMainViewController class]) } ];

    self.NoHSCardAry = @[ @{  },
                          @{ kKeyAccIcon : @"hs_cell_img_cash_account",
                             kKeyAccName : kLocalized(@"GYHS_Main_Cash_Account"),
                             kKeyAccBal : [NSNumber numberWithDouble:globalData.user.cashAccBal],
                             kKeyNextVcName : NSStringFromClass([GYCashAccountViewController class]) } ];

    menuTitles = @[ kLocalized(@"GYHS_Main_My_Account"),
                    kLocalized(@"GYHS_Main_Operation"),
                    kLocalized(@"GYHS_Main_My_Profile") ];

    self.arrResult = [NSMutableArray array];
    //第一行个人信息预留
    [self.arrResult addObject:@[ @"" ]];
    [self.arrResult addObject:self.NoHSCardAry];

    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 45) isShowSeparator:YES];
    menu.delegate = self;
    [self.view addSubview:menu];

    //加载滚动视图
    CGRect scrollVFrame = self.view.bounds;
    scrollVFrame.origin.y = CGRectGetMaxY(menu.frame);
    scrollVFrame.size.height = kScreenHeight - 49 - 45 - 64;

    _scrollV = [[UIScrollView alloc] initWithFrame:scrollVFrame];
    _scrollV.backgroundColor = kDefaultVCBackgroundColor;
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
    [_scrollV setContentSize:CGSizeMake(kScreenWidth * menuTitles.count, scrollVFrame.size.height)];
    [self.view addSubview:_scrollV];
    //初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64 - 45)
                                                  style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [_scrollV addSubview:self.tableView];

    //添加 账户操作，业务办理，我的资料
    // 持卡人业务办理页面
    vcBusiness = [[GYBusinessProcessVC alloc] init];
    vcBusiness.delegate = self;
    vcBusiness.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 49 - CGRectGetMaxY(menu.frame) - 64);
    [_scrollV addSubview:vcBusiness.view];
    vcBusiness.view.tag = 1;
    [self addChildViewController:vcBusiness];

    // 非支持卡人，业务办理
    vcNewBusiness = [[GYHSNewBaseQueryController alloc] init];
    vcNewBusiness.view.frame = CGRectMake(kScreenWidth, 16, kScreenWidth, kScreenHeight - 49 - CGRectGetMaxY(menu.frame) - 64 - 16);
    [_scrollV addSubview:vcNewBusiness.view];
    vcNewBusiness.view.tag = 1;
    [self addChildViewController:vcNewBusiness];

    // 非支持卡人, 个人资料
    vcMyProfileNoCard = [[GYMyInfoNoCardViewController alloc] init];
    vcMyProfileNoCard.delegate = self;
    vcMyProfileNoCard.view.frame = CGRectMake(2 * kScreenWidth, 0, kScreenWidth, kScreenHeight - 49 - CGRectGetMaxY(menu.frame) - 64);
    [_scrollV addSubview:vcMyProfileNoCard.view];
    [self addChildViewController:vcMyProfileNoCard];
    vcMyProfileNoCard.view.hidden = YES;

    // 持卡人个人资料
    vcMyProfile = [[GYMyInfoViewController alloc] init];
    vcMyProfile.delegate = self;
    vcMyProfile.view.frame = CGRectMake(2 * kScreenWidth, 0, kScreenWidth, kScreenHeight - 49 - CGRectGetMaxY(menu.frame) - 64);
    [_scrollV addSubview:vcMyProfile.view];
    [self addChildViewController:vcMyProfile];

    //注册自定义cell，并绑定方法
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellTypeImagelabel class]) bundle:kDefaultBundle] forCellReuseIdentifier:kCellMyAccountCellIdentifier];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setImage:kLoadPng(@"hs_btn_set") forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(openGeneral:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)leftBarButtonClick {
    if (![self cameraAvailable]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Main_The_Device_Not_Support_The_Camera")];
        return;
    }

    GYQRCodeReaderViewController *reader = [[GYQRCodeReaderViewController alloc] init];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    reader.title = kLocalized(@"GYHS_Main_QRScran");
    reader.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:reader animated:YES];
}

- (BOOL)cameraAvailable {

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }

    return YES;
}

- (void)requestData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"userId"];

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSGetInfo parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        self.BasicInformationModel = [[GYHSBasicInformationModel modelArrayWithResponseObject:responseObject error:nil] firstObject];
        vcMyProfileNoCard.infoModel = self.BasicInformationModel;
        [vcMyProfileNoCard.tableView reloadData];
        [self.tableView reloadData];


    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!globalData.loginModel.cardHolder) {
        [self requestData];
    }

    self.tableView.userInteractionEnabled = YES;
    self.tabBarController.tabBar.hidden = NO;

    //刷新数据
    [self.tableView reloadData];
    [self.arrResult removeAllObjects];

    if (globalData.isLogined && globalData.loginModel.cardHolder) {
        //第一行个人信息预留
        [self.arrResult addObject:@[ @"" ]];
        [self.arrResult addObject:self.hasHSCardAry];
    } else {
        //第一行个人信息预留
        [self.arrResult addObject:@[ @"" ]];
        [self.arrResult addObject:self.NoHSCardAry];
    }

    [self.tableView reloadData];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 打开系统通用页面
- (void)openGeneral:(id)sender {
    GYHSGeneralController *general = [[GYHSGeneralController alloc] init];
    general.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:general animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrResult.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrResult[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *labelStr = nil;
    double bal = 0;
    UIImage *img = nil;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if (section == 0) {
        cellUserInfo = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CellUserInfo class]) owner:self options:nil] lastObject];
        [cellUserInfo setSelectionStyle:UITableViewCellSelectionStyleNone];

        // 先判断是否是持卡人 非持卡人； 先显示所有的内容
        cellUserInfo.btnRealName.hidden = YES;
        cellUserInfo.btnPhoneYes.hidden = YES;
        cellUserInfo.btnEmailYes.hidden = YES;
        cellUserInfo.btnBankYes.hidden = YES;
        cellUserInfo.vTipToInputInfo.hidden = NO;

        //获取当前时间 在持卡人的时候出现的问候语
        NSString *applyDate = [GYUtils dateToString:[NSDate date]];
        NSString *hour = [applyDate substringWithRange:NSMakeRange(10, 3)];
        NSString *strHH = kLocalized(@"GYHS_Main_GoodMorning");
        if ([hour integerValue] >= 12) {
            strHH = kLocalized(@"GYHS_Main_GoodAfternoon");
        }

        // 上一次登录时间
        cellUserInfo.lbLastLoginInfo.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHS_Main_Lastlogin_Time"), globalData.loginModel.lastLoginDate ? globalData.loginModel.lastLoginDate : @""];
        [GYUtils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLabelHello labelLines:1];
        [GYUtils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLastLoginInfo labelLines:1];
        [GYUtils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLabelCardNo labelLines:1];

        [cellUserInfo.btnRealName setBackgroundImage:kLoadPng(![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes] ? @"hs_icon_real_name_yes" : @"hs_icon_real_name_no")
                                            forState:UIControlStateNormal];
        [cellUserInfo.btnPhoneYes setBackgroundImage:kLoadPng(globalData.loginModel.isAuthMobile.boolValue ? @"hs_icon_phone_yes" : @"hs_icon_phone_no")
                                            forState:UIControlStateNormal];
        [cellUserInfo.btnEmailYes setBackgroundImage:kLoadPng(globalData.loginModel.isAuthEmail.boolValue ? @"hs_icon_email_yes" : @"hs_icon_email_no")
                                            forState:UIControlStateNormal];

        [cellUserInfo.btnBankYes setBackgroundImage:kLoadPng(globalData.loginModel.isBindBank.boolValue ? @"hs_icon_bank_yes" : @"hs_icon_bank_no")
                                           forState:UIControlStateNormal];

        if (globalData.loginModel.cardHolder) { ////持卡人
            // 判断是否 实名注册
            NSString *cardNumber = kSaftToNSString(globalData.loginModel.resNo);
            if (globalData.loginModel.resNo.length == 11) {
                NSString *str1 = [globalData.loginModel.resNo substringToIndex:2];
                NSRange range = NSMakeRange(2, 3);
                NSString *str2 = [globalData.loginModel.resNo substringWithRange:range];
                range = NSMakeRange(5, 2);
                NSString *str3 = [globalData.loginModel.resNo substringWithRange:range];
                NSString *str4 = [globalData.loginModel.resNo substringFromIndex:7];
                cardNumber = [NSString stringWithFormat:@"%@  %@  %@  %@", str1, str2, str3, str4];
            }
            cellUserInfo.lbLabelCardNo.text = [NSString stringWithFormat:@"%@  %@",
                                               kLocalized(@"GYHD_user_addfriend_hushengNumber"), cardNumber];
            //加载头像
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, globalData.loginModel.headPic];
            [cellUserInfo.btnUserPicture setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholder:kLoadPng(@"hs_cell_img_noneuserimg") options:kNilOptions completion:nil];
            if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) { ///未实名注册
                cellUserInfo.vTipToInputInfo.numberOfLines = 0;
                cellUserInfo.vTipToInputInfo.attributedText = [self createTipMsg];

                cellUserInfo.lbLabelHello.text = strHH;
            } else { ////实名注册
                cellUserInfo.btnRealName.hidden = NO;
                cellUserInfo.btnPhoneYes.hidden = NO;
                cellUserInfo.btnEmailYes.hidden = NO;
                cellUserInfo.btnBankYes.hidden = NO;
                cellUserInfo.lbLastLoginInfo.hidden = NO;
                cellUserInfo.vTipToInputInfo.hidden = YES;
                cellUserInfo.lbLabelHello.text = [NSString stringWithFormat:@"%@，%@", globalData.loginModel.custName, strHH];
            }
        } else { ///非持卡人
            NSString *iphone = globalData.loginModel.userName;
            NSString *newIphone = @"";

            if (iphone.length == 11) {
                NSString *str1 = [iphone substringWithRange:NSMakeRange(0, 3)];
                NSString *str2 = [iphone substringWithRange:NSMakeRange(7, 4)];
                newIphone = [NSString stringWithFormat:@"%@****%@", str1, str2];
            }
            cellUserInfo.lbLabelCardNo.text = [NSString stringWithFormat:@"%@  %@",
                                               kLocalized(@"GYHS_Main_PhoneNo"), newIphone];

            NSString *imgUrl = [NSString stringWithFormat:@"%@/%@", globalData.loginModel.picUrl, self.BasicInformationModel.headShot];
            [cellUserInfo.btnUserPicture setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholder:kLoadPng(@"hs_cell_img_noneuserimg") options:kNilOptions completion:nil];
            if ([GYUtils isBlankString:self.BasicInformationModel.name]) { ////没有实名注册

                cellUserInfo.vTipToInputInfo.numberOfLines = 0;
                cellUserInfo.vTipToInputInfo.attributedText = [self createTipMsg];
            } else {
                // 实名注册了
                cellUserInfo.btnPhoneYes.hidden = NO;
                cellUserInfo.btnEmailYes.hidden = NO;
                cellUserInfo.btnBankYes.hidden = NO;
                cellUserInfo.lbLastLoginInfo.hidden = NO;
                cellUserInfo.vTipToInputInfo.hidden = YES;
                cellUserInfo.lbLabelHello.hidden = YES;
                cellUserInfo.timeTopConstraint.constant = 30;
                cellUserInfo.phoneleftConstraint.constant = 14;
                [cellUserInfo.btnPhoneYes setBackgroundImage:kLoadPng(@"hs_icon_phone_yes")
                                                    forState:UIControlStateNormal];
            }
        }
        cell = cellUserInfo;
    } else {
        CellTypeImagelabel *cl = [tableView dequeueReusableCellWithIdentifier:kCellMyAccountCellIdentifier];
        if (!cl) {
            cl = [[CellTypeImagelabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellMyAccountCellIdentifier];
        }
        NSArray *arrAcc = self.arrResult[section];

        labelStr = [arrAcc[row] valueForKey:kKeyAccName];
        img = kLoadPng([arrAcc[row] valueForKey:kKeyAccIcon]);
        bal = [[arrAcc[row] valueForKey:kKeyAccBal] doubleValue];

        cl.lbCellLabel.text = labelStr;
        cl.ivCellImage.image = img;
        cell = cl;
    }

    return cell;
}

- (NSMutableAttributedString *)createTipMsg {

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYHS_Main_Your_Information_Not_Complete_Affect_Some_Business_Use")];
    one.color = kCorlorFromRGBA(0, 160, 223, 1);
    one.font = [UIFont systemFontOfSize:13];
    [text appendAttributedString:one];

    NSMutableAttributedString *two = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYHS_Main_Improve_Immediately")];
    two.font = [UIFont systemFontOfSize:12];
    two.underlineStyle = NSUnderlineStyleSingle;
    [two setTextHighlightRange:two.rangeOfAll
                         color:kNavigationBarColor
               backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [self click];
    }];

    [text appendAttributedString:two];

    NSMutableAttributedString *three = [[NSMutableAttributedString alloc] initWithString:@"!"];
    three.color = kCorlorFromRGBA(0, 160, 223, 1);
    three.font = [UIFont systemFontOfSize:13];
    [text appendAttributedString:three];

    return text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (!globalData.loginModel.cardHolder) {
            return 140.0f;
        } else {
            return 140.0f;
        }
    } else {
        return 75.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0f;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {

        return;
    }

    NSArray *arrAcc = self.arrResult[indexPath.section];
    NSString *nextVCName = arrAcc[indexPath.row][kKeyNextVcName];
    NSString *nextVCTitle = arrAcc[indexPath.row][kKeyAccName];
    UIViewController *vc = kLoadVcFromClassStringName(nextVCName);
    vc.navigationItem.title = nextVCTitle;
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVC:vc animated:YES];
        self.tableView.userInteractionEnabled = NO;
        @try {
        }@catch (NSException *exception) {
            DDLogDebug(@"exception:%@", exception);
        } @finally {
        }
    }
}

#pragma mark - GYViewControllerDelegate
- (void)pushVC:(id)vc animated:(BOOL)ani {
    [self.navigationController pushViewController:vc animated:ani];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index {

    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index)
        return;
    if (!globalData.loginModel.cardHolder) {
        NSNotification *notifiaction = [NSNotification notificationWithName:@"updateBaseQueryController" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notifiaction];
        vcNewBusiness.view.hidden = NO;
        vcBusiness.view.hidden = YES;
        vcMyProfileNoCard.view.hidden = NO;
        vcMyProfile.view.hidden = YES;
    } else {
        vcNewBusiness.view.hidden = YES;
        vcBusiness.view.hidden = NO;
        vcMyProfileNoCard.view.hidden = YES;
        vcMyProfile.view.hidden = NO;
    }
    CGFloat _x = _scrollV.frame.size.width * index;
    [_scrollV scrollRectToVisible:CGRectMake(_x,
                                             _scrollV.frame.origin.y,
                                             _scrollV.frame.size.width,
                                             _scrollV.frame.size.height)
                         animated:NO];
    //设置当前导航条标题
    [self.navigationItem setTitle:menuTitles[index]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollV) { //因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
        CGFloat _x = scrollView.contentOffset.x; //滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width); //所偶数当前视图
        //设置滑动过渡位置
        if (index < menu.selectedIndex) {
            if (_x < menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width) {
                [menu updateMenu:index];
                [self.navigationItem setTitle:menuTitles[index]];
            }
        } else if (index == menu.selectedIndex) {

            if (_x > menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width) {
                if (!globalData.loginModel.cardHolder) {
                    NSNotification *notifiaction = [NSNotification notificationWithName:@"updateBaseQueryController" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notifiaction];
                    vcNewBusiness.view.hidden = NO;
                    vcBusiness.view.hidden = YES;
                } else {
                    vcNewBusiness.view.hidden = YES;
                    vcBusiness.view.hidden = NO;
                }
                [menu updateMenu:index + 1];
                [self.navigationItem setTitle:menuTitles[index + 1]];
            } else {
                if (globalData.loginModel.cardHolder) {
                    vcMyProfile.view.hidden = NO;
                    vcMyProfileNoCard.view.hidden = YES;
                } else {
                    vcMyProfile.view.hidden = YES;
                    vcMyProfileNoCard.view.hidden = NO;
                }
            }
        } else {
            [menu updateMenu:index];
            [self.navigationItem setTitle:menuTitles[index]];
            if (globalData.loginModel.cardHolder) {
                vcMyProfile.view.hidden = NO;
                vcMyProfileNoCard.view.hidden = YES;
            } else {
                vcMyProfile.view.hidden = YES;
                vcMyProfileNoCard.view.hidden = NO;
            }
        }
    }
}

- (void)click {
    //add by zhangqy 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
    if (globalData.loginModel.cardHolder) {
        UIViewController *vc = kLoadVcFromClassStringName(@"GYHDRealNameRegisterViewController");
        [self pushVC:vc animated:YES];
    } else {
        UIViewController *vc = kLoadVcFromClassStringName(@"GYHSBasicInfomationController");
        [self pushVC:vc animated:YES];
    }
}

// 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
- (UIView *)createUIWithType:(NSInteger)type {
    //弹出的试图
    UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 290, 100)];
    //开始添加弹出的view中的组件
    UILabel *lbTip = [[UILabel alloc] initWithFrame:CGRectMake(30, 2, 200, 30)];
    lbTip.text = kLocalized(@"GYHS_Main_Warm_Prompt");
    lbTip.font = [UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor = [UIColor clearColor];
    UILabel *lbCardComment = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lbTip.frame) + 5, 230, 30)];
    lbCardComment.numberOfLines = 0;

    if (type == 1) {
        lbCardComment.text = kLocalized(@"GYHS_Main_Your_Information_Not_Complete_Affect_Some_Business_Use");
    } else {
        lbCardComment.text = kLocalized(@"GYHS_Main_Your_Information_Not_Complete_Affect_Some_Business_Use");
    }

    CGSize commentSize = [GYUtils sizeForString:lbCardComment.text font:[UIFont systemFontOfSize:17.0] width:lbCardComment.frame.size.width];
    lbCardComment.frame = CGRectMake(lbCardComment.frame.origin.x, lbCardComment.frame.origin.y, commentSize.width, commentSize.height);
    lbCardComment.textColor = kCellItemTitleColor;
    lbCardComment.font = [UIFont systemFontOfSize:17.0];
    lbCardComment.backgroundColor = [UIColor clearColor];

    [popView addSubview:lbTip];
    [popView addSubview:lbCardComment];
    return popView;
}

#pragma mark - Listening for Reader Status

- (void)reader:(GYQRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [reader stopScanning];
    [self settleQRScanString:result];
}

- (void)readerDidCancel:(GYQRCodeReaderViewController *)reader {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 处理二维码字符串
- (void)settleQRScanString:(NSString *)scranString {

    WS(weakSelf)
    // 商城生成的二维码
    if (([scranString hasPrefix:@"https://"] && [GYUtils isValidNumber:[scranString substringWithRange:NSMakeRange(8, 11)]]) || ([scranString hasPrefix:@"http://"] && [GYUtils isValidNumber:[scranString substringWithRange:NSMakeRange(7, 11)]])) { //企业端生成的二维码
        NSString *hsreNo = @"";
        if ([scranString hasPrefix:@"https://"]) {
            hsreNo = [scranString substringWithRange:NSMakeRange(8, 11)];
        } else {
            hsreNo = [scranString substringWithRange:NSMakeRange(7, 11)];
        }
        [GYGIFHUD show];
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl parameters:@{ @"key" : globalData.loginModel.token,
                                                                                                         @"resourceNo" : hsreNo } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if (error) {
                DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                [GYUtils parseNetWork:error resultBlock:nil];
                return;
            }
            GYShopDescribeController *vc = [[GYShopDescribeController alloc] init];
            ShopModel *model = [[ShopModel alloc] init];
            model.strVshopId = responseObject[@"data"][@"vShopId"];
            vc.shopModel = model;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];

        }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
    //互生卡号
    else if (scranString.length == 14 && [scranString hasPrefix:@"ID"]) {

        scranString = [scranString substringFromIndex:3];
        GYHSCardInfoVC *cardInfoVc = [[GYHSCardInfoVC alloc] init];
        cardInfoVc.cardNumber = scranString;
        [weakSelf.navigationController pushViewController:cardInfoVc animated:YES];
    }
    //pos机订单支付(旧)
    else if (scranString.length == 192) {
        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];
            GYNetRequest *requset = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/common/qrCodePay"] parameters:@{ @"str" : scranString } requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
                [GYGIFHUD dismiss];
                if (error) {
                    NSInteger errorRetCode = [error code];
                    if (errorRetCode == 220) {
                        [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                        return;
                    }
                    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", requset.URLString, (long)[error code], [error localizedDescription]);
                    [GYUtils parseNetWork:error resultBlock:nil];
                    return;
                }
                GYQRPayModel *model = [GYQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                GYHSOrderPayConfirmVC *orderInfoVc = [[GYHSOrderPayConfirmVC alloc] init];
                orderInfoVc.model = model;
                orderInfoVc.paymentStatu = GYOldPaymentWay;
                [weakSelf.navigationController pushViewController:orderInfoVc animated:YES];
            }];
            [requset commonParams:[GYUtils netWorkCommonParams]];
            [requset start];
        } else {

            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //pos机订单支付(新)
    else if (scranString.length > 192 && [scranString hasPrefix:@"B1"]) {
        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];
            GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/custCard/qrCodePay"] parameters:@{ @"str" : scranString } requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
                [GYGIFHUD dismiss];
                if (error) {
                    NSInteger errorRetCode = [error code];
                    if (errorRetCode == 220) {
                        [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        return;
                    }
                    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                    [GYUtils parseNetWork:error resultBlock:nil];
                    return;
                }
                GYQRPayModel *model = [GYQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                [weakSelf checkCustCouponDataFromNet:model WithPayStatus:GYNewPaymentWay];
            }];
            [request commonParams:[GYUtils netWorkCommonParams]];
            [request start];
        } else {

            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //手机旧
    else if ([scranString containsString:@"MH&"] && [scranString componentsSeparatedByString:@"&"].count <= 12) {

        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];

            GYNetRequest *requset = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/common/processEbCodePay"] parameters:@{@"str" : scranString } requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
                [GYGIFHUD dismiss];
                if (error) {
                    NSInteger errorRetCode = [error code];
                    if (errorRetCode == 220) {
                        [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        return;
                    }
                    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", requset.URLString, (long)[error code], [error localizedDescription]);
                    [GYUtils parseNetWork:error resultBlock:nil];
                    return;
                }
                GYQRPayModel *model = [GYQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                GYHSOrderPayConfirmVC *orderInfoVc = [[GYHSOrderPayConfirmVC alloc] init];
                orderInfoVc.model = model;
                orderInfoVc.paymentStatu = GYOldPaymentWay;
                [weakSelf.navigationController pushViewController:orderInfoVc animated:YES];
            }];
            [requset commonParams:[GYUtils netWorkCommonParams]];
            [requset start];
        } else {

            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //手机新版
    else if ([scranString containsString:@"M1&"] && [scranString componentsSeparatedByString:@"&"].count <= 12) {

        if (globalData.loginModel.cardHolder) {
            [GYGIFHUD show];
            GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/custCard/processEbCodePay"] parameters:@{ @"str" : scranString } requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
                [GYGIFHUD dismiss];
                if (error) {
                    NSInteger errorRetCode = [error code];
                    if (errorRetCode == 220) {
                        [GYUtils showToast:kLocalized(@"GYHS_Main_POS_This_Deal_Paid")];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        return;
                    }
                    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                    [GYUtils parseNetWork:error resultBlock:nil];
                    return;
                }
                GYQRPayModel *model = [GYQRPayModel mj_objectWithKeyValues:responseObject[@"data"]];
                [weakSelf checkCustCouponDataFromNet:model WithPayStatus:GYNewPaymentWay];
            }];
            [request commonParams:[GYUtils netWorkCommonParams]];
            [request start];
        } else {
            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    // 第一版二维码生成规则
    else if ([scranString containsString:@"MH&"] && [scranString componentsSeparatedByString:@"&"].count >= 13) {

        if (globalData.loginModel.cardHolder) { // bill qrcode
            GYQRPayModel *model = [[GYQRPayModel alloc] init];
            NSArray<NSString *> *modelArr = [scranString componentsSeparatedByString:@"&"];

            model.entResNo = modelArr[1];
            model.entCustId = modelArr[2];
            model.voucherNo = modelArr[3];
            model.batchNo = modelArr[4];
            model.posDeviceNo = modelArr[5];
            model.date = modelArr[6];
            model.currencyCode = modelArr[7];
            model.tradeAmount = [@(modelArr[8].doubleValue / 100)stringValue];
            model.pointRate = [@(modelArr[9].doubleValue / 10000)stringValue];
            model.acceptScore = [@(modelArr[10].doubleValue / 100)stringValue];
            model.hsbAmount = [@(modelArr[11].doubleValue / 100)stringValue];
            model.transNo = modelArr[12];
            model.entName = modelArr[13];

            GYHSOrderPayConfirmVC *orderInfoVc = [[GYHSOrderPayConfirmVC alloc] init];
            orderInfoVc.model = model;
            orderInfoVc.paymentStatu = GYOldPaymentWay;
            [weakSelf.navigationController pushViewController:orderInfoVc animated:YES];
        } else {
            [GYUtils showToast:kLocalized(@"GYHS_Main_Please_Again_After_Logging_Using_Alternate_Number")];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {

        [GYUtils showToast:kLocalized(@"GYHS_Main_HS_Pos_Deal_Failure")];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)checkCustCouponDataFromNet:(GYQRPayModel *)model WithPayStatus:(GYPaymentStatus)PaymentWay {
    WS(weakSelf)
    if (kSaftToNSInteger(model.couponNum) <= 0) {
        GYHSOrderPayConfirmVC *orderInfoVc = [[GYHSOrderPayConfirmVC alloc] init];
        orderInfoVc.model = model;
        orderInfoVc.paymentStatu = PaymentWay;
        [weakSelf.navigationController pushViewController:orderInfoVc animated:YES];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:kSaftToNSString(globalData.loginModel.resNo) forKey:@"resNo"];
        [params setValue:kSaftToNSString(model.couponNum) forKey:@"couponNum"];

        [GYGIFHUD show];

        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSCheckCustCouponData parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if (error) {
                NSInteger errorRetCode = [error code];
                if (errorRetCode == 600201) {
                    [GYUtils showToast:kSaftToNSString(responseObject[@"msg"])];//抵扣券金额不足,请重试!
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    return;
                }
                DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                [GYUtils parseNetWork:error resultBlock:nil];
                return;
            }
            GYHSOrderPayConfirmVC *orderInfoVc = [[GYHSOrderPayConfirmVC alloc] init];
            orderInfoVc.model = model;
            orderInfoVc.paymentStatu = PaymentWay;
            [weakSelf.navigationController pushViewController:orderInfoVc animated:YES];
        }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
}

@end