//
//  GYHSUserRegisterVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSUserRegisterVC.h"
#import "GYHSRegisterTableCell.h"
#import "GYHSLoginVConfirmTableCell.h"
#import "GYNetRequest.h"
#import "GYHSRequestData.h"
#import "GYHSConstant.h"
#import "NSString+GYExtension.h"

#define kGYHSUserRegisterVC_CellIdentify @"kGYHSUserRegisterVC_CellIdentify"
#define kGYHSUserRegisterVC_Cell_Button_Identify @"kGYHSUserRegisterVC_Cell_Button_Identify"

#define kConfirmRegister_Tag 100

@interface GYHSUserRegisterVC () <UITableViewDelegate, UITableViewDataSource, GYHSRegisterTableCellDelegate, GYHSLoginVConfirmTableCellDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) NSString* smsCode;
@property (nonatomic, strong) NSString* passwrod;
@property (nonatomic, strong) NSString* confirmPwd;

@property (nonatomic, strong) GYHSRequestData* requestData;

@end

@implementation GYHSUserRegisterVC

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

- (void)dealloc
{
    [self.requestData clearTimer];
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
        GYHSRegisterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSUserRegisterVC_CellIdentify];

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

        cell.cellDelegate = self;
        return cell;
    }
    else {
        GYHSLoginVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSUserRegisterVC_Cell_Button_Identify];
        [cell setCellName:name loginType:GYHSLoginViewControllerTypeHashsCard];
        cell.cellDelegate = self;

        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - GYHSRegisterTableCellDelegate
- (void)buttonAction:(UIButton*)button indexPath:(NSIndexPath*)indexPath
{
    if ([GYUtils checkStringInvalid:self.phoneNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Phone_Number")];
        return;
    }

    if (self.phoneNumber.length < 11) {
        [GYUtils showMessage:kLocalized(@"请输入合法手机号")];
        return;
    }

    if (![GYUtils isMobileNumber:self.phoneNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Right_Iphone")];
        return;
    }

    NSDictionary* paramDic = @{ @"mobile" : kSaftToNSString(self.phoneNumber),
        @"custType" : kCustTypeNoCard };

    [self.requestData sendSMSCode:kUrlSendSmsCode paramDic:paramDic button:button timeOut:120 resultBLock:^(BOOL result) {
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

    if (indexPath.row == 0) {
        self.phoneNumber = value;
    }
    else if (indexPath.row == 1) {
        self.smsCode = value;
    }
    else if (indexPath.row == 2) {
        self.passwrod = value;
    }
    else if (indexPath.row == 3) {
        self.confirmPwd = value;
    }
}

#pragma mark - GYHSLoginVConfirmTableCellDelegate
- (void)confirmButtonAction
{
    if ([GYUtils checkStringInvalid:self.phoneNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Phone_Number")];
        return;
    }

    if (![GYUtils isMobileNumber:self.phoneNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Right_Iphone")];
        return;
    }

    if ([GYUtils checkStringInvalid:self.smsCode] || self.smsCode.length != 6) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Enter_Correct_Verification_Code")];
        return;
    }

    if ([GYUtils checkStringInvalid:self.passwrod] ||
        [GYUtils checkStringInvalid:self.confirmPwd]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Input_Password")];
        return;
    }

    if (![self.passwrod isEqualToString:self.confirmPwd]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Password_Not_Agree")];
        return;
    }

    if (self.passwrod.length != 6) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_6_Password")];
        return;
    }

    NSString* aesPwd = [self.passwrod md5String16:self.phoneNumber];
    NSDictionary* paramDic = @{ @"mobile" : kSaftToNSString(self.phoneNumber),
        @"loginPwd" : kSaftToNSString(aesPwd),
        @"smsCode" : self.smsCode };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlRegister parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kConfirmRegister_Tag;
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        DDLogDebug(@"This responseObject is invalid.");
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Failed_To_Get_Data")];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (netRequest.tag == kConfirmRegister_Tag) {
        [self parseConfirmRegister:returnCode responseObject:responseObject];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Login_Registe");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)parseConfirmRegister:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode == 200) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Registered_Successed") confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    //验证码不正确
    else if (returnCode == 617) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Validation_Error")];
    }
    //帐户已存在
    else if (returnCode == 657) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Existing_Account")];
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Failed_Registered")];
    }
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];

        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        UILabel* headLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
        [headView addSubview:headLable];
        headLable.text = kLocalized(@"GYHS_Login_Please_Input_Phone_Number");
        headLable.textAlignment = NSTextAlignmentCenter;
        [headLable setFont:[UIFont systemFontOfSize:20]];
        headLable.textColor = kBlackTextColor;
        _tableView.scrollEnabled = NO;
        //_tableView.tableHeaderView = headView;

        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSRegisterTableCell" bundle:nil] forCellReuseIdentifier:kGYHSUserRegisterVC_CellIdentify];
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSLoginVConfirmTableCell" bundle:nil] forCellReuseIdentifier:kGYHSUserRegisterVC_Cell_Button_Identify];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        [_dataArray addObject:@[
            @{ @"Name" : kLocalized(@"GYHS_Login_Phone_Number"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Input_Phone_Number"),
                @"maxSize" : [NSNumber numberWithInteger:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO]
            },
            @{ @"Name" : kLocalized(@"GYHS_Login_Verification_Code"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Input_Verification_Code"),
                @"maxSize" : [NSNumber numberWithInteger:6],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:YES]
            },

            @{ @"Name" : kLocalized(@"GYHS_Login_Password"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Input_Password"),
                @"maxSize" : [NSNumber numberWithInteger:6],
                @"pwdType" : [NSNumber numberWithBool:YES],
                @"showSmsBtn" : [NSNumber numberWithBool:NO]
            },
            @{ @"Name" : kLocalized(@"GYHS_Login_Confirm_Pwd"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Input_Pwd_Repeat"),
                @"maxSize" : [NSNumber numberWithInteger:6],
                @"pwdType" : [NSNumber numberWithBool:YES],
                @"showSmsBtn" : [NSNumber numberWithBool:NO]
            }
        ]];

        [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"GYHS_Login_Registe") } ]];
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
