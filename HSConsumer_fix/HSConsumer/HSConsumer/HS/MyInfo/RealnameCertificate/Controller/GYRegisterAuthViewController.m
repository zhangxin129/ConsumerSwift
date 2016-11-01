//
//  GYCompanyManageViewController.m
//  company
//
//  Created by apple on 14-11-13.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  实名注册 认证
#define kKeyCellName @"keyName"
#define kKeyCellIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYRegisterAuthViewController.h"
#import "CellTypeImagelabel.h"

#import "GYMyInfoTableViewCell.h"

//通过验证
#import "GYFinishAuthViewController.h"
//没有注册的进入实名认证
#import "GYNoRegisterForSkipViewController.h"

//待审批 三张图片
#import "GYApproveThreePicViewController.h"

//去实名绑定
#import "GYNoRegisterForSkipViewController.h"

#import "GYAlertView.h"

//实名注册
#import "GYRealNameRegistrationViewController.h"

#import "GYHSRealNameWithIdentifyAuthViewController.h"
#import "GYHSRealNameWithLicenceAuthViewController.h"
#import "GYHSRealNameWithPassportAuthViewController.h"

@interface GYRegisterAuthViewController ()

@property (nonatomic, copy) NSString* realNameRegister; //是否实名注册
@property (nonatomic, copy) NSString* realNameAuthentication; //是否实名认证
@end

@implementation GYRegisterAuthViewController {
    NSArray* arrPowers; //账户的属性
    GlobalData* data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = globalData;
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    self.title = kLocalized(@"GYHS_RealName_Register_Auth");
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    //查询消费者是否实名注册、是否实名认证
    [self queryAuthRealNameWithUrlString];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return arrPowers.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    static NSString* identifier = @"cell";
    GYMyInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[GYMyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (arrPowers.count > indexPath.row) {
        [cell refreshWithImg:[arrPowers[indexPath.row] objectForKey:kKeyCellIcon] WithTitle:[arrPowers[indexPath.row] objectForKey:kKeyCellName]];
    }

    switch (indexPath.row) {
    case 0: {
        cell.vAccessoryView.text = self.realNameRegister;
    } break;

    case 1: {

        cell.vAccessoryView.text = self.realNameAuthentication;

    } break;
    default:
        break;
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 75.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16;
    }
    else {
        return 6; //加上页脚＝16
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController* vc = nil;
    if (arrPowers.count > indexPath.row) {
        vc = kLoadVcFromClassStringName([arrPowers[indexPath.row] valueForKey:kKeyNextVcName]);
        vc.navigationItem.title = [arrPowers[indexPath.row] valueForKey:kKeyCellName];
    }

    if (indexPath.row == 0) {
        GYRealNameRegistrationViewController* noRegister = (GYRealNameRegistrationViewController*)vc;
        vc = noRegister;
        [self pushVC:vc animated:YES];
    }
    else if (indexPath.row == 1) {

        if ([data.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {

            GYNoRegisterForSkipViewController* noRegister = [[GYNoRegisterForSkipViewController alloc] init];
            noRegister.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
            noRegister.strContent = kLocalized(@"GYHS_RealName_You_Not_To_Real_Name_Registration");
            noRegister.strContentNext = kLocalized(@"GYHS_RealName_Please_Again_After_For_Real_Name_Registration_The_Business");
            vc = noRegister;
            [self pushVC:vc animated:YES];
        }
        else {

            [self getRealNameAuthStatusGotoRelateController];
        }
    }
}

- (id)getVC:(NSString*)classString
{
    return [[NSClassFromString(classString) alloc] init];
}

//弹出新窗口
- (void)pushVC:(id)sender animated:(BOOL)ani
{

    [self.navigationController pushViewController:sender animated:ani];
}

//查询实名认证状态
- (void)getRealNameAuthStatusGotoRelateController
{

    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) {
        //已完成实名认证

        UIViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYFinishAuthViewController class]));
        vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
        [self pushVC:vc animated:YES];
        return;
    }

    //实名认证状态查询
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];

    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"perCustId"];

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kQueryRealNameAuthInfoUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        UIViewController *vc = nil;
        NSString *vcName;
        
        NSDictionary *dicData = responseObject[@"data"];
        if (([dicData isKindOfClass:[NSNull class]] || dicData == nil || dicData.count == 0)) {
            
            //data 返回空为未申请实名认证
            //进入实名认证申请
            vcName = [self getNextVCName];
            vc = kLoadVcFromClassStringName(vcName);
            vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
            [self pushVC:vc animated:YES];
            return;
            
        }
        
        //已经实名注册，查询实名认证信息
        globalData.personInfo.creFaceImg = kSaftToNSString(dicData[@"cerpica"]);
        globalData.personInfo.creBackImg = kSaftToNSString(dicData[@"cerpicb"]);
        globalData.personInfo.creHoldImg = kSaftToNSString(dicData[@"cerpich"]);
        //审核通过
        if ([dicData[@"status"] isEqualToNumber:@2]) {
            //
            vcName = NSStringFromClass([GYFinishAuthViewController class]);
            vc = kLoadVcFromClassStringName(vcName);
            vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
            [self pushVC:vc animated:YES];
            //审核中
        } else if ([dicData[@"status"] isEqualToNumber:@0] || [dicData[@"status"] isEqualToNumber:@1]) {
            GYApproveThreePicViewController *vc = [[GYApproveThreePicViewController alloc] init];
            vc.status = kRealNameAuthStatusApproveWait;
            vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
            [self pushVC:vc animated:YES];
            //驳回
        } else if ([dicData[@"status"] isEqualToNumber:@3]) {
            GYApproveThreePicViewController *vc = [[GYApproveThreePicViewController alloc] init];
            vc.status = kRealNameAuthStatusApproveRefuse;
            vc.refuseReason = dicData[@"apprContent"];
            vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
            [self pushVC:vc animated:YES];
            //复审驳回
        } else if ([dicData[@"status"] isEqualToNumber:@4]) {
            GYApproveThreePicViewController *vc = [[GYApproveThreePicViewController alloc] init];
            vc.status = kRealNameAuthStatusApproveLastRefuse;
            vc.refuseReason = dicData[@"apprContent"];
            vc.navigationItem.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
            [self pushVC:vc animated:YES];
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
    
    
}

- (void)setTableViewWithNameUp:(NSString*)nameUp name:(NSString*)name
{

    //注册cell
    [self.tvRegisterAuth registerNib:[UINib nibWithNibName:@"GYMyInfoTableViewCell" bundle:kDefaultBundle]
              forCellReuseIdentifier:@"cell"];
    NSString* registeredImage = @"";
    NSString* certificationImage = @"";

    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) {
        registeredImage = @"hs_cell_realname_register.png";
        certificationImage = @"hs_cell_realname_authentication.png";
    }
    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes]) {
        registeredImage = @"hs_cell_realname_register.png";
        certificationImage = @"hs_person_real_name_unattestation.png";
    }
    else if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
        registeredImage = @"hs_person_real_name_unreg.png";
        certificationImage = @"hs_person_real_name_unattestation.png";
    }
    arrPowers = @[ @{ kKeyCellIcon : registeredImage,
        kKeyCellName : kLocalized(@"GYHS_RealName_Register"),
        kKeyNextVcName : nameUp },
        @{ kKeyCellIcon : certificationImage,
            kKeyCellName : kLocalized(@"GYHS_RealName_Authentication_Authentication"),
            kKeyNextVcName : name },
    ];
    [self.tvRegisterAuth reloadData];
}

- (NSString*)getNextVCName
{

    if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {

        return NSStringFromClass([GYHSRealNameWithIdentifyAuthViewController class]);
    }
    else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {

        return NSStringFromClass([GYHSRealNameWithPassportAuthViewController class]);
    }
    else {

        return NSStringFromClass([GYHSRealNameWithLicenceAuthViewController class]);
    }
}

#pragma mark - //查询消费者是否实名注、是否实名认证
- (void)queryAuthRealNameWithUrlString
{
    WS(weakSelf)
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : globalData.loginModel.cardHolder ? @"2" : @"1" };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kQueryAuthRealNameWithUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        if ([responseObject[@"data"] isKindOfClass:[NSString class]] && [responseObject[@"data"] isEqualToString:kRealNameStatusNoRes]) {
            
            weakSelf.realNameRegister = kLocalized(@"GYHS_RealName_Non_Register");
            globalData.loginModel.isRealnameAuth = kRealNameStatusNoRes;
            weakSelf.realNameAuthentication = kLocalized(@"GYHS_RealName_Non_Authentication");
            
        } else if ([responseObject[@"data"] isKindOfClass:[NSString class]] && [responseObject[@"data"] isEqualToString:kRealNameStatusHadRes]) {
            
            weakSelf.realNameRegister = kLocalized(@"GYHS_RealName_Already_Register");
            globalData.loginModel.isRealnameAuth = kRealNameStatusHadRes;
            weakSelf.realNameAuthentication = kLocalized(@"GYHS_RealName_Non_Authentication");
            
        } else if ([responseObject[@"data"] isKindOfClass:[NSString class]] && [responseObject[@"data"] isEqualToString:kRealNameStatusHadCertify]) {
            
            weakSelf.realNameRegister = kLocalized(@"GYHS_RealName_Already_Register");
            globalData.loginModel.isRealnameAuth = kRealNameStatusHadCertify;
            weakSelf.realNameAuthentication = kLocalized(@"GYHS_RealName_Already_Authentication");
            globalData.loginModel.isRealnameAuth = kRealNameStatusHadCertify;
        }
        NSString* vcNameUp;
        NSString* vcName;
        //根据认证状态 判断进入 待审核  审核驳回  已通过页面。
        //判断实名绑定  再进入 实名注册
        vcNameUp = NSStringFromClass([GYRealNameRegistrationViewController class]);
        if (![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
            vcName = @"cell click will set value";
        }
        else {
            //您还未实名注册，请先进行实名注册，点击进入实名注册
            vcName = NSStringFromClass([GYNoRegisterForSkipViewController class]);
        }
        [self setTableViewWithNameUp:vcNameUp name:vcName];
        [weakSelf.tvRegisterAuth reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
