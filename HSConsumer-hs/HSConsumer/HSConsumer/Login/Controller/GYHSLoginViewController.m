//
//  GYHSLoginViewControllerNew.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginViewController.h"
#import "GYHSLoginVCInfoTableCell.h"
#import "GYHSLoginVCSecurityCodeTableCell.h"
#import "GYHSRequestData.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginHistoryModel.h"
#import "GYHSLoginModel.h"
#import "GYHSLoginHistoryView.h"
#import "GYHSChangeLoginENController.h"
#import "GYHSLoginVCPwdTableCell.h"
#import "GYPasswordKeyboardView.h"
#import "IQKeyboardManager.h"
#import "GYHPwdRegistMainVC.h"
#import "GYHSPopView.h"
#import "Masonry.h"
#import "GYHDMessageCenter.h"

#define GYHSLoginVCUserNameTag 1001
#define GYHSLoginVCPwdTag 1002
#define GYHSLoginVCSecurityCodeTag 1003

NSString* const GYHSLoginVC_Cell_Value_Name = @"GYHSLoginVC_Cell_Value_Name";
NSString* const GYHSLoginVC_Cell_Value_PlaceHolder = @"GYHSLoginVC_Cell_Value_PlaceHolder";
NSString* const GYHSLoginVC_Cell_Image_Name = @"GYHSLoginVC_Cell_Image_Name";

@interface GYHSLoginViewController () <UITableViewDelegate, UITableViewDataSource, GYHSLoginVCInfoTableCellDelegate, GYHSLoginVCPwdTableCellDelegate, GYHSLoginVCSecurityCodeTableCellDelegate, GYHSLoginHistoryViewDelegate, GYPasswordKeyboardViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* inputSecCode;
@property (nonatomic, strong) NSString* genSecCode;

@property (nonatomic, strong) GYHSRequestData* requestData;
@property (nonatomic, strong) UIImageView* pullDownImageView;
@property (nonatomic, strong) NSIndexPath* userInfoIndexPath;
@property (nonatomic, strong) NSIndexPath* securityCodeIndexPath;

@property (nonatomic, strong) GYPasswordKeyboardView* myKeyBoardView;
@property (nonatomic, strong) UIView* footView;
@property (nonatomic, assign) BOOL isSendRequest;

@end

@implementation GYHSLoginViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
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
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    NSDictionary* dic = self.dataArray[indexPath.row];
    NSString* value = [dic valueForKey:GYHSLoginVC_Cell_Value_Name];
    NSString* placeHolder = [dic valueForKey:GYHSLoginVC_Cell_Value_PlaceHolder];
    NSString* imageName = [dic valueForKey:GYHSLoginVC_Cell_Image_Name];

    if (indexPath.row == 0) {
        GYHSLoginVCInfoTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLoginVCInfoTableCell"];

        [cell setCellValue:imageName
                     value:value
               placeHolder:placeHolder
              pwdTextField:NO
                 indexPath:indexPath];
        cell.cellDelegate = self;

        UIView* tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self keyBoardHeight])];
        self.myKeyBoardView.frame = tmpView.bounds;
        cell.cellInputTextField.tag = GYHSLoginVCUserNameTag;
        [self.myKeyBoardView settingInputView:cell.cellInputTextField];
        [self.myKeyBoardView pop:tmpView];
        [self.footView addSubview:tmpView];

        return cell;
    }
    else if (indexPath.row == 1) {
        GYHSLoginVCPwdTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLoginVCPwdTableCell"];
        [cell setCellValue:placeHolder btnName:value indexPath:indexPath];
        cell.cellDelegate = self;
        return cell;
    }
    else {
        GYHSLoginVCSecurityCodeTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLoginVCSecurityCodeTableCell"];
        cell.cellDelegate = self;
        [cell setCellName:placeHolder btnName:value indexPath:indexPath];
        self.securityCodeIndexPath = indexPath;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0;
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
    view.pageType = self.pageType;
    view.popType = self.popType;
    [view show];
}

- (void)inputTextField:(UITextField*)textField indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        textField.tag = GYHSLoginVCUserNameTag;
        [self.myKeyBoardView settingInputView:textField];
    }
}

#pragma mark - GYHSLoginVCPwdTableCellDelegate
- (void)forgetPwdBtnAction:(NSIndexPath*)indexPath
{
    if (self.popType == GYHSLoginVCShowPopView) {
        [self.view.superview.superview.superview.superview removeFromSuperview];
    }

    GYHPwdRegistMainVC* vc = [[GYHPwdRegistMainVC alloc] init];
    vc.loginType = self.loginType;
    vc.popType = self.popType;
    vc.pageType = self.pageType;
    GYHSPopView* popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [popView showView:vc withViewFrame:CGRectMake(10, 90, kScreenWidth - 20, 300)];
}

- (void)pwdInputTextField:(UITextField*)textField indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 1) {
        textField.tag = GYHSLoginVCPwdTag;
        [self.myKeyBoardView settingInputView:textField];
    }
}

#pragma mark - GYHSLoginVCSecurityCodeTableCellDelegate
- (void)inputAnswer:(UITextField*)textField indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 2) {
        textField.tag = GYHSLoginVCSecurityCodeTag;
        [self.myKeyBoardView settingInputView:textField];
    }
}

- (void)securityGenCode:(NSString*)genCode
{
    self.genSecCode = genCode;
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
    }
}

- (void)selectHSNumber:(NSString*)number
{
    self.userName = number;

    GYHSLoginVCInfoTableCell* cell = [self.tableView cellForRowAtIndexPath:self.userInfoIndexPath];
    NSDictionary* dic = self.dataArray[self.userInfoIndexPath.row];
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

#pragma mark - GYPasswordKeyboardViewDelegate
- (void)textFiledEdingChanged:(UITextField*)textField
{
    NSInteger textLength = 11;
    if (textField.tag == GYHSLoginVCUserNameTag) {
        textLength = 11;
    }
    else if (textField.tag == GYHSLoginVCPwdTag) {
        textLength = 6;
    }
    else if (textField.tag == GYHSLoginVCSecurityCodeTag) {
        textLength = 4;
    }

    if (textField.text.length >= textLength) {
        textField.text = [textField.text substringToIndex:textLength];
        [textField endEditing:YES];
    }

    if (textField.tag == GYHSLoginVCUserNameTag) {
        self.userName = textField.text;
    }
    else if (textField.tag == GYHSLoginVCPwdTag) {
        self.password = textField.text;
    }
    else if (textField.tag == GYHSLoginVCSecurityCodeTag) {
        self.inputSecCode = textField.text;
    }
}

- (void)returnPasswordKeyboard:(GYPasswordKeyboardView*)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString*)password
{
    [self confirmButtonAction];
}

#pragma mark - event response
- (void)selectEnvironmentAction
{
    GYHSChangeLoginENController* vc = [[GYHSChangeLoginENController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private methods
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat headHeight = 10;
    if (kIS_IPHONE_4_OR_LESS && self.popType == GYHSLoginVCNoShowPopView) {
        headHeight = 5;
    }
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headHeight)];
    headView.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.tableHeaderView = headView;

    self.tableView.tableFooterView = self.footView;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (UIView*)selectEnvironmentView
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIButton* btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = view.bounds;
    [btnSetting setImage:[UIImage imageNamed:@"gyhs_login_btn_set_blue"] forState:UIControlStateNormal];
    [btnSetting setTitle:kLocalized(@"GYHS_Login_SettingEnviroument") forState:UIControlStateNormal];
    [btnSetting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSetting.titleLabel setFont:[UIFont systemFontOfSize:14]];
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

    if (self.inputSecCode.length == 0) {
        [GYUtils showMessage:kLocalized(@"验证码不能为空")];
        return;
    }

    if (![self.genSecCode isEqualToString:self.inputSecCode]) {
        [GYUtils showMessage:kLocalized(@"校验码输入错误！")];
        return;
    }

    if (self.isSendRequest) {
        DDLogDebug(@"The login is sending. %d", self.isSendRequest);
        return;
    }
    self.isSendRequest = YES;

    WS(weakSelf)
    BOOL isCarDUser = (self.loginType == GYHSLoginViewControllerTypeHashsCard) ? YES : NO;
    [self.requestData sendLoginAction:self.userName pwd:self.password isCardUser:isCarDUser loginBlokc:^(GYHSLoginModel* loginModel) {
        weakSelf.isSendRequest = NO;
        [weakSelf refreshSecurityCode];
        
        if (loginModel == nil) {
            DDLogDebug(@"The loginModel is nil.");
            return;
        }
        
        [GYUtils showToast:kLocalized(@"GYHS_Login_Login_complete")];
        globalData.loginModel.cardHolder = isCarDUser;
        globalData.loginModel = loginModel;
        [self requestNetworkInfo];
        [[GYHSLoginManager shareInstance] saveLoginModel:loginModel];
        [[GYHSLoginManager shareInstance] setGlobalData];
        
        GYHSLoginHistoryModel *historyModel = [[GYHSLoginHistoryModel alloc] init];
        historyModel.userName = weakSelf.userName;
        historyModel.holderCar = loginModel.cardHolder;
        historyModel.headPic = [NSString stringWithFormat:@"%@%@", loginModel.picUrl, loginModel.headPic];
        [[GYHSLoginManager shareInstance] saveLoginHistoryModel:historyModel];
        
        // 登陆成功发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kGYHSLoginMainVCLoginSucessedNotification object:nil];
    }];
}

- (void)requestNetworkInfo
{ //globalData.loginModel.hdbizDomain
    NSString* urlString = [NSString stringWithFormat:@"%@/hsim-bservice/userCenter/queryUserInfoBycustId", @"http://192.168.233.135:9090"];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"custId"] = kSaftToNSString(globalData.loginModel.custId);
    NSMutableDictionary* sendDict = [NSMutableDictionary dictionary];
    sendDict[@"data"] = insideDict;
    sendDict[@"channelType"] = @"4";
    sendDict[@"custId"] = kSaftToNSString(globalData.loginModel.custId);
    sendDict[@"loginToken"] = kSaftToNSString(globalData.loginModel.token);
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:urlString parameters:sendDict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if(responseObject) {
            NSMutableDictionary *friendDetailDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:responseObject[@"searchUserInfo"][GYHDDataBaseCenterFriendDetailed]]];
            globalData.networkInfoModel = [[GYHDUserSetingHeaderModel alloc] initWithDictionary:friendDetailDict error:nil];
        }

    }];
    [request start];
}

- (CGFloat)keyBoardHeight
{
    CGFloat height = 140;
    if (self.popType == GYHSLoginVCShowPopView) {
        return height;
    }

    CGFloat width = self.view.frame.size.width / 4;
    height = width * 2 > 140 ? width * 2 : 140;

    if (kIS_IPHONE_4_OR_LESS) {
        height = 140;

        if (self.pageType == GYHSLoginVCPageTypeHS) {
            height = 110;
        }
    }

    return height;
}

- (void)refreshSecurityCode
{
    if ([GYUtils checkObjectInvalid:self.securityCodeIndexPath]) {
        DDLogDebug(@"The securityCodeIndexPath:%@", self.securityCodeIndexPath);
        return;
    }

    GYHSLoginVCSecurityCodeTableCell* cell = [self.tableView cellForRowAtIndexPath:self.securityCodeIndexPath];
    [cell refreshVerifyCode];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.delaysContentTouches = NO;

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLoginVCInfoTableCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLoginVCInfoTableCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLoginVCPwdTableCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLoginVCPwdTableCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLoginVCSecurityCodeTableCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLoginVCSecurityCodeTableCell"];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        NSString* userPlaceHodler = kLocalized(@"GYHS_Login_Enter_11_Number");
        NSString* userImage = @"gycommon_tab_mine_normal";

        NSMutableArray* userAry = [self historyData];
        self.userName = @"";
        if ([userAry count] > 0) {
            GYHSLoginHistoryModel* model = [userAry firstObject];
            self.userName = model.userName;
        }

        if (self.loginType == GYHSLoginViewControllerTypeNohsCard) {
            userPlaceHodler = kLocalized(@"GYHS_Login_Input_Phone_Number");
            userImage = @"gyhs_login_mobile_img_icon";
        }

        [_dataArray addObject:@{ GYHSLoginVC_Cell_Value_Name : self.userName,
            GYHSLoginVC_Cell_Value_PlaceHolder : userPlaceHodler,
            GYHSLoginVC_Cell_Image_Name : userImage }];
        if (self.loginType == GYHSLoginViewControllerTypeNohsCard) {
            [_dataArray addObject:@{ GYHSLoginVC_Cell_Value_Name : kLocalized(@"忘记密码/注册"),
                GYHSLoginVC_Cell_Value_PlaceHolder : kLocalized(@"GYHS_Login_Enter_Login_Password"),
                GYHSLoginVC_Cell_Image_Name : @"gyhs_login_lock_img_pwd"
            }];
        }
        else {
            [_dataArray addObject:@{ GYHSLoginVC_Cell_Value_Name : kLocalized(@"忘记密码"),
                GYHSLoginVC_Cell_Value_PlaceHolder : kLocalized(@"GYHS_Login_Enter_Login_Password"),
                GYHSLoginVC_Cell_Image_Name : @"gyhs_login_lock_img_pwd"
            }];
        }

        [_dataArray addObject:@{ GYHSLoginVC_Cell_Value_Name : kLocalized(@"点击刷新"),
            GYHSLoginVC_Cell_Value_PlaceHolder : kLocalized(@"输入验证码"),
            GYHSLoginVC_Cell_Image_Name : @"hs_icon_security_code"
        }];
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

- (GYPasswordKeyboardView*)myKeyBoardView
{
    if (_myKeyBoardView == nil) {
        _myKeyBoardView = [[GYPasswordKeyboardView alloc] init];
        _myKeyBoardView.style = GYPasswordKeyboardStyleLogin;
        _myKeyBoardView.type = GYPasswordKeyboardReturnTypeConfirm;

        GYPasswordKeyboardCommitColorType colorType = GYPasswordKeyboardCommitColorTypeDefault;
        if (self.pageType == GYHSLoginVCPageTypeHE) {
            colorType = GYPasswordKeyboardCommitColorTypeOrange;
        }
        else if (self.pageType == GYHSLoginVCPageTypeHD) {
            colorType = GYPasswordKeyboardCommitColorTypeRed;
        }

        _myKeyBoardView.colorType = colorType;
        _myKeyBoardView.delegate = self;
    }

    return _myKeyBoardView;
}

- (UIView*)footView
{
    if (_footView == nil) {

        CGFloat height = [self keyBoardHeight];
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];

        if (self.popType == GYHSLoginVCNoShowPopView) {
            _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height + 44)];
            UIView* tmpView = [self selectEnvironmentView];
            tmpView.frame = CGRectMake(0, height, self.view.frame.size.width, 44);
            [_footView addSubview:tmpView];
        }
    }
    
    return _footView;
}
@end
