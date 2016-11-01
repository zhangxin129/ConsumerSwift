//
//  GYHSBindCardInfoVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/17.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//通过类名实例化,VC适合没有xib的方式。
#define LoadVcFromClassStringName(classStringName) [[NSClassFromString(className) alloc] init]

#import "GYHSBindCardInfoVC.h"
#import "GYHSBusinessProcessCell.h"
#import "GYHSBindBankCardListVC.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginModel.h"
#import "GYHSEmailBandingVC.h"
#import "GYHSPhoneBandingVC.h"
#import "GYHSPhoneEmailListVC.h"
#import "GYHSNetworkAPI.h"
#import "GYHSConstant.h"
#import "GYQuitPhoneBandingViewController.h"
#import "GYHSAddBankCardInfoVC.h"
#import "GYNoRegisterForSkipViewController.h"
#import "GYHSQuickPaymentCardVC.h"

NSString* const GYHS_Bing_CardInfo_CellNameKey = @"GYHS_Bing_CardInfo_CellNameKey";
NSString* const GYHS_Bing_CardInfo_CellIconKey = @"GYHS_Bing_CardInfo_CellIconKey";
NSString* const GYHS_Bing_CardInfo_CellActionKey = @"GYHS_Bing_CardInfo_CellActionKey";
NSString* const GYHS_Bing_CardInfo_CellState = @"GYHS_Bing_CardInfo_CellState";
NSString* const GYHS_Bing_CardInfo_CellParams = @"GYHS_Bing_CardInfo_CellParams";
NSString* const GYHS_Bing_CardInfo_CellIdentify = @"GYHS_Bing_CardInfo_CellIdentify";

@interface GYHSBindCardInfoVC () <UITableViewDelegate, UITableViewDataSource,GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, copy) NSString *quick;
@property (nonatomic, assign) BOOL isExistQuickPay;

@end

@implementation GYHSBindCardInfoVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self loadPaymentTypeDataFromNet];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 网络数据交换
- (void)loadPaymentTypeDataFromNet
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kGetPaymentTypeUrlString parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.noShowErrorMsg = YES;
    [request start];
    [GYGIFHUD show];
}

- (void)loadData
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSqueryCustomerStatusUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error == nil) {
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                NSDictionary *dit = responseObject[@"data"];
                if ([dit[@"bindbank"] isEqualToNumber:@1]) {
                    globalData.loginModel.isBindBank = @"1";
                    
                } else {
                    globalData.loginModel.isBindBank = @"0";
                }
                
                if ([dit[@"authMobile"] isEqualToNumber:@1]) {
                    globalData.loginModel.isAuthMobile = @"1";
                } else {
                    globalData.loginModel.isAuthMobile = @"0";
                }
                
                if ([dit[@"authEmail"] isEqualToNumber:@1]) {
                    globalData.loginModel.isAuthEmail = @"1";
                } else {
                    globalData.loginModel.isAuthEmail = @"0";
                }
                if ([dit[@"qkBank"] isEqualToNumber:@1]) {
                    self.quick = kLocalized(@"GYHS_Banding_Already_Banding");
                } else {
                    self.quick = kLocalized(@"GYHS_Banding_Non_Banding");
                }
                
                NSString *email = dit[@"GYHS_Banding_Email"];
                if (![GYUtils checkStringInvalid:email]) {
                    globalData.loginModel.email = email;
                }
                
                self.dataArray = [[NSMutableArray alloc] init];
                
                [self.dataArray addObject:@{ GYHS_Bing_CardInfo_CellIconKey : [[self bindBankState] isEqualToString:kLocalized(@"GYHS_Banding_Non_Banding")] == YES ? @"hs_img_profile_bank_unbind" : @"hs_cell_card_banding",
                                             GYHS_Bing_CardInfo_CellNameKey : kLocalized(@"GYHS_Banding_Bank_Card_Binding"),
                                             GYHS_Bing_CardInfo_CellState : [self bindBankState],
                                             GYHS_Bing_CardInfo_CellActionKey : NSStringFromClass([GYHSBindBankCardListVC class])
                                             }];
                
                [self.dataArray addObject:@{ GYHS_Bing_CardInfo_CellIconKey : [[self bindPhoneState] isEqualToString:kLocalized(@"GYHS_Banding_Non_Banding")] == YES ? @"hs_person_profile_mobile_unbind" : @"hs_cell_phone_banding",
                                             GYHS_Bing_CardInfo_CellNameKey : kLocalized(@"GYHS_Banding_Cell_Phone_Number_Binding"),
                                             GYHS_Bing_CardInfo_CellState : [self bindPhoneState],
                                             GYHS_Bing_CardInfo_CellParams : @"",
                                             GYHS_Bing_CardInfo_CellActionKey : [self bindPhoneAction]
                                             }];
                
                [self.dataArray addObject:@{ GYHS_Bing_CardInfo_CellIconKey : [[self bindEmailState] isEqualToString:kLocalized(@"GYHS_Banding_Non_Banding")] == YES ? @"hs_img_profile_email_unbind" : @"hs_cell_email_banding",
                                             GYHS_Bing_CardInfo_CellNameKey : kLocalized(@"GYHS_Banding_Email_Binding"),
                                             GYHS_Bing_CardInfo_CellState : [self bindEmailState],
                                             GYHS_Bing_CardInfo_CellParams : @"",
                                             GYHS_Bing_CardInfo_CellActionKey : [self bindEmailAction]
                                             }];
                
                if (self.isExistQuickPay) {
                    [self.dataArray addObject:@{GYHS_Bing_CardInfo_CellIconKey: [self.quick isEqualToString:kLocalized(@"GYHS_Banding_Non_Banding")] == YES ?@"hs_cell_qkbank_banding_selected" :@"hs_cell_qkbank_banding",
                                                GYHS_Bing_CardInfo_CellNameKey: kLocalized(@"GYHS_Banding_MyQuickPaymentCard"),
                                                GYHS_Bing_CardInfo_CellState : @"",
                                                GYHS_Bing_CardInfo_CellActionKey: NSStringFromClass([GYHSQuickPaymentCardVC class])
                                                }];
                }
                [self.tableView reloadData];
            }
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
            [self.tableView reloadData];
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYGIFHUD dismiss];
    self.isExistQuickPay = NO;
    [self loadData];
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    NSArray *dataArray = responseObject[@"data"];
    if ([dataArray containsObject:@"QU"]) {
        self.isExistQuickPay = YES;
    } else {
        self.isExistQuickPay = NO;
    }
    [self loadData];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHSBusinessProcessCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHS_Bing_CardInfo_CellIdentify];
    if (cell == nil) {
        cell = [[GYHSBusinessProcessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GYHS_Bing_CardInfo_CellIdentify];
    }
    
    NSDictionary* dic = nil;
    if (self.dataArray.count > indexPath.row) {
         dic = self.dataArray[indexPath.row];
    }
    NSString* image = [dic valueForKey:GYHS_Bing_CardInfo_CellIconKey];
    NSString* title = [dic valueForKey:GYHS_Bing_CardInfo_CellNameKey];
    NSString* state = [dic valueForKey:GYHS_Bing_CardInfo_CellState];
    [cell cellContent:image title:title state:state];

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary* dic = nil;
    if (self.dataArray.count > indexPath.row) {
        dic = self.dataArray[indexPath.row];
    }
    NSString* className = [dic valueForKey:GYHS_Bing_CardInfo_CellActionKey];
    UIViewController* vc = kLoadVcFromClassStringName(className);

    if (vc == nil) {
        DDLogDebug(@"The vc is nil.");
        return;
    }

    if ([vc isKindOfClass:[GYHSPhoneEmailListVC class]]) {

        GYHSPhoneEmailListVC* listVC = LoadVcFromClassStringName([GYHSPhoneEmailListVC class]);
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else if ([vc isKindOfClass:[GYHSPhoneBandingVC class]]) {
        GYHSPhoneBandingVC* phoneVC = LoadVcFromClassStringName([GYHSPhoneBandingVC class]);
        phoneVC.pageType = GYHSPhoneBandingVCPageAdd;
        [self.navigationController pushViewController:phoneVC animated:YES];
    }
    else if ([vc isKindOfClass:[GYHSEmailBandingVC class]]) {

        //绑定邮箱或者邮箱未验证
        if ([globalData.loginModel.isAuthEmail isEqualToString:kAuthHad] || ![GYUtils checkStringInvalid:globalData.loginModel.email]) {
            GYQuitPhoneBandingViewController* vc = [[GYQuitPhoneBandingViewController alloc] init];
            vc.title = kLocalized(@"GYHS_Banding_Email_Binding");
            vc.fromPhonePage = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            GYHSEmailBandingVC* emailVC = LoadVcFromClassStringName([GYHSEmailBandingVC class]);
            emailVC.pageType = GYHSEmailBandingVCPageAdd;
            [self.navigationController pushViewController:emailVC animated:YES];
        }
    }
    else if ([vc isKindOfClass:[GYHSBindBankCardListVC class]]) {

        NSString* isBindingBank = globalData.loginModel.isBindBank;
        /**是否绑定银行卡（1:已绑定 0: 未绑定）*/
        if ([isBindingBank isEqualToString:@"1"]) {
            GYHSBindBankCardListVC* listVC = [[GYHSBindBankCardListVC alloc] init];
            listVC.isPerfect = GYHSBindBankCardListVCTypePerfect;
            [self.navigationController pushViewController:listVC animated:YES];
        }
        else {

            NSString* statusRealnameAuth = globalData.loginModel.isRealnameAuth;
            /**1：未实名注册、2：已实名注册（有名字和身份证）、3:已实名认证*/
            if ([statusRealnameAuth isEqualToString:@"1"]) {

                GYNoRegisterForSkipViewController* noRegisterVC = [[GYNoRegisterForSkipViewController alloc] init];
                noRegisterVC.strContent = kLocalized(@"GYHS_Banding_YouNotToReal_NameRegistration");
                noRegisterVC.strContentNext = kLocalized(@"GYHS_Banding_PleaseAgainAfterForReal_NameRegistrationTheBusiness");
                noRegisterVC.title = kLocalized(@"GYHS_Banding_Bank_Card_Binding");
                [self.navigationController pushViewController:noRegisterVC animated:YES];
            }
            else {
                
                GYHSBindBankCardListVC* listVC = [[GYHSBindBankCardListVC alloc] init];
                listVC.isPerfect = GYHSBindBankCardListVCTypePerfect;
                [self.navigationController pushViewController:listVC animated:YES];
            }
        }
        

    }
    else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Banding_Card_Info_Banding");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
}

- (GYHSLoginModel*)loginModel
{
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

- (NSString*)bindBankState
{
    GYHSLoginModel* model = [self loginModel];
    if ([model.isBindBank isEqualToString:kAuthHad]) {
        return kLocalized(@"GYHS_Banding_Already_Banding");
    }

    return kLocalized(@"GYHS_Banding_Non_Banding");
}

- (NSString*)bindEmailState
{

    GYHSLoginModel* model = [self loginModel];
    if ([model.isAuthEmail isEqualToString:kAuthHad]) {
        return kLocalized(@"GYHS_Banding_Already_Banding");
    }

    return kLocalized(@"GYHS_Banding_Non_Banding");
}

- (NSString*)bindPhoneState
{
    GYHSLoginModel* model = [self loginModel];
    if ([model.isAuthMobile isEqualToString:kAuthHad]) {
        return kLocalized(@"GYHS_Banding_Already_Banding");
    }

    return kLocalized(@"GYHS_Banding_Non_Banding");
}

- (NSString*)bindPhoneAction
{
    GYHSLoginModel* model = [self loginModel];
    if ([model.isAuthMobile isEqualToString:kAuthHad]) {
        return NSStringFromClass([GYHSPhoneEmailListVC class]);
    }

    return NSStringFromClass([GYHSPhoneBandingVC class]);
}

- (NSString*)bindEmailAction
{
    return NSStringFromClass([GYHSEmailBandingVC class]);
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight - 15 - 20) style:UITableViewStylePlain];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[GYHSBusinessProcessCell class] forCellReuseIdentifier:GYHS_Bing_CardInfo_CellIdentify];
    }
    
    return _tableView;
}


@end