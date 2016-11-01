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
#import "GYHSLoginVConfirmTableCell.h"
#import "Masonry.h"
#import "GYHSPopView.h"
#import "GYBaseControlView.h"

#define kGYHSForgotPasswdVC_CellIdentify @"kGYHSForgotPasswdVC_CellIdentify"
#define kPwdQuestion_Tag 100
#define kFindPwdByPhone_Tag 101
#define kFindPwdByQuestion_Tag 102
#define kFindPwdByEmail_Tag 103

@interface GYHSForgotPasswdVC () <UITableViewDelegate, UITableViewDataSource, MenuTabViewDelegate, UIScrollViewDelegate, GYHSRegisterTableCellDelegate, GYNetRequestDelegate, GYHSLoginVConfirmTableCellDelegate>
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
@property (nonatomic, assign) BOOL isSendSMSCode;

@property (nonatomic, strong) NSString* pwdParamsHSNumber;
@property (nonatomic, strong) NSString* pwdParamsQuestion;
@property (nonatomic, strong) NSString* pwdParamsAnswer;

@property (nonatomic, strong) NSString* emailParamsHSNumber;
@property (nonatomic, strong) NSString* emailParamsPhone;
@property (nonatomic, strong) NSString* emailParamsAdress;

@property (nonatomic, strong) NSString* pwdSelectName;

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
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [[self getDataAry:tableView] count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* tmpAry = [self getDataAry:tableView];
    return [tmpAry[section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    NSMutableArray* resultAry = [self getDataAry:tableView];
    if (indexPath.section > [resultAry count]) {
        return nil;
    }
    NSDictionary* dic = resultAry[indexPath.section][indexPath.row];

    if (indexPath.section == 0) {
        GYHSRegisterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSForgotPasswdVC_CellIdentify];

        NSString* value = [dic valueForKey:@"Value"];
        [self setCellValues:cell dataDic:dic value:value indexPath:indexPath];
        cell.cellDelegate = self;

        BOOL saveIndexPath = [[dic valueForKey:@"SaveIndexPath"] boolValue];
        if (saveIndexPath) {
            self.pwdQuestionIndexPath = indexPath;
        }

        return cell;
    }
    else {
        GYHSLoginVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLoginVConfirmTableCell"];

        NSString* name = [dic valueForKey:@"Name"];
        [cell setCellName:name loginType:self.pageType];
        cell.cellDelegate = self;

        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
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
    if (indexPath.section != 0) {
        DDLogDebug(@"The section:%ld is not 0", indexPath.section);
        return;
    }

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
                GYHSQuestionModel* model = self.pwdQuestionArray[0];
                NSString* qstOne = model.question;

                model = self.pwdQuestionArray[1];
                NSString* qstTwo = model.question;

                model = self.pwdQuestionArray[2];
                NSString* qstThree = model.question;

                if ([GYUtils checkStringInvalid:self.pwdSelectName]) {
                    self.pwdSelectName = qstOne;
                }

                NSArray* nameAry = @[ qstOne, qstTwo, qstThree ];
                CGRect rectTableView = [self.pwdTableView rectForRowAtIndexPath:indexPath];
                CGRect rect = [self.pwdTableView convertRect:rectTableView toView:[self.pwdTableView superview]];

                // 屏幕 - 弹出框宽度 - 调整值
                CGFloat popX = kScreenWidth - [GYUtils sizeForString:qstTwo font:[UIFont systemFontOfSize:14] width:200].width - 100;

                // 屏幕的中间 + 相对偏移坐标（rect）+ tabBar高度
                CGPoint point = CGPointMake(popX, rect.origin.y + (kScreenHeight - 300) / 2 + 48);
                GYBaseControlView* pop = [[GYBaseControlView alloc] initWithPoint:point titles:nameAry images:nil width:self.view.frame.size.width - popX selectName:self.pwdSelectName];

                WS(weakSelf)
                pop.selectRowAtIndex = ^(NSInteger index) {
                    if (index >= [weakSelf.pwdQuestionArray count]) {
                        [GYUtils showToast:kLocalized(@"参数错误！")];
                        return;
                    }
                    
                    GYHSQuestionModel* model = self.pwdQuestionArray[index];
                    weakSelf.pwdSelectName = model.question;
                    [weakSelf updateSelectQuestion:model];
                };
                [pop show];
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

#pragma mark - GYHSLoginVConfirmTableCellDelegate
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
    self.title = @"";
    self.view.backgroundColor = kDefaultVCBackgroundColor;
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

    [self.menuView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(self.view.frame.size.height);
        make.width.mas_equalTo(self.view.frame.size.width);
    }];

    self.isSendSMSCode = NO;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    CGRect phoneFrame = self.view.bounds;
    phoneFrame.origin.x = 0;
    self.phoneBGView.frame = phoneFrame;
    self.phoneTableView.frame = phoneFrame;

    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        CGRect pwdFrame = self.view.bounds;
        pwdFrame.origin.x += self.view.frame.size.width;
        self.pwdBGView.frame = pwdFrame;
        self.pwdTableView.frame = phoneFrame;
    }

    CGRect emailFrame = self.view.bounds;
    if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
        emailFrame.origin.x += self.view.frame.size.width * 2;
    }
    else {
        emailFrame.origin.x += self.view.frame.size.width;
    }
    self.emailBGView.frame = emailFrame;
    self.emailTableView.frame = phoneFrame;

    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * [self.menuDataAry count], kScreenHeight - 40)];
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
    NSDictionary* dic = self.pwdArray[self.pwdQuestionIndexPath.section][self.pwdQuestionIndexPath.row];
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
    if ([kLocalized(@"GYHS_Login_SMS_Verification_Code") isEqualToString:name]) {
        [cell updateSMSTitle:kLocalized(@"GYHS_Banding_Obtain")];
    }

    if (showArrowBtn) {
        [cell changeArrowImage:@"gy_hd_red_down_arrow"];
    }
}

- (void)savePhoneParams:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section != 0) {
        DDLogDebug(@"The section:%ld is not 0", indexPath.section);
        return;
    }

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
    if (indexPath.section != 0) {
        DDLogDebug(@"The section:%ld is not 0", indexPath.section);
        return;
    }

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
    if (indexPath.section != 0) {
        DDLogDebug(@"The section:%ld is not 0", indexPath.section);
        return;
    }

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

    if (!self.isSendSMSCode) {
        [GYUtils showMessage:kLocalized(@"请获取验证码")];
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

    if ([self.delegate respondsToSelector:@selector(toRestPwdPage:dataDic:)]) {
        [self.delegate toRestPwdPage:YES dataDic:tmpDic];
    }
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

    NSMutableDictionary* tmpDic = [NSMutableDictionary dictionary];
    [tmpDic setObject:result forKey:@"result"];
    [tmpDic setObject:custId forKey:@"custId"];
    [tmpDic setObject:kUserTypeCard forKey:@"userType"];
    [tmpDic setObject:@"" forKey:@"newLoginPwd"];

    if ([self.delegate respondsToSelector:@selector(toRestPwdPage:dataDic:)]) {
        [self.delegate toRestPwdPage:NO dataDic:tmpDic];
    }
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

    UIView* view = [self addEmailView:message];
    [self.emailBGView addSubview:view];
}

- (UIView*)addEmailView:(NSString*)message
{
    UIView* successView = [[UIView alloc] initWithFrame:self.emailTableView.bounds];
    successView.backgroundColor = [UIColor whiteColor];

    UIButton* emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emailBtn.frame = successView.bounds;
    [emailBtn addTarget:self action:@selector(emailFindPwdAction:) forControlEvents:UIControlEventTouchUpInside];

    UILabel* titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 42)];
    [successView addSubview:emailBtn];
    titleLable.textColor = kBlackTextColor;

    NSRange range = [message rangeOfString:kLocalized(@"登录邮箱")];
    if (range.location == NSNotFound) {
        titleLable.text = message;
    }
    else {
        NSMutableAttributedString* strAttribute = [[NSMutableAttributedString alloc] initWithString:message];
        [strAttribute addAttribute:NSForegroundColorAttributeName value:kPvBlueColor range:range];
        titleLable.attributedText = strAttribute;
    }

    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:14];
    titleLable.numberOfLines = 0;
    [successView addSubview:titleLable];

    return successView;
}

- (void)emailFindPwdAction:(UIButton*)button
{
    NSString* url = @"http://www.gyist.com/";
    NSRange flagRange = [self.emailParamsAdress rangeOfString:@"@"];

    if (flagRange.location != NSNotFound) {
        NSString* hostUrl = [self.emailParamsAdress substringFromIndex:flagRange.location + 1];
        url = [NSString stringWithFormat:@"http://email.%@", hostUrl];
    }

    DDLogDebug(@"open url:%@", url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)sendSMSCoderRequest:(NSString*)url
                   paramDic:(NSDictionary*)paramDic
                     button:(UIButton*)button
{
    WS(weakSelf)
        [self.requestData sendSMSCode:url
                             paramDic:paramDic
                               button:button
                              timeOut:120
                          resultBLock:^(BOOL result) {
        if (!result) {
            [GYUtils showMessage:kLocalized(@"GYHS_Login_Failed_To_Get_Data")];
        }
        else {
            weakSelf.isSendSMSCode = YES;
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
        [_menuDataAry addObject:kLocalized(@"手机号找回")];

        if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
            [_menuDataAry addObject:kLocalized(@"密保问题找回")];
        }

        [_menuDataAry addObject:kLocalized(@"邮箱找回")];
    }

    return _menuDataAry;
}

- (MenuTabView*)menuView
{
    if (_menuView == nil) {
        _menuView = [[MenuTabView alloc] initMenuWithTitles:self.menuDataAry withFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) isShowSeparator:YES];
        _menuView.delegate = self;
    }

    return _menuView;
}

- (UIScrollView*)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, kScreenHeight - 40)];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * [self.menuDataAry count], kScreenHeight - 40)];
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
        vFrame.origin.x += self.view.frame.size.width;
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
            vFrame.origin.x += self.view.frame.size.width * 2;
        }
        else {
            vFrame.origin.x += self.view.frame.size.width;
        }
        _emailBGView = [[UIView alloc] initWithFrame:vFrame];
        _emailBGView.backgroundColor = kDefaultVCBackgroundColor;
    }

    return _emailBGView;
}

- (UITableView*)phoneTableView
{
    if (_phoneTableView == nil) {
        _phoneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStyleGrouped];
        _phoneTableView.backgroundColor = [UIColor whiteColor];
        _phoneTableView.delegate = self;
        _phoneTableView.dataSource = self;
        _phoneTableView.scrollEnabled = NO;
        [_phoneTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSRegisterTableCell class]) bundle:nil] forCellReuseIdentifier:kGYHSForgotPasswdVC_CellIdentify];
        [_phoneTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLoginVConfirmTableCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLoginVConfirmTableCell"];
    }

    return _phoneTableView;
}

- (UITableView*)pwdTableView
{
    if (_pwdTableView == nil) {
        _pwdTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStyleGrouped];
        _pwdTableView.backgroundColor = [UIColor whiteColor];
        _pwdTableView.delegate = self;
        _pwdTableView.dataSource = self;
        _pwdTableView.scrollEnabled = NO;
        [_pwdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSRegisterTableCell class]) bundle:nil] forCellReuseIdentifier:kGYHSForgotPasswdVC_CellIdentify];
        [_pwdTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLoginVConfirmTableCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLoginVConfirmTableCell"];
    }

    return _pwdTableView;
}

- (UITableView*)emailTableView
{
    if (_emailTableView == nil) {
        _emailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40) style:UITableViewStyleGrouped];
        _emailTableView.backgroundColor = [UIColor whiteColor];
        _emailTableView.delegate = self;
        _emailTableView.dataSource = self;
        _emailTableView.scrollEnabled = NO;
        [_emailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSRegisterTableCell class]) bundle:nil] forCellReuseIdentifier:kGYHSForgotPasswdVC_CellIdentify];
        [_emailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLoginVConfirmTableCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLoginVConfirmTableCell"];
    }

    return _emailTableView;
}

- (NSMutableArray*)phoneArray
{
    if (_phoneArray == nil) {
        _phoneArray = [NSMutableArray array];
        NSMutableArray* tmpAry = [NSMutableArray array];

        if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
            [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Hs_Card_Number"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Enter_Hs_Number"),
                @"maxSize" : [NSNumber numberWithInteger:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"showArrowBtn" : [NSNumber numberWithBool:NO],
                @"keyBoardNum" : [NSNumber numberWithBool:YES]
            }];
        }

        [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Phone_Numbers"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Please_Input_Phone_Number"),
            @"maxSize" : [NSNumber numberWithInteger:11],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:YES]
        }];

        [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_SMS_Verification_Code"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"输入短信验证码"),
            @"maxSize" : [NSNumber numberWithInteger:6],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:YES],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:YES]
        }];
        [_phoneArray addObject:tmpAry];
        [_phoneArray addObject:@[ @{ @"Name" : kLocalized(@"下一步") } ]];
    }

    return _phoneArray;
}

- (NSMutableArray*)pwdArray
{
    if (_pwdArray == nil) {
        _pwdArray = [NSMutableArray array];
        NSMutableArray* tmpAry = [NSMutableArray array];

        [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Hs_Card_Number"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Enter_Hs_Number"),
            @"maxSize" : [NSNumber numberWithInteger:11],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:YES]
        }];

        [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Question"),
            @"Value" : @"",
            @"placeHolder" : @"",
            @"maxSize" : [NSNumber numberWithInteger:50],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:YES],
            @"keyBoardNum" : [NSNumber numberWithBool:NO],
            @"SaveIndexPath" : [NSNumber numberWithBool:YES]
        }];

        [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Answer"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Input_Answer"),
            @"maxSize" : [NSNumber numberWithInteger:50],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:NO]
        }];

        [_pwdArray addObject:tmpAry];
        [_pwdArray addObject:@[ @{ @"Name" : kLocalized(@"下一步") } ]];
    }

    return _pwdArray;
}

- (NSMutableArray*)emailArray
{
    if (_emailArray == nil) {
        _emailArray = [NSMutableArray array];
        NSMutableArray* tmpAry = [NSMutableArray array];

        if (self.loginType == GYHSLoginViewControllerTypeHashsCard) {
            [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Hs_Card_Number"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Enter_Hs_Number"),
                @"maxSize" : [NSNumber numberWithInteger:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"showArrowBtn" : [NSNumber numberWithBool:NO],
                @"keyBoardNum" : [NSNumber numberWithBool:YES]
            }];
        }
        else {
            [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Phone_Numbers"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"GYHS_Login_Please_Input_Phone_Number"),
                @"maxSize" : [NSNumber numberWithInteger:11],
                @"pwdType" : [NSNumber numberWithBool:NO],
                @"showSmsBtn" : [NSNumber numberWithBool:NO],
                @"showArrowBtn" : [NSNumber numberWithBool:NO],
                @"keyBoardNum" : [NSNumber numberWithBool:YES]
            }];
        }

        [tmpAry addObject:@{ @"Name" : kLocalized(@"GYHS_Login_Email"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"GYHS_Login_Input_Email_Code"),
            @"maxSize" : [NSNumber numberWithInteger:50],
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"showSmsBtn" : [NSNumber numberWithBool:NO],
            @"showArrowBtn" : [NSNumber numberWithBool:NO],
            @"keyBoardNum" : [NSNumber numberWithBool:NO]
        }];

        [_emailArray addObject:tmpAry];
        [_emailArray addObject:@[ @{ @"Name" : kLocalized(@"下一步") } ]];
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