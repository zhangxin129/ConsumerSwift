//
//  GYHSResetPasswordVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSResetPasswordVC.h"
#import "GYHSRegisterTableCell.h"
#import "GYHSLoginVConfirmTableCell.h"
#import "GYNetRequest.h"
#import "GYHSLoginViewController.h"
#import "GYHSConstant.h"
#import "GYHSLoginManager.h"
#import "NSString+GYExtension.h"

#define kGYHSResetPasswordVC_CellIdentify @"kGYHSResetPasswordVC_CellIdentify"
#define kGYHSResetPasswordVC_CellTipInfoIdentify @"kGYHSResetPasswordVC_CellTipInfoIdentify"
#define kGYHSResetPasswordVC_Cell_BtnIdentify @"kGYHSResetPasswordVC_Cell_BtnIdentify"

#define kResetLoginPwdByPhoneFind_Tag 100
#define kResetLoginPwdByQuestionFind_Tag 101

@interface GYHSResetPasswordVC () <UITableViewDelegate, UITableViewDataSource, GYHSRegisterTableCellDelegate, GYHSLoginVConfirmTableCellDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* pwdAgain;

@end

@implementation GYHSResetPasswordVC

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
        GYHSRegisterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSResetPasswordVC_CellIdentify];
        NSString* value = [dic valueForKey:@"Value"];
        NSString* placeHolder = [dic valueForKey:@"placeHolder"];

        [cell setCellValue:name
                     value:value
               placeHolder:placeHolder
                   pwdType:YES
                   maxSize:6
               keyBoardNum:YES
                showSmsBtn:NO
              showArrowBtn:NO
                 indexPath:indexPath];
        cell.cellDelegate = self;
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSResetPasswordVC_CellTipInfoIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSResetPasswordVC_CellTipInfoIdentify];
            cell.backgroundColor = kDefaultVCBackgroundColor;
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.textLabel setTextColor:kgrayTextColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.textLabel.text = name;
        return cell;
    }
    else {
        GYHSLoginVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSResetPasswordVC_Cell_BtnIdentify];
        [cell setCellName:name loginType:self.loginType];
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
    return .1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

#pragma mark - GYHSRegisterTableCellDelegate
- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.password = value;
        }
        else if (indexPath.row == 1) {
            self.pwdAgain = value;
        }
    }
}

#pragma mark - GYHSLoginVConfirmTableCellDelegate
- (void)confirmButtonAction
{
    if ([GYUtils checkStringInvalid:self.password] ||
        [GYUtils checkStringInvalid:self.pwdAgain]) {
        [GYUtils showMessage:kLocalized(@"新密码或确认密码为空！")];
        return;
    }

    if (![self.password isEqualToString:self.pwdAgain]) {
        [GYUtils showMessage:kLocalized(@"新密码与确认密码不一致！")];
        return;
    }

    if (self.password.length != 6) {
        [GYUtils showMessage:kLocalized(@"新密码不足6位！")];
        return;
    }

    if (self.isFindPwdByPhone) {
        [self sendRequestFindPwdByPhone];
    }
    else {
        [self sendRequestFindPwdByQuestion];
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
    if (netRequest.tag == kResetLoginPwdByPhoneFind_Tag) {
        [self parseFindPwdResult:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kResetLoginPwdByQuestionFind_Tag) {
        [self parseFindPwdResult:returnCode responseObject:responseObject];
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
    self.title = kLocalized(@"重置登录密码");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
}

- (void)sendRequestFindPwdByPhone
{
    if ([GYUtils checkDictionaryInvalid:self.pwdByPhoneDic]) {
        [GYUtils showMessage:kLocalized(@"请求参数为空！")];
        return;
    }

    NSString* mobile = [self.pwdByPhoneDic valueForKey:@"mobile"];
    NSString* newPwd = [self.password md5String16:mobile];

    [self.pwdByPhoneDic setObject:newPwd forKey:@"newLoginPwd"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlResetLoginPwd parameters:self.pwdByPhoneDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kResetLoginPwdByPhoneFind_Tag;
    [request start];
}

- (void)sendRequestFindPwdByQuestion
{
    if ([GYUtils checkDictionaryInvalid:self.pwdByQuestionDic]) {
        [GYUtils showMessage:kLocalized(@"请求参数为空！")];
        return;
    }

    NSString* custId = [self.pwdByQuestionDic valueForKey:@"custId"];
    NSString* newPwd = [self.password md5String16:custId];

    [self.pwdByQuestionDic setObject:newPwd forKey:@"newLoginPwd"];

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlResetLoginPwdBySecurity parameters:self.pwdByQuestionDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kResetLoginPwdByQuestionFind_Tag;
    [request start];
}

- (void)parseFindPwdResult:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Error:%@", responseObject);
        [GYUtils showMessage:kErrorMsg];
        return;
    }

    WS(weakSelf)
        [GYUtils showMessage:kLocalized(@"GYHS_Login_ResetPasswordSuccess") confirm:^{
        NSMutableArray* allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        for (UIViewController* aViewController in allViewControllers) {
            if ([aViewController isKindOfClass:[GYHSLoginViewController class]]) {
                [weakSelf.navigationController popToViewController:aViewController animated:YES];
            }
        }
        }];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        headView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.tableHeaderView = headView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSRegisterTableCell" bundle:nil] forCellReuseIdentifier:kGYHSResetPasswordVC_CellIdentify];
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSLoginVConfirmTableCell" bundle:nil] forCellReuseIdentifier:kGYHSResetPasswordVC_Cell_BtnIdentify];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@[
            @{ @"Name" : kLocalized(@"新密码"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"输入新密码")
            },
            @{ @"Name" : kLocalized(@"确认密码"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"再次输入新密码") }
        ]];

        [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"特别提示：登录密码为6位数字") } ]];
        [_dataArray addObject:@[@{@"Name" : kLocalized(@"确定")}]];
    }
    
    return _dataArray;
}

@end
