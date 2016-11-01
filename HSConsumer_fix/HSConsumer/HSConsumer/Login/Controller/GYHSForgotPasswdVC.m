//
//  GYHSForgotPasswdVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSForgotPasswdVC.h"
#import "MenuTabView.h"
#import "GYHSRegisterTableCell.h"
#import "GYNetRequest.h"
#import "GYHSQuestionModel.h"
#import "GYHSRequestData.h"
#import "GYHSNetworkAPI.h"
#import "GYHSResetPasswordVC.h"
#import "GYHSConstant.h"
#import "NSString+YYAdd.h"
#import "GYHSLoginManager.h"

#define kGYHSForgotPasswdVC_CellIdentify @"kGYHSForgotPasswdVC_CellIdentify"
#define kPwdQuestion_Tag 100
#define kFindPwdByPhone_Tag 101
#define kFindPwdByQuestion_Tag 102
#define kFindPwdByEmail_Tag 103

@interface GYHSForgotPasswdVC () <UITableViewDelegate, UITableViewDataSource, MenuTabViewDelegate, UIScrollViewDelegate, GYHSRegisterTableCellDelegate, GYNetRequestDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) GYHSRequestData* requestData;

@property (nonatomic, strong) NSMutableArray* menuDataAry;
@property (nonatomic, strong) MenuTabView* menuView;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, assign) NSInteger currentSelect;

@property (nonatomic, strong) UIView* phoneBGView;
@property (nonatomic, strong) UIView* pwdBGView;
@property (nonatomic, strong) UIView* emailBGView;

@property (nonatomic, strong) UITableView* phoneTableView;
@property (nonatomic, strong) UITableView* pwdTableView;
@property (nonatomic, strong) UITableView* emailTableView;

@property (nonatomic, strong) NSMutableArray* phoneArray;
@property (nonatomic, strong) NSMutableArray* pwdArray;
@property (nonatomic, strong) NSMutableArray* emailArray;

@property (nonatomic, strong) NSMutableArray* pwdQuestionArray;
@property (nonatomic, strong) NSIndexPath* pwdQuestionIndexPath;

@property (nonatomic, strong) NSString* phoneParamsHSNumber;
@property (nonatomic, strong) NSString* phoneParamsNumber;
@property (nonatomic, strong) NSString* phoneParamsSMSCode;

@property (nonatomic, strong) NSString* pwdParamsHSNumber;
@property (nonatomic, strong) NSString* pwdParamsQuestion;
@property (nonatomic, strong) NSString* pwdParamsAnswer;

@property (nonatomic, strong) NSString* emailParamsHSNumber;
@property (nonatomic, strong) NSString* emailParamsPhone;
@property (nonatomic, strong) NSString* emailParamsAdress;

@end

@implementation GYHSForgotPasswdVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];

    self.currentSelect = 0;
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        [self queryPwdQuestion];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.requestData clearTimer];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getDataAry:tableView] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    GYHSRegisterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSForgotPasswdVC_CellIdentify];

    NSMutableArray* resultAry = [self getDataAry:tableView];
    if (indexPath.row > [resultAry count]) {
        return nil;
    }
    NSDictionary* dic = resultAry[indexPath.row];
    NSString* value = [dic valueForKey:@"Value"];
    [self setCellValues:cell dataDic:dic value:value indexPath:indexPath];
    cell.cellDelegate = self;

    BOOL saveIndexPath = [[dic valueForKey:@"SaveIndexPath"] boolValue];
    if (saveIndexPath) {
        self.pwdQuestionIndexPath = indexPath;
    }

    return cell;
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    [self.view endEditing:YES];

    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index) {
        return;
    }

    CGFloat startX = self.scrollView.frame.size.width * index;
    [self.scrollView scrollRectToVisible:CGRectMake(startX,
                                             self.scrollView.frame.origin.y,
                                             self.scrollView.frame.size.width,
                                             self.scrollView.frame.size.height)
                                animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    CGFloat _x = scrollView.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(_x / self.view.frame.size.width);

    if (viewIndex < self.menuView.selectedIndex) {
        if (_x < self.menuView.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width) {
            [self.menuView updateMenu:viewIndex];
        }
    }
    else if (viewIndex == self.menuView.selectedIndex) {
        if (_x > self.menuView.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width) {
            [self.menuView updateMenu:viewIndex + 1];
        }
    }
    else {
        [self.menuView updateMenu:viewIndex];
    }

    self.currentSelect = viewIndex;
}

#pragma mark - GYHSRegisterTableCellDelegate
- (void)buttonAction:(UIButton*)button indexPath:(NSIndexPath*)indexPath
{
    DDLogDebug(@"%s", __FUNCTION__);
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        if (0 == self.currentSelect && indexPath.row == 2) {
            // 验证码
            if (![GYUtils isHSCardNo:self.phoneParamsHSNumber]) {
                [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_HS_Number11")];
                return;
            }

            if (![GYUtils isMobileNumber:self.phoneParamsNumber]) {
                [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Right_Iphone")];
                return;
            }

            NSDictionary* paramDic = @{ @"userName" : kSaftToNSString(self.phoneParamsHSNumber),
                @"mobile" : kSaftToNSString(self.phoneParamsNumber),
                @"userType" : kUserTypeCard,
                @"custType" : kCustTypeCard };

            [self sendSMSCoderRequest:kUrlSendCode paramDic:paramDic button:button];
        }
        else if (1 == self.currentSelect && indexPath.row == 1) {
            if ([self.pwdQuestionArray count] >= 3) {
                GYHSQuestionModel *model = self.pwdQuestionArray[0];
                NSString *qstOne = model.question;
                
                model = self.pwdQuestionArray[1];
                NSString *qstTwo = model.question;
                
                model = self.pwdQuestionArray[2];
                NSString *qstThree = model.question;
                
                UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:kLocalized(@"GYHS_Login_Choose_Encrypted_Problem")
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:qstOne, qstTwo, qstThree, nil];
                sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [sheet showInView:self.view];
            }
        }
    }
    else {
        if (0 == self.currentSelect && indexPath.row == 1) {
            // 验证码
            if (![GYUtils isMobileNumber:self.phoneParamsNumber]) {
                [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Right_Iphone")];
                return;
            }

            NSDictionary* paramDic = @{ @"userName" : kSaftToNSString(self.phoneParamsNumber),
                @"mobile" : kSaftToNSString(self.phoneParamsNumber),
                @"userType" : kUserTypeNoCard,
                @"custType" : kCustTypeNoCard
            };

            [self sendSMSCoderRequest:kUrlSendCode paramDic:paramDic button:button];
        }
    }
}

- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    // 保存手机找回密码参数
    if (0 == self.currentSelect) {
        [self savePhoneParams:value indexPath:indexPath];
    }

    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        // 有卡通过问题找回保存参数
        if (1 == self.currentSelect) {
            [self savePwdParams:value indexPath:indexPath];
        }
        // 有卡通过邮件找回
        else if (2 == self.currentSelect) {
            [self saveEmailParams:value indexPath:indexPath];
        }
    }
    else {
        if (1 == self.currentSelect) {
            // 无卡通过邮件找回，保存参数
            [self saveEmailParams:value indexPath:indexPath];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= [self.pwdQuestionArray count]) {
        [GYUtils showToast:kLocalized(@"参数错误！")];
        return;
    }
    
    GYHSQuestionModel *model = self.pwdQuestionArray[buttonIndex];
    [self updateSelectQuestion:model];
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

    if (netRequest.tag == kPwdQuestion_Tag) {
        [self parsePwdQuestion:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kFindPwdByPhone_Tag) {
        [self parseFindPwdByPhone:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kFindPwdByQuestion_Tag) {
        [self parseFindPwdByQuestion:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kFindPwdByEmail_Tag) {
        [self parseFindPwdByEmail:returnCode responseObject:responseObject];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
     DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - event response
- (void)confirmButtonAction
{
    [self.view endEditing:YES];
    
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        if (0 == self.currentSelect) {
            [self findPwdByPhone];
        }
        else if (1 == self.currentSelect) {
            [self findPwdByQuestion];
        }
        else if (2 == self.currentSelect) {
            [self findPwdByEmail];
        }
    }
    else {
        if (0 == self.currentSelect) {
            [self findPwdByPhone];
        }
        else if (1 == self.currentSelect) {
            [self findPwdByEmail];
        }
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Login_Method_For_Find_Pwd");
    self.view.backgroundColor = kDefaultVCBackgroundColor;

    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:kLocalized(@"GYHS_Login_Confirm") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    [self.view addSubview:self.menuView];

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.phoneBGView];
    [self.phoneBGView addSubview:self.phoneTableView];

    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        [self.scrollView addSubview:self.pwdBGView];
        [self.pwdBGView addSubview:self.pwdTableView];
    }

    [self.scrollView addSubview:self.emailBGView];
    [self.emailBGView addSubview:self.emailTableView];
}

- (NSMutableArray*)getDataAry:(UITableView*)tableView
{

    if (self.phoneTableView == tableView) {
        return self.phoneArray;
    }
    else if (self.pwdTableView == tableView) {
        return self.pwdArray;
    }
    else {
        return self.emailArray;
    }
}

- (void)queryPwdQuestion
{
    NSDictionary* paramDic = @{};

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlListPwdQuestion parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kPwdQuestion_Tag;
    [request start];
}

- (void)parsePwdQuestion:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Failed_To_Get_Data")];
        return;
    }

    for (NSDictionary* tempDict in responseObject[@"data"]) {
        GYHSQuestionModel* model = [[GYHSQuestionModel alloc] initWithDictionary:tempDict error:nil];
        [self.pwdQuestionArray addObject:model];
    }

    if ([self.pwdQuestionArray count] <= 0) {
        DDLogDebug(@"The pwdQuestionArray is zero.");
        return;
    }

    // 更新密码提示问题
    GYHSQuestionModel* model = [self.pwdQuestionArray firstObject];
    [self updateSelectQuestion:model];
}

- (void)updateSelectQuestion:(GYHSQuestionModel*)model
{
    self.pwdParamsQuestion = model.question;

    GYHSRegisterTableCell* cell = [self.pwdTableView cellForRowAtIndexPath:self.pwdQuestionIndexPath];
    NSDictionary* dic = self.pwdArray[self.pwdQuestionIndexPath.row];
    [self setCellValues:cell dataDic:dic value:model.question indexPath:self.pwdQuestionIndexPath];
}

- (void)setCellValues:(GYHSRegisterTableCell*)cell
              dataDic:(NSDictionary*)dataDic
                value:(NSString*)value
            indexPath:(NSIndexPath*)indexPath
{

    NSString* name = [dataDic valueForKey:@"Name"];
    NSString* placeHolder = [dataDic valueForKey:@"placeHolder"];
    BOOL pwdType = [[dataDic valueForKey:@"pwdType"] boolValue];
    BOOL showSmsBtn = [[dataDic valueForKey:@"showSmsBtn"] boolValue];
    BOOL showArrowBtn = [[dataDic valueForKey:@"showArrowBtn"] boolValue];
    BOOL keyBoardNum = [[dataDic valueForKey:@"keyBoardNum"] boolValue];
    NSInteger maxSize = [[dataDic valueForKey:@"maxSize"] integerValue];

    [cell setCellValue:name
                 value:value
           placeHolder:placeHolder
               pwdType:pwdType
               maxSize:maxSize
           keyBoardNum:keyBoardNum
            showSmsBtn:showSmsBtn
          showArrowBtn:showArrowBtn
             indexPath:indexPath];

    // 验证码添加边框
    if ([kLocalized(@"GYHS_Login_Verification_Code") isEqualToString:name]) {
        [cell updateSMSTitle:kLocalized(@"GYHS_Banding_Obtain")];
    }
}

- (void)savePhoneParams:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        if (0 == indexPath.row) {
            // 有卡互生号
            self.phoneParamsHSNumber = value;
        }
        else if (1 == indexPath.row) {
            // 有卡手机号
            self.phoneParamsNumber = value;
        }
        else if (2 == indexPath.row) {
            // 有卡验证码
            self.phoneParamsSMSCode = value;
        }
    }
    else {
        if (0 == indexPath.row) {
            // 无卡手机号
            self.phoneParamsNumber = value;
        }
        else if (1 == indexPath.row) {
            // 无卡验证码
            self.phoneParamsSMSCode = value;
        }
    }
}

- (void)savePwdParams:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        if (0 == indexPath.row) {
            // 有卡密码找回互生号
            self.pwdParamsHSNumber = value;
        }
        else if (2 == indexPath.row) {
            // 有卡密码找回答案
            self.pwdParamsAnswer = value;
        }
    }
}

- (void)saveEmailParams:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        if (0 == indexPath.row) {
            // 有卡邮箱找回互生号
            self.emailParamsHSNumber = value;
        }
        else if (1 == indexPath.row) {
            // 有卡邮箱找回邮箱号
            self.emailParamsAdress = value;
        }
    }
    else {
        if (0 == indexPath.row) {
            // 无卡邮箱找回输入手机号
            self.emailParamsPhone = value;
        }
        else if (1 == indexPath.row) {
            // 无卡邮箱找回邮箱号
            self.emailParamsAdress = value;
        }
    }
}

- (void)findPwdByPhone
{
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        if (![GYUtils isHSCardNo:self.phoneParamsHSNumber]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_HS_Number11")];
            return;
        }
    }

    if (![GYUtils isMobileNumber:self.phoneParamsNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Right_Iphone")];
        return;
    }

    if ([GYUtils checkStringInvalid:self.phoneParamsSMSCode]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Enter_Correct_Verification_Code")];
        return;
    }

    NSDictionary* parmaDic = @{ @"mobile" : kSaftToNSString(self.phoneParamsNumber),
        @"smsCode" : kSaftToNSString(self.phoneParamsSMSCode),
        @"userType" : kUserTypeNoCard
    };

    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        parmaDic = @{ @"mobile" : kSaftToNSString(self.phoneParamsNumber),
            @"smsCode" : kSaftToNSString(self.phoneParamsSMSCode) };
    }

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlCheckSmsCode parameters:parmaDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kFindPwdByPhone_Tag;
    [request start];
}

- (void)parseFindPwdByPhone:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Validation_Check_Operation_Failed")];
        return;
    }

    GYHSResetPasswordVC* vc = [[GYHSResetPasswordVC alloc] init];
    vc.loginType = self.loginType;
    vc.isFindPwdByPhone = YES;

    NSMutableDictionary* tmpDic = [NSMutableDictionary dictionary];
    NSString* hasCard = kUserTypeCard;

    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        [tmpDic setObject:kSaftToNSString(self.phoneParamsHSNumber) forKey:@"hsResNo"];
        hasCard = kUserTypeCard;
    }
    else {
        [tmpDic setObject:kSaftToNSString(self.phoneParamsNumber) forKey:@"hsResNo"];
        hasCard = kUserTypeNoCard;
    }

    [tmpDic setObject:kSaftToNSString(self.phoneParamsSMSCode) forKey:@"smsCode"];
    [tmpDic setObject:kSaftToNSString(self.phoneParamsNumber) forKey:@"mobile"];
    [tmpDic setObject:hasCard forKey:@"userType"];
    [tmpDic setObject:@"" forKey:@"newLoginPwd"];

    vc.pwdByPhoneDic = tmpDic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)findPwdByQuestion
{
    if (![GYUtils isHSCardNo:self.pwdParamsHSNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_HS_Number11")];
        return;
    }

    if ([GYUtils checkStringInvalid:self.pwdParamsQuestion]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Question")];
        return;
    }

    if ([GYUtils checkStringInvalid:self.pwdParamsAnswer]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Input_Answer")];
        return;
    }

    NSDictionary* paramDic = @{
        @"answer" : kSaftToNSString(self.pwdParamsAnswer.md5String),
        @"question" : kSaftToNSString(self.pwdParamsQuestion),
        @"userType" : kUserTypeCard,
        @"resNo" : kSaftToNSString(self.pwdParamsHSNumber),
    };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlCheckPwdQuestion parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kFindPwdByQuestion_Tag;
    [request start];
}

- (void)parseFindPwdByQuestion:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [GYUtils showMessage:kErrorMsg];
        return;
    }

    NSString* result = responseObject[@"data"][@"result"];
    NSString* custId = responseObject[@"data"][@"custId"];
    result = [GYUtils saftToNSString:result];
    custId = [GYUtils saftToNSString:custId];

    GYHSResetPasswordVC* vc = [[GYHSResetPasswordVC alloc] init];
    vc.loginType = self.loginType;
    vc.isFindPwdByPhone = NO;

    NSMutableDictionary* tmpDic = [NSMutableDictionary dictionary];
    [tmpDic setObject:result forKey:@"result"];
    [tmpDic setObject:custId forKey:@"custId"];
    [tmpDic setObject:kUserTypeCard forKey:@"userType"];
    [tmpDic setObject:@"" forKey:@"newLoginPwd"];
    vc.pwdByQuestionDic = tmpDic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)findPwdByEmail
{
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        if (![GYUtils isHSCardNo:self.emailParamsHSNumber]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_HS_Number11")];
            return;
        }
    }
    else {
        if (![GYUtils isMobileNumber:self.emailParamsPhone]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Right_Iphone")];
            return;
        }
    }

    if (![GYUtils isValidateEmail:self.emailParamsAdress]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_Please_Input_Right_Email")];
        return;
    }

    NSDictionary* paramDic = nil;
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        paramDic = @{ @"userName" : self.emailParamsHSNumber,
            @"email" : self.emailParamsAdress,
            @"userType" : kUserTypeCard,
            @"custType" : kCustTypeCard };
    }
    else {
        paramDic = @{ @"userName" : kSaftToNSString(self.emailParamsPhone),
            @"email" : kSaftToNSString(self.emailParamsAdress),
            @"userType" : kUserTypeNoCard,
            @"custType" : kCustTypeNoCard };
    }

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlSendEmail parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kFindPwdByEmail_Tag;
    [request start];
}

- (void)parseFindPwdByEmail:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode == 654) {
        [GYUtils showMessage:kLocalized(@"GYHS_Login_MailboxNoExist")];
        return;
    }

    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [GYUtils showMessage:kErrorMsg];
        return;
    }

    NSString* message = [NSString stringWithFormat:@"%@:%@\n%@",
                                  kLocalized(@"GYHS_Login_Verify_Email_Has_Sent"),
                                  self.emailParamsAdress,
                                  kLocalized(@"GYHS_Login_PleaseLogMailboxRetrievePpassword")];
    WS(weakSelf)
        [GYUtils showMessage:message confirm:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
}

- (void)sendSMSCoderRequest:(NSString*)url
                   paramDic:(NSDictionary*)paramDic
                     button:(UIButton*)button
{
    [self.requestData sendSMSCode:url
                         paramDic:paramDic
                           button:button
                          timeOut:120
                      resultBLock:^(BOOL result) {
        if (!result) {
            [GYUtils showMessage:kLocalized(@"GYHS_Login_Failed_To_Get_Data")];
        }
                      }];
}

#pragma mark - getter and setter
- (GYHSRequestData*)requestData
{
    if (_requestData == nil) {
        _requestData = [[GYHSRequestData alloc] init];
    }

    return _requestData;
}

- (NSMutableArray*)menuDataAry
{
    if (_menuDataAry == nil) {
        _menuDataAry = [NSMutableArray array];
        [_menuDataAry addObject:kLocalized(@"GYHS_Login_Phone_Number")];

        if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
            [_menuDataAry addObject:kLocalized(@"GYHS_Login_Pwd_Prompt_Question")];
        }

        [_menuDataAry addObject:kLocalized(@"GYHS_Login_Email")];
    }

    return _menuDataAry;
}

- (MenuTabView*)menuView
{
    if (_menuView == nil) {
        _menuView = [[MenuTabView alloc] initMenuWithTitles:self.menuDataAry withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
        _menuView.delegate = self;
    }

    return _menuView;
}

- (UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40)];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setContentSize:CGSizeMake(kScreenWidth * [self.menuDataAry count], kScreenHeight - 40)];
        [_scrollView setBackgroundColor:kDefaultVCBackgroundColor];
        _scrollView.delegate = self;
    }

    return _scrollView;
}

- (UIView*)phoneBGView
{
    if (_phoneBGView == nil) {
        CGRect vFrame = self.scrollView.bounds;
        vFrame.origin.x = 0;
        _phoneBGView = [[UIView alloc] initWithFrame:vFrame];
        _phoneBGView.backgroundColor = kDefaultVCBackgroundColor;
    }

    return _phoneBGView;
}

- (UIView*)pwdBGView
{
    if (_pwdBGView == nil) {
        CGRect vFrame = self.scrollView.bounds;
        vFrame.origin.x += kScreenWidth;
        _pwdBGView = [[UIView alloc] initWithFrame:vFrame];
        _pwdBGView.backgroundColor = kDefaultVCBackgroundColor;
    }

    return _pwdBGView;
}

- (UIView*)emailBGView
{
    if (_emailBGView == nil) {
        CGRect vFrame = self.scrollView.bounds;

        if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
            vFrame.origin.x += kScreenWidth * 2;
        }
        else {
            vFrame.origin.x += kScreenWidth;
        }
        _emailBGView = [[UIView alloc] initWithFrame:vFrame];
        _emailBGView.backgroundColor = kDefaultVCBackgroundColor;
    }

    return _emailBGView;
}

- (UITableView*)phoneTableView
{
    if (_phoneTableView == nil) {
        _phoneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight - 15) style:UITableViewStylePlain];
        _phoneTableView.backgroundColor = kDefaultVCBackgroundColor;
        _phoneTableView.delegate = self;
        _phoneTableView.dataSource = self;
        _phoneTableView.scrollEnabled = NO;
        [_phoneTableView registerNib:[UINib nibWithNibName:@"GYHSRegisterTableCell" bundle:nil] forCellReuseIdentifier:kGYHSForgotPasswdVC_CellIdentify];
    }

    return _phoneTableView;
}

- (UITableView*)pwdTableView
{
    if (_pwdTableView == nil) {
        _pwdTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight - 15) style:UITableViewStylePlain];
        _pwdTableView.backgroundColor = kDefaultVCBackgroundColor;
        _pwdTableView.delegate = self;
        _pwdTableView.dataSource = self;
        _pwdTableView.scrollEnabled = NO;
        [_pwdTableView registerNib:[UINib nibWithNibName:@"GYHSRegisterTableCell" bundle:nil] forCellReuseIdentifier:kGYHSForgotPasswdVC_CellIdentify];
    }

    return _pwdTableView;
}

- (UITableView*)emailTableView
{
    if (_emailTableView == nil) {
        _emailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight - 15) style:UITableViewStylePlain];
        _emailTableView.backgroundColor = kDefaultVCBackgroundColor;
        _emailTableView.delegate = self;
        _emailTableView.dataSource = self;
        _emailTableView.scrollEnabled = NO;
        [_emailTableView registerNib:[UINib nibWithNibName:@"GYHSRegisterTableCell" bundle:nil] forCellReuseIdentifier:kGYHSForgotPasswdVC_CellIdentify];
    }

    return _emailTableView;
}

- (NSMutableArray*)phoneArray
{
    if (_phoneArray == nil) {
        _phoneArray = [NSMutableArray array];

        if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
            [_phoneArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Hs_Card_Number"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Enter_11_Number"),
                @"maxSize" : [NSNumber numberWithInteger:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"showArrowBtn" : [NSNumber numberWithBool:NO],
                @"keyBoardNum" : [NSNumber numberWithBool:YES]
            }];
        }

        [_phoneArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Phone_Numbers"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Please_Input_Phone_Number"),
            @"maxSize" : [NSNumber numberWithInteger:11],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:YES]
        }];

        [_phoneArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Verification_Code"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Input_Verification_Code"),
            @"maxSize" : [NSNumber numberWithInteger:6],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:YES],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:YES]
        }];
    }

    return _phoneArray;
}

- (NSMutableArray*)pwdArray
{
    if (_pwdArray == nil) {
        _pwdArray = [NSMutableArray array];

        [_pwdArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Hs_Card_Number"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Enter_11_Number"),
            @"maxSize" : [NSNumber numberWithInteger:11],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:YES]
        }];

        [_pwdArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Question"),
            @"Value" : @"",
            @"placeHolder" : @"",
            @"maxSize" : [NSNumber numberWithInteger:50],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:YES],
            @"keyBoardNum" : [NSNumber numberWithBool:NO],
            @"SaveIndexPath" : [NSNumber numberWithBool:YES]
        }];

        [_pwdArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Answer"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Input_Answer"),
            @"maxSize" : [NSNumber numberWithInteger:50],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:NO]
        }];
    }

    return _pwdArray;
}

- (NSMutableArray*)emailArray
{
    if (_emailArray == nil) {
        _emailArray = [NSMutableArray array];

        if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
            [_emailArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Hs_Card_Number"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Enter_11_Number"),
                @"maxSize" : [NSNumber numberWithInteger:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"showArrowBtn" : [NSNumber numberWithBool:NO],
                @"keyBoardNum" : [NSNumber numberWithBool:YES]
            }];
        }
        else {
            [_emailArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Phone_Numbers"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Please_Input_Phone_Number"),
                @"maxSize" : [NSNumber numberWithInteger:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"showArrowBtn" : [NSNumber numberWithBool:NO],
                @"keyBoardNum" : [NSNumber numberWithBool:YES]
            }];
        }

        [_emailArray addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Email"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Input_Email_Code"),
            @"maxSize" : [NSNumber numberWithInteger:50],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:NO]
        }];
    }
    
    return _emailArray;
}

- (NSMutableArray *) pwdQuestionArray {
    if (_pwdQuestionArray == nil) {
        _pwdQuestionArray = [NSMutableArray array];
    }
    
    return _pwdQuestionArray;
}

@end