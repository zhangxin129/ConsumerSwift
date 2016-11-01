//
//  GYHSNewBaseQueryController.m
//  HSConsumer
//
//  Created by liss on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSNewBaseQueryController.h"
#import "GYHSAddBankCardInfoVC.h"
#import "GYHSBaseQueryCell.h"
#import "GYHSBindBankCardListVC.h"
#import "GYHSEmailBandingVC.h"
#import "GYHSNewIphoneController.h"
#import "GYHSQuickPaymentCardVC.h"
#import "GYQuitPhoneBandingViewController.h"

@interface GYHSNewBaseQueryController () <GYNetRequestDelegate>

@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) NSArray* titleImgArray;
@property (nonatomic, strong) NSMutableArray* isSetArray;

@end

@implementation GYHSNewBaseQueryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogDebug(@"Load Controller: %@", [self class]);

    [self.tableView registerNib:[UINib nibWithNibName:@"GYHSBaseQueryCell" bundle:nil] forCellReuseIdentifier:@"GYHSBaseQueryCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEmail) name:@"updateBaseQueryController" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getEmail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"dealloc Controller: %@", [self class]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSBaseQueryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSBaseQueryCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.titleArray.count > indexPath.row) {
        cell.title.text = self.titleArray[indexPath.row];
    }
    cell.isSet.text = kLocalized(@"GYHS_NoHSCard_already_setting");
    if (self.isSetArray.count > indexPath.row && [self.isSetArray[indexPath.row] isEqualToString:@"1"]) {
        cell.isSet.hidden = NO;
        if (self.titleImgArray.count > indexPath.row) {
            cell.img.image = [UIImage imageNamed:self.titleImgArray[indexPath.row]];
        }
    } else {
        cell.isSet.hidden = YES;
        if (self.titleImgArray.count > indexPath.row + self.titleImgArray.count / 2) {
            cell.img.image = [UIImage imageNamed:self.titleImgArray[indexPath.row + self.titleImgArray.count / 2]];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 75.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UIViewController* vc = nil;
    switch (indexPath.row) {
    case 0: {
        GYHSNewIphoneController* vciphone = [[GYHSNewIphoneController alloc] init];
        NSString* iphone = globalData.loginModel.userName;
        NSString* newIphone = @"";
        if (iphone.length == 11) {
            newIphone = [NSString stringWithFormat:@"%@****%@", [iphone substringToIndex:3], [iphone substringFromIndex:iphone.length - 4]];
        }

        // 有手机号认为已验证
        if (![GYUtils checkStringInvalid:iphone] ||
            [kSaftToNSString(globalData.loginModel.isAuthMobile) isEqualToString:@"1"]) {
            vciphone.ipSetStr = @"已验证";
        } else {
            vciphone.ipSetStr = @"未验证";
        }

        vciphone.iphonestr = newIphone;
        vciphone.setFloat = 0;
        vciphone.isbtnH = YES;
        vciphone.imageName = @"hs_iphone";
        vc = vciphone;
    } break;
    case 1: {
        // 邮箱绑定
        if ([globalData.loginModel.isAuthEmail isEqualToString:kAuthHad] || ![GYUtils checkStringInvalid:globalData.loginModel.email]) {
            GYQuitPhoneBandingViewController* vcEmail = [[GYQuitPhoneBandingViewController alloc] initWithNibName:@"GYQuitPhoneBandingViewController" bundle:nil];
            vcEmail.fromPhonePage = NO;
            vc = vcEmail;
        } else { ///验证邮箱
            GYHSEmailBandingVC* vcEmail = [[GYHSEmailBandingVC alloc] init];
            vc = vcEmail;
        }
    } break;
    case 2: {
        NSString* isBindingBank = globalData.loginModel.isBindBank;
        /**是否绑定银行卡（1:已绑定 0: 未绑定）*/
        if ([isBindingBank isEqualToString:@"1"]) {
            GYHSBindBankCardListVC* vcBank = [[GYHSBindBankCardListVC alloc] init];
            vcBank.isPerfect = GYHSBindBankCardListVCTypePerfect;
            vc = vcBank;
        } else {
            [self requestNetWorkInfo];
        }

    } break;
    case 3: {
        //            NSString* isBindingCard = _isSetArray[indexPath.row];
        /**是否绑定快捷支付卡（1:已绑定 0: 未绑定）*/

        GYHSQuickPaymentCardVC* vcCard = [[GYHSQuickPaymentCardVC alloc] init];
        vc = vcCard;
    } break;
    default:
        break;
    }
    if (self.titleArray.count > indexPath.row) {
        vc.title = self.titleArray[indexPath.row];
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestNetWorkInfo
{
    [GYGIFHUD show];
    WS(weakSelf)
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSGetInfo parameters:@{ @"userId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        if([GYUtils checkStringInvalid:kSaftToNSString(dic[@"name"])]) {
            GYHSBindBankCardListVC* vcBank = [[GYHSBindBankCardListVC alloc] init];
            vcBank.isPerfect = GYHSBindBankCardListVCTypeNoPerfect;
            vcBank.hidesBottomBarWhenPushed = YES;
            [[weakSelf navigationController] pushViewController:vcBank animated:YES];
        }else {
            GYHSBindBankCardListVC* vcSelAcc = kLoadVcFromClassStringName(NSStringFromClass([GYHSBindBankCardListVC class]));
            vcSelAcc.isPerfect = GYHSBindBankCardListVCTypePerfect;
            vcSelAcc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcSelAcc animated:YES];
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
- (void)getEmail
{
    if (!globalData.isLogined) {
        return;
    }

    NSDictionary* dict = @{
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard)
    };
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSqueryCustomerStatusUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary* dic = responseObject[@"data"];
        [_isSetArray removeAllObjects];
        if ([dic isKindOfClass:[NSNull class]]) {
            [_isSetArray addObject:@"1"];
            [_isSetArray addObject:@"0"];
            [_isSetArray addObject:@"0"];
            [_isSetArray addObject:@"0"];
        } else {
            globalData.loginModel.isAuthEmail = kSaftToNSString(dic[@"authEmail"]);
            globalData.loginModel.isBindBank = kSaftToNSString(dic[@"bindbank"]);
            
            [_isSetArray addObject:@"1"];
            [_isSetArray addObject:kSaftToNSString(globalData.loginModel.isAuthEmail)];
            [_isSetArray addObject:kSaftToNSString(dic[@"bindbank"])];
            [_isSetArray addObject:kSaftToNSString(dic[@"qkBank"])];
            [self requestData];
            [self loadPaymentTypeDataFromNet];
        }
        [self.tableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)requestData
{

    NSDictionary* dict = @{
        @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard)
    };
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlListQkBanks parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
      if (error) {
        DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
        [GYUtils parseNetWork:error resultBlock:nil];
        return ;
      }
        NSArray* arr = responseObject[@"data"];
        if (arr.count > 0) {
            [_isSetArray addObject:@"1"];
        } else {
            [_isSetArray addObject:@"0"];
        }
        [self.tableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - 网络数据交换
- (void)loadPaymentTypeDataFromNet
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kGetPaymentTypeUrlString parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.noShowErrorMsg = YES;
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    NSArray* dataArray = responseObject[@"data"];
    if ([dataArray containsObject:@"QU"]) {
        _titleArray = @[ kLocalized(@"GYHS_NoHSCard_phone_number_binding"), kLocalized(@"GYHS_NoHSCard_email_binding"), kLocalized(@"GYHS_NoHSCard_bank_card_binding"), kLocalized(@"GYHS_NoHSCard_quick_card_pay") ];
        _titleImgArray = @[
            //已设置
            @"hs_iphone",
            @"hs_newemail",
            @"hs_newbank",
            @"hs_cell_qkbank_banding", 
            //未设置
            @"hs_person_profile_mobile_unbind",
            @"hs_img_profile_email_unbind",
            @"hs_img_profile_bank_unbind",
            @"hs_cell_qkbank_banding_selected",
        ];
    } else {
        _titleArray = @[ kLocalized(@"GYHS_NoHSCard_phone_number_binding"), kLocalized(@"GYHS_NoHSCard_email_binding"), kLocalized(@"GYHS_NoHSCard_bank_card_binding") ];
        _titleImgArray = @[
            //已设置
            @"hs_iphone",
            @"hs_newemail",
            @"hs_newbank",
            //未设置
            @"hs_person_profile_mobile_unbind",
            @"hs_img_profile_email_unbind",
            @"hs_img_profile_bank_unbind",
        ];
    }
    [self.tableView reloadData];
}

#pragma mark 懒加载
- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ kLocalized(@"GYHS_NoHSCard_phone_number_binding"), kLocalized(@"GYHS_NoHSCard_email_binding"), kLocalized(@"GYHS_NoHSCard_bank_card_binding")];
    }
    return _titleArray;
}
- (NSArray*)titleImgArray
{
    if (!_titleImgArray) {
        _titleImgArray = @[
            //已设置
            @"hs_iphone",
            @"hs_newemail",
            @"hs_newbank",
            //未设置
            @"hs_person_profile_mobile_unbind",
            @"hs_img_profile_email_unbind",
            @"hs_img_profile_bank_unbind"
        ];
    }
    return _titleImgArray;
}

- (NSMutableArray*)isSetArray
{
    if (!_isSetArray) {
        _isSetArray = [NSMutableArray array];
        [_isSetArray addObject:@"1"];
        if ([kSaftToNSString(globalData.loginModel.isAuthEmail) isEqualToString:@"1"]) {
            [_isSetArray addObject:@"1"];
        } else {
            [_isSetArray addObject:@"0"];
        }
        [_isSetArray addObject:@"0"];
        [_isSetArray addObject:@"0"];
    }
    return _isSetArray;
}
            
@end
