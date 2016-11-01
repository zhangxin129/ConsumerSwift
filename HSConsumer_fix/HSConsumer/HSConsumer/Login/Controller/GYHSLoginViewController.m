//
//  GYHSLoginViewControllerNew.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginViewController.h"
#import "GYHSConstant.h"
#import "GYHSLoginVCInfoTableCell.h"
#import "GYHSLoginVConfirmTableCell.h"
#import "GYHSLoginVCBtnActionTableCell.h"
#import "GYHSUserRegisterVC.h"
#import "GYHSForgotPasswdVC.h"
#import "GYHSRequestData.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginHistoryModel.h"
#import "GYHSLoginModel.h"
#import "GYHSLoginHistoryView.h"
#import "UIButton+GYExtension.h"
#import "GYHSChangeLoginENController.h"
#import "GYTabBarController.h"
#import "GYSlideMenuController.h"

NSString* const GYHSLoginVC_Cell_Info = @"GYHSLoginVC_Cell_Info";
NSString* const GYHSLoginVC_Cell_Confirm_Btn = @"GYHSLoginVC_Cell_Confirm_Btn";
NSString* const GYHSLoginVC_Cell_Btn_Action = @"GYHSLoginVC_Cell_Btn_Action";

NSString* const GYHSLoginVC_Cell_Value_Name = @"GYHSLoginVC_Cell_Value_Name";
NSString* const GYHSLoginVC_Cell_Value_Name2 = @"GYHSLoginVC_Cell_Value_Name2";
NSString* const GYHSLoginVC_Cell_Value_PlaceHolder = @"GYHSLoginVC_Cell_Value_PlaceHolder";
NSString* const GYHSLoginVC_Cell_PWD_TextField = @"GYHSLoginVC_Cell_PWD_TextField";
NSString* const GYHSLoginVC_Cell_Image_Name = @"GYHSLoginVC_Cell_Image_Name";

@interface GYHSLoginViewController () <UITableViewDelegate, UITableViewDataSource, GYHSLoginVCInfoTableCellDelegate, GYHSLoginVCBtnActionTableCellDelegate, GYHSLoginVConfirmTableCellDelegate, GYHSLoginHistoryViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* password;

@property (nonatomic, strong) GYHSRequestData* requestData;
@property (nonatomic, strong) UIImageView* pullDownImageView;
@property (nonatomic, strong) NSIndexPath* userInfoIndexPath;

@end

@implementation GYHSLoginViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DDLogDebug(@"delloc:%@", [self class]);
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    NSDictionary* dic = self.dataArray[indexPath.section][indexPath.row];
    NSString* value = [dic valueForKey:GYHSLoginVC_Cell_Value_Name];

    if (indexPath.section == 0) {
        GYHSLoginVCInfoTableCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHSLoginVC_Cell_Info];

        NSString* placeHolder = [dic valueForKey:GYHSLoginVC_Cell_Value_PlaceHolder];
        NSString* imageName = [dic valueForKey:GYHSLoginVC_Cell_Image_Name];
        BOOL pwdTextField = NO;
        NSString* strShowDown = [dic valueForKey:GYHSLoginVC_Cell_PWD_TextField];
        if ([@"YES" isEqualToString:strShowDown]) {
            pwdTextField = YES;
        }

        [cell setCellValue:imageName
                     value:value
               placeHolder:placeHolder
              pwdTextField:pwdTextField
                 indexPath:indexPath];
        cell.cellDelegate = self;
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            GYHSLoginVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHSLoginVC_Cell_Confirm_Btn];

            [cell setCellName:value loginType:self.loginType];
            cell.cellDelegate = self;
            return cell;
        }
        else {
            GYHSLoginVCBtnActionTableCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHSLoginVC_Cell_Btn_Action];

            NSString* forgetName = [dic valueForKey:GYHSLoginVC_Cell_Value_Name2];
            [cell setCellName:value loginType:self.loginType forgetName:forgetName];
            cell.cellDelegate = self;

            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - GYHSLoginVCInfoTableCellDelegate
- (void)pullDownBtnAction:(UIImageView*)imageView indexPath:(NSIndexPath*)indexPath
{
    self.pullDownImageView = imageView;
    self.userInfoIndexPath = indexPath;

    [UIView animateWithDuration:0.2 animations:^{
        self.pullDownImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished){
    }];

    GYHSLoginHistoryView* view = [[GYHSLoginHistoryView alloc] initWithView:self.view dataArray:[self historyData]];
    view.historyDelegate = self;
    [view show];
}

- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.userName = value;
        }
        else if (indexPath.row == 1) {
            self.password = value;
        }
    }
}

#pragma mark - GYHSLoginVCBtnActionTableCellDelegate
- (void)changeHSView
{
    GYHSLoginViewController* vc = [[GYHSLoginViewController alloc] init];
    vc.loginType = GYHSLoginViewControllerTypeHashsCard;

    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        vc.loginType = GYHSLoginViewControllerTypeNohsCard;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetPwdActon
{
    GYHSForgotPasswdVC* vc = [[GYHSForgotPasswdVC alloc] init];
    vc.loginType = self.loginType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GYHSLoginVConfirmTableCellDelegate
- (void)confirmButtonAction
{

    [self.view endEditing:YES];
    if ([GYUtils checkStringInvalid:self.userName] ||
        [GYUtils checkStringInvalid:self.password]) {
        DDLogDebug(@"the userName:%@ or password:%@ is empyt.", self.userName, self.password);
        [GYUtils showMessage:kLocalized(@"GYHS_Login_User_Name_Empty")];
        return;
    }

    if (self.password.length != 6) {
        DDLogDebug(@"the password:%@ is not 6 number.", self.password);
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Passwrod_Not_6_Number")];
        return;
    }

    if (self.loginType == GYHSLoginViewControllerTypeNohsCard) {
        if (![GYUtils isMobileNumber:self.userName]) {
            [GYUtils showMessage:kLocalized(@"输入的电话号码有误！")];
            return;
        }
    }
    // 检查页面跳转
    [self goToMainInterface:self.userName];

    WS(weakSelf)
    BOOL isCarDUser = (self.loginType == GYHSLoginViewControllerTypeHashsCard) ? YES : NO;
    [self.requestData sendLoginAction:self.userName pwd:self.password isCardUser:isCarDUser loginBlokc:^(GYHSLoginModel* loginModel) {
        if (loginModel == nil) {
            DDLogDebug(@"The loginModel is nil.");
            return;
        }
        
        [GYUtils showToast:kLocalized(@"GYHS_Login_Login_complete")];
        globalData.loginModel.cardHolder = isCarDUser;
        globalData.loginModel = loginModel;
        [[GYHSLoginManager shareInstance] saveLoginModel:loginModel];
        [[GYHSLoginManager shareInstance] setGlobalData];
        
        GYHSLoginHistoryModel *historyModel = [[GYHSLoginHistoryModel alloc] init];
        historyModel.userName = weakSelf.userName;
        historyModel.holderCar = loginModel.cardHolder;
        historyModel.headPic = [NSString stringWithFormat:@"%@%@", loginModel.picUrl, loginModel.headPic];
        [[GYHSLoginManager shareInstance] saveLoginHistoryModel:historyModel];
        
        [weakSelf dismissVC];
    }];
}

#pragma mark - GYHSLoginHistoryViewDelegate
- (void)historyViewState:(BOOL)show
{

    if (self.pullDownImageView == nil) {
        return;
    }

    if (!show) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pullDownImageView.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished){
        }];
        ;
    }
}

- (void)selectHSNumber:(NSString*)number
{
    DDLogDebug(@"%@", number);
    self.userName = number;

    GYHSLoginVCInfoTableCell* cell = [self.tableView cellForRowAtIndexPath:self.userInfoIndexPath];
    NSDictionary* dic = self.dataArray[self.userInfoIndexPath.section][self.userInfoIndexPath.row];
    NSString* placeHolder = [dic valueForKey:GYHSLoginVC_Cell_Value_PlaceHolder];
    NSString* imageName = [dic valueForKey:GYHSLoginVC_Cell_Image_Name];

    [cell setCellValue:imageName
                 value:number
           placeHolder:placeHolder
          pwdTextField:NO
             indexPath:self.userInfoIndexPath];
}

- (void)deleteHSNumber:(NSString*)number
{
    DDLogDebug(@"%@", number);

    NSMutableArray* historyAry = [[GYHSLoginManager shareInstance] loginHistoryModel];
    for (GYHSLoginHistoryModel* indexModel in historyAry) {
        if ([indexModel.userName isEqualToString:number]) {
            [historyAry removeObject:indexModel];
            break;
        }
    }

    [[GYHSLoginManager shareInstance] initLoginHistory:historyAry];
}

#pragma mark - event response
- (void)dismissVC
{
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];

    if (!globalData.isLogined) {
        GYTabBarController* tabBarVc = (GYTabBarController*)globalData.viewController.mainViewController;
        tabBarVc.selectedIndex = self.dismissBarIndex;
    }
}

- (void)registerButtonAction
{
    GYHSUserRegisterVC* vc = [[GYHSUserRegisterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectEnvironmentAction
{
    GYHSChangeLoginENController* vc = [[GYHSChangeLoginENController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private methods
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];

    NSString* title = kLocalized(@"GYHS_Login_Title");
    NSString* backImage = @"gyhe_nav_btn_redback";
    UIColor* reginstColor = kNavigationBarColor;

    if (self.loginType == GYHSLoginViewControllerTypeNohsCard) {
        title = kLocalized(@"GYHS_Login_No_Card_Login");
        backImage = @"gyhs_login_nav_btn_back_yellow_login";
        reginstColor = [UIColor orangeColor];
    }

    UILabel* titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
    titleLable.text = title;
    titleLable.font = [UIFont systemFontOfSize:21];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = kCorlorFromRGBA(27, 21, 19, 1);
    self.navigationItem.titleView = titleLable;

    UIImage* image = [UIImage imageNamed:backImage];
    CGRect backframe = CGRectMake(0, 0, image.size.width * 0.7, image.size.height * 0.7);
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setEnlargEdgeWithTop:20 right:20 bottom:20 left:25];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    UIButton* registrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registrBtn.frame = CGRectMake(0, 0, 60, 44);
    [registrBtn setTitle:kLocalized(@"GYHS_Login_Register") forState:UIControlStateNormal];
    [registrBtn setTitleColor:reginstColor forState:UIControlStateNormal];
    registrBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [registrBtn addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registrBtn];

    self.tableView.tableFooterView = [self selectEnvironmentView];
    [self.view addSubview:self.tableView];
}

- (UIView*)selectEnvironmentView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UIButton* btnSetting = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, 7, 100, 30)];
    [btnSetting setImage:[UIImage imageNamed:@"gyhs_login_btn_set_blue"] forState:UIControlStateNormal];
    [btnSetting setTitle:kLocalized(@"GYHS_Login_SettingEnviroument") forState:UIControlStateNormal];
    [btnSetting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(selectEnvironmentAction) forControlEvents:UIControlEventTouchUpInside];

    //生产环境不显示登录环境设置
    BOOL setBtnState = (kisReleaseEn || [GYHSLoginEn sharedInstance].loginLine == kLoginEn_demo);
    btnSetting.hidden = setBtnState;
    [view addSubview:btnSetting];

    return view;
}

- (NSMutableArray*)historyData
{
    NSMutableArray* hasCarAry = [NSMutableArray array];
    NSMutableArray* noHasCarAry = [NSMutableArray array];
    NSMutableArray* historyAry = [[GYHSLoginManager shareInstance] loginHistoryModel];

    for (GYHSLoginHistoryModel* indexModel in historyAry) {
        if (indexModel.holderCar) {
            [hasCarAry addObject:indexModel];
        }
        else {
            [noHasCarAry addObject:indexModel];
        }
    }

    NSMutableArray* resultAry = [NSMutableArray arrayWithArray:hasCarAry];
    if (self.loginType == GYHSLoginViewControllerTypeNohsCard) {
        [resultAry removeAllObjects];
        [resultAry addObjectsFromArray:noHasCarAry];
    }

    return resultAry;
}

- (void)goToMainInterface:(NSString*)newUser
{
    if (!self.needToMainInterface) {
        DDLogDebug(@"The needToMainInterface:%d", self.needToMainInterface);
        return;
    }

    if ([self.historyData count] <= 0) {
        DDLogDebug(@"The userAry is less then zero.");
        return;
    }

    GYHSLoginHistoryModel* historyModel = [self.historyData firstObject];
    if (![newUser isEqualToString:historyModel.userName]) {
        [[GYHSLoginManager shareInstance] goToRootView:1];
    }
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;

        [_tableView registerNib:[UINib nibWithNibName:@"GYHSLoginVCInfoTableCell" bundle:nil] forCellReuseIdentifier:GYHSLoginVC_Cell_Info];
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSLoginVConfirmTableCell" bundle:nil] forCellReuseIdentifier:GYHSLoginVC_Cell_Confirm_Btn];
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSLoginVCBtnActionTableCell" bundle:nil] forCellReuseIdentifier:GYHSLoginVC_Cell_Btn_Action];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        NSMutableArray* infoAry = [NSMutableArray array];

        NSString* userPlaceHodler = kLocalized(@"GYHS_Login_Enter_11_Number");
        NSString* userImage = @"hs_icon_real_name_no";
        NSString* changeLoginName = kLocalized(@"GYHS_Login_No_Card_Login");
        NSMutableArray* userAry = [self historyData];
        self.userName = @"";
        if ([userAry count] > 0) {
            GYHSLoginHistoryModel* model = [userAry firstObject];
            self.userName = model.userName;
        }

        if (self.loginType == GYHSLoginViewControllerTypeNohsCard) {
            userPlaceHodler = kLocalized(@"GYHS_Login_Input_Phone_Number");
            userImage = @"gyhs_login_mobile_img_icon";
            changeLoginName = kLocalized(@"GYHS_Login_Hs_Card_Login");
        }

        [infoAry addObject:@{ GYHSLoginVC_Cell_Value_Name : self.userName,
            GYHSLoginVC_Cell_Value_PlaceHolder : userPlaceHodler,
            GYHSLoginVC_Cell_Image_Name : userImage,
            GYHSLoginVC_Cell_PWD_TextField : @"NO"
        }];

        [infoAry addObject:@{ GYHSLoginVC_Cell_Value_Name : @"",
            GYHSLoginVC_Cell_Value_PlaceHolder : kLocalized(@"GYHS_Login_Enter_Login_Password"),
            GYHSLoginVC_Cell_Image_Name : @"gyhs_login_lock_img_pwd",
            GYHSLoginVC_Cell_PWD_TextField : @"YES"
        }];
        [_dataArray addObject:infoAry];

        [_dataArray addObject:@[
            @{ GYHSLoginVC_Cell_Value_Name : kLocalized(@"GYHS_Login_Title")
            },

            @{ GYHSLoginVC_Cell_Value_Name : changeLoginName,
                GYHSLoginVC_Cell_Value_Name2 : kLocalized(@"GYHS_Login_Forget_Pwd")
            }
        ]];
    }

    return _dataArray;
}

- (GYHSRequestData*)requestData
{
    if (_requestData == nil) {
        _requestData = [[GYHSRequestData alloc] init];
    }

    return _requestData;
}



@end
