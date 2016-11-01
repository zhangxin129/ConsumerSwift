//
//  GYHSPhoneBandingVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPhoneBandingVC.h"
#import "GYHSRegisterTableCell.h"
#import "GYHSLoginVConfirmTableCell.h"
#import "GYNetRequest.h"
#import "GYHSRequestData.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginModel.h"
#import "GYHSNetworkAPI.h"
#import "GYHSConstant.h"
#import "NSString+GYExtension.h"

#define kGYHSPhoneBandingVC_CellIdentify @"kGYHSPhoneBandingVC_CellIdentify"
#define kGYHSPhoneBandingVC_CellBtnIdentify @"kGYHSPhoneBandingVC_CellBtnIdentify"

#define kPhoneNumberBanding_Tag 100

@interface GYHSPhoneBandingVC () <UITableViewDelegate, UITableViewDataSource, GYHSRegisterTableCellDelegate, GYHSLoginVConfirmTableCellDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYHSRequestData* requestData;

@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* smsCode;
@property (nonatomic, strong) NSString* loginPwd;

@end

@implementation GYHSPhoneBandingVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    NSString* name = [dic valueForKey:@"Name"];

    if (indexPath.section == 0) {
        GYHSRegisterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSPhoneBandingVC_CellIdentify];
        NSString* value = [dic valueForKey:@"Value"];
        NSString* placeHolder = [dic valueForKey:@"placeHolder"];
        BOOL pwdType = [[dic valueForKey:@"pwdType"] boolValue];
        BOOL showSmsBtn = [[dic valueForKey:@"showSmsBtn"] boolValue];
        NSInteger maxSize = [[dic valueForKey:@"maxSize"] integerValue];

        [cell setCellValue:name
                     value:value
               placeHolder:placeHolder
                   pwdType:pwdType
                   maxSize:maxSize
               keyBoardNum:YES
                showSmsBtn:showSmsBtn
              showArrowBtn:NO
                 indexPath:indexPath];

        BOOL textFieldEnable = [[dic valueForKey:@"TextFieldEnable"] boolValue];
        [cell setValueTextFieldEnable:textFieldEnable];

        NSString* btnTitle = [dic valueForKey:@"SmsButtonTitle"];
        if (![GYUtils checkStringInvalid:btnTitle]) {
            [cell updateSMSTitle:btnTitle];
        }

        cell.cellDelegate = self;
        return cell;
    }
    else {
        GYHSLoginVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSPhoneBandingVC_CellBtnIdentify];
        [cell setCellName:name loginType:GYHSLoginViewControllerTypeNohsCard];
        [cell setCellBackground:kDefaultVCBackgroundColor];
        cell.cellDelegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - GYHSRegisterTableCellDelegate
- (void)buttonAction:(UIButton*)button indexPath:(NSIndexPath*)indexPath
{
    if (![GYUtils isMobileNumber:self.phoneNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Please_Enter_Legitimate_Mobile_Number")];
        return;
    }

    NSString* url = kSendMobileSmsUrlString;
    NSDictionary* paramDic = @{ @"mobile" : self.phoneNumber,
        @"custType" : @"1",
        @"custId" : globalData.loginModel.custId
    };

    [self.requestData sendSMSCode:url paramDic:paramDic button:button timeOut:120 resultBLock:^(BOOL result) {
        if (!result) {
            DDLogDebug(@"Failed to get sms code.");
        }
    }];
}

- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section != 0) {
        return;
    }

    NSInteger phoneRow = 0;
    NSInteger smsCodeRow = 1;
    NSInteger pwdRow = 2;

    if (phoneRow == indexPath.row) {
        self.phoneNumber = value;
    }
    else if (smsCodeRow == indexPath.row) {
        self.smsCode = value;
    }
    else if (pwdRow == indexPath.row) {
        self.loginPwd = value;
    }
}

#pragma mark - GYHSLoginVConfirmTableCellDelegate
- (void)confirmButtonAction
{
    if (![GYUtils isMobileNumber:self.phoneNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Please_Enter_Legitimate_Mobile_Number")];
        return;
    }

    if ([GYUtils checkStringInvalid:self.smsCode]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Please_Enter_Verification_Code")];
        return;
    }

    if ([GYUtils checkStringInvalid:self.loginPwd]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Please_Enter_Password")];
        return;
    }

    [self bindPhoneRequest];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];
    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        [GYUtils showMessage:@"GYHS_Banding_Return_Data_Parsing_Error" confirm:nil];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (netRequest.tag == kPhoneNumberBanding_Tag) {
        [self parsePhoneBindRequest:returnCode responseObject:responseObject];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - private methods
- (void)initView
{

    NSString* titleName = kLocalized(@"GYHS_Banding_Cell_Phone_Number_Binding");
    if (self.pageType == GYHSPhoneBandingVCPageModify) {
        titleName = kLocalized(@"GYHS_Banding_Modify_Banded_Phone");
    }

    self.title = titleName;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)hidenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (GYHSLoginModel*)loginModel
{
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

- (void)bindPhoneRequest
{
    GYHSLoginModel* model = [self loginModel];
    NSString* pwd = [self.loginPwd md5String16:model.custId];

    NSDictionary* paramDic = @{
        @"loginPwd" : pwd,
        @"userType" : model.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"smsCode" : self.smsCode,
        @"custId" : model.custId,
        @"mobile" : self.phoneNumber
    };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kPhoneNumberBandingUrlString parameters:paramDic requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = kPhoneNumberBanding_Tag;
    [request start];
    [GYGIFHUD show];
}

- (void)parsePhoneBindRequest:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{

    if (returnCode != 200) {
        DDLogDebug(@"The returnCode:%ld is not 200.", returnCode);
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Binding_Mobile_Phone_Number_Failed")];
        return;
    }

    GYHSLoginModel* model = [self loginModel];
    model.isAuthMobile = kAuthHad;
    model.mobile = self.phoneNumber;
    [[GYHSLoginManager shareInstance] saveLoginModel:model];

    [GYUtils showMessage:kLocalized(@"GYHS_Banding_Binding_Mobile_Phone_Number") confirm:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSRegisterTableCell" bundle:nil] forCellReuseIdentifier:kGYHSPhoneBandingVC_CellIdentify];
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSLoginVConfirmTableCell" bundle:nil] forCellReuseIdentifier:kGYHSPhoneBandingVC_CellBtnIdentify];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        NSMutableArray* infoAry = [NSMutableArray array];
        NSString* buttonName = kLocalized(@"GYHS_Banding_Confirm");

        if (self.pageType == GYHSPhoneBandingVCPageModify) {
            [infoAry addObject:@{
                @"Name" : kLocalized(@"GYHS_Banding_New_Phone_Number"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Banding_InputNewPhoneNumber"),
                @"maxSize" : [NSNumber numberWithInt:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"TextFieldEnable" : [NSNumber numberWithBool:YES],
                @"SmsButtonTitle" : @""
            }];

            buttonName = kLocalized(@"GYHS_Banding_ImmediatelyChange");
        }
        else {
            [infoAry addObject:@{ @"Name" : kLocalized(@"GYHS_Banding_Cell_Phone_Number"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Banding_InputMobilePhoneNumber"),
                @"maxSize" : [NSNumber numberWithInt:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"TextFieldEnable" : [NSNumber numberWithBool:YES],
                @"SmsButtonTitle" : @""
            }];
        }

        [infoAry addObject:@{ @"Name" : kLocalized(@"GYHS_Banding_SMS_Verification_code"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Banding_SMS_Verification_code"),
            @"maxSize" : [NSNumber numberWithInt:6],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:YES],
            @"TextFieldEnable" : [NSNumber numberWithBool:YES],
            @"SmsButtonTitle" : kLocalized(@"GYHS_Banding_Obtain")
        }];

        [infoAry addObject:@{ @"Name" : kLocalized(@"GYHS_Banding_Pwd"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Banding_Input_Login_Password"),
            @"maxSize" : [NSNumber numberWithInt:6],
            @"pwdType" : [NSNumber numberWithBool:YES],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"TextFieldEnable" : [NSNumber numberWithBool:YES],
            @"SmsButtonTitle" : @""
        }];

        [_dataArray addObject:infoAry];
        [_dataArray addObject:@[ @{ @"Name" : buttonName } ]];
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
