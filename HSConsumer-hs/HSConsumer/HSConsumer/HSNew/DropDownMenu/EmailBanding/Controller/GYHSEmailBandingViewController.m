//
//  GYHSEmailBandingVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSConstant.h"
#import "GYHSEmailBandingViewController.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginModel.h"
#import "GYHSLoginVConfirmTableCell.h"
#import "GYHSLoginViewController.h"
#import "GYHSNetworkAPI.h"
#import "GYHSRegisterTableCell.h"
#import "GYNetRequest.h"
#import "NSString+GYExtension.h"

#define kGYHSEmailBandingVC_CellIdentify @"kGYHSEmailBandingVC_CellIdentify"
#define kGYHSEmailBandingVC_CellTipInfoIdentify @"kGYHSEmailBandingVC_CellTipInfoIdentify"
#define kGYHSEmailBandingVC_Cell_BtnIdentify @"kGYHSEmailBandingVC_Cell_BtnIdentify"

#define kSendEmailLinkUrlString_Tag 100
#define kModifyEmailBandingUrlString_Tag 101

@interface GYHSEmailBandingViewController () <UITableViewDelegate, UITableViewDataSource, GYHSRegisterTableCellDelegate, GYHSLoginVConfirmTableCellDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@property (nonatomic, strong) NSString* emailAdress;
@property (nonatomic, strong) NSString* reEmailAdress;
@property (nonatomic, strong) NSString* loginPwd;

@end
@implementation GYHSEmailBandingViewController

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
        GYHSRegisterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSEmailBandingVC_CellIdentify];
        NSString* value = [dic valueForKey:@"Value"];
        NSString* placeHolder = [dic valueForKey:@"placeHolder"];
        BOOL pwdType = [[dic valueForKey:@"pwdType"] boolValue];
        NSInteger maxSize = [[dic valueForKey:@"maxSize"] integerValue];
        BOOL keyBoardNum = [[dic valueForKey:@"keyBoardNum"] boolValue];
        [cell setCellValue:name
                     value:value
               placeHolder:placeHolder
                   pwdType:pwdType
                   maxSize:maxSize
               keyBoardNum:keyBoardNum
                showSmsBtn:NO
              showArrowBtn:NO
                 indexPath:indexPath];

        cell.cellDelegate = self;
        cell.valueTextField.keyboardType = UIKeyboardTypeEmailAddress;
        return cell;
    }

    if (self.pageType == GYHSEmailBandingVCPageAdd) {
        if (indexPath.section == 1) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSEmailBandingVC_CellTipInfoIdentify];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSEmailBandingVC_CellTipInfoIdentify];
                cell.backgroundColor = kDefaultVCBackgroundColor;
                [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
                [cell.textLabel setTextColor:kgrayTextColor];
                cell.textLabel.numberOfLines = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            cell.textLabel.text = name;
            return cell;
        }
    }

    GYHSLoginVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSEmailBandingVC_Cell_BtnIdentify];
    //TODO:wfd GYHSLoginViewControllerTypeNoPhoneBanding -> GYHSLoginViewControllerTypeHashsCard
    [cell setCellName:name loginType:GYHSLoginVCPageTypeHD];
    [cell setCellBackground:kDefaultVCBackgroundColor];
    cell.cellDelegate = self;
    return cell;
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
    if (self.pageType == GYHSEmailBandingVCPageModify) {
        return 20.0f;
    }

    return 5;
}

#pragma mark - GYHSRegisterTableCellDelegate
- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section != 0) {
        return;
    }

    if (0 == indexPath.row) {
        self.emailAdress = value;
    } else if (1 == indexPath.row) {
        self.reEmailAdress = value;
    }

    if (self.pageType == GYHSEmailBandingVCPageModify) {
        if (2 == indexPath.row) {
            self.loginPwd = value;
        }
    }
}

#pragma mark - GYHSLoginVConfirmTableCellDelegate
- (void)confirmButtonAction
{

    if (self.emailAdress.length == 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Email_Cannot_Empty")];
        return;
    }

    if (self.reEmailAdress.length == 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Confirmation_Email_Cannot_Empty")];
        return;
    }

    if (![self.emailAdress isEqualToString:self.reEmailAdress]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Email_With_Confirmation_Email")];
        return;
    }

    if (![GYUtils isValidateEmail:self.emailAdress]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_PleaseEnterTheCorrectEmail")];
        return;
    }

    if (self.pageType == GYHSEmailBandingVCPageAdd) {
        [self sendBindEmailRequest];
    } else if (self.pageType == GYHSEmailBandingVCPageModify) {

        if ([GYUtils checkStringInvalid:self.loginPwd]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_PleaseEnterLoginPassword")];
            return;
        }

        if (self.loginPwd.length != 6) {
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_Password_Length_Less_Than6")];
            return;
        }
        [self sendModifyBindEmailRequest];
    }
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];
    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Business_Resport_Lost_Card_Error_For_Respond_Data") confirm:nil];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (netRequest.tag == kSendEmailLinkUrlString_Tag) {
        [self parseSendBindEmail:returnCode responseObject:responseObject];
    } else if (netRequest.tag == kModifyEmailBandingUrlString_Tag) {
        [self parseSendBindEmail:returnCode responseObject:responseObject];
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
    NSString* titleName = kLocalized(@"GYHS_Banding_Email_Binding");

    if (self.pageType == GYHSEmailBandingVCPageModify) {
        titleName = kLocalized(@"GYHS_Banding_Modify_Email");
    }

    self.title = titleName;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
}

- (GYHSLoginModel*)loginModel
{
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

- (void)sendBindEmailRequest
{
    GYHSLoginModel* model = [self loginModel];
    NSString* userName = [GYUtils saftToNSString:model.userName];
    NSDictionary* paramsDic = @{
        @"email" : self.emailAdress,
        @"userName" : userName,
        @"userType" : model.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"custType" : model.cardHolder ? kCustTypeCard : kCustTypeNoCard
    };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kSendEmailLinkUrlString parameters:paramsDic requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kSendEmailLinkUrlString_Tag;
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

- (void)parseSendBindEmail:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{

    if (returnCode != 200) {
        DDLogDebug(@"The returnCode:%ld is not 200.", returnCode);
        [GYUtils showMessage:kLocalized(@"")];
        return;
    }

    GYHSLoginModel* model = [self loginModel];
    //    model.isAuthEmail = kAuthHad;
    model.email = self.emailAdress;
    [[GYHSLoginManager shareInstance] saveLoginModel:model];

    NSString* tmpEmail = [NSString stringWithFormat:@"%@****%@",
                                   [self.emailAdress substringToIndex:2],
                                   [self.emailAdress substringFromIndex:[self.emailAdress rangeOfString:@"@"].location]];
    NSString* msg = [NSString stringWithFormat:kLocalized(@"GYHS_Banding_Validation_Email_Sent%@Please_Login_Email_Complete_Binding"), tmpEmail];

    WS(weakSelf)
        [GYUtils showMessage:msg
                     confirm:^{
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                     }];
}

- (void)sendModifyBindEmailRequest
{
    GYHSLoginModel* model = [self loginModel];
    NSString* cusid = [GYUtils saftToNSString:model.custId];
    NSString* pwd = [self.loginPwd md5String16:model.custId];

    NSDictionary* paramDic = @{ @"email" : self.emailAdress,
        @"custId" : cusid,
        @"loginPwd" : pwd };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kModifyEmailBandingUrlString parameters:paramDic requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kModifyEmailBandingUrlString_Tag;
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        headView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.tableHeaderView = headView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSRegisterTableCell class]) bundle:nil] forCellReuseIdentifier:kGYHSEmailBandingVC_CellIdentify];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLoginVConfirmTableCell class]) bundle:nil] forCellReuseIdentifier:kGYHSEmailBandingVC_Cell_BtnIdentify];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        NSMutableArray* infoAry = [NSMutableArray array];
        [infoAry addObject:@{ @"Name" : kLocalized(@"GYHS_Banding_Email"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"请输入绑定邮箱"),//GYHS_Banding_Input_Binding_Email
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"maxSize" : [NSNumber numberWithInt:100],
            @"keyBoardNum" : [NSNumber numberWithBool:NO]
        }];
        [infoAry addObject:@{ @"Name" : kLocalized(@"确认邮箱"),
            @"Value" : @"",
            @"placeHolder" : kLocalized(@"请再次输入绑定邮箱"),
            @"pwdType" : [NSNumber numberWithBool:NO],
            @"maxSize" : [NSNumber numberWithInt:100],
            @"keyBoardNum" : [NSNumber numberWithBool:NO]
        }];

        if (self.pageType == GYHSEmailBandingVCPageModify) {
            [infoAry addObject:@{ @"Name" : kLocalized(@"密码验证"),
                @"Value" : @"",
                @"placeHolder" : kLocalized(@"输入6位登录密码"),
                @"pwdType" : [NSNumber numberWithBool:YES],
                @"maxSize" : [NSNumber numberWithInt:6],
                @"keyBoardNum" : [NSNumber numberWithBool:YES]
            }];
        }
        [_dataArray addObject:infoAry];

        if (self.pageType == GYHSEmailBandingVCPageModify) {
            [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"立即修改") } ]];
        } else {
            [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"温馨提示：系统将发送验证信息到您绑定的邮箱，请及时登录邮箱完成绑定。") } ]];
            [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"确定") } ]];
        }
    }
    
    return _dataArray;
}

@end
