//
//  GYHSAddBankCardInfoVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/28.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSAddBankCardInfoVC.h"
#import "GYHSButtonCell.h"
#import "GYHSAddBankCardInfoTableViewCell.h"
#import "GYHSLoginModel.h"
#import "GYHSLoginManager.h"
#import "GYHSelectBankListVC.h"
#import "GYHSAddressSelectCountryVC.h"
#import "GYHSNetworkAPI.h"
#import "GYNetRequest.h"
#import "GYHSAlternateModel.h"
#import "GYHSConstant.h"
#import "GYUtils+HSConsumer.h"

NSString* const GYHSAddBankCardInfo_Cell_Name = @"GYHSAddBankCardInfo_Cell_Name";
NSString* const GYHSAddBankCardInfo_Cell_Value = @"GYHSAddBankCardInfo_Cell_Value";
NSString* const GYHSAddBankCardInfo_Cell_Attribute = @"GYHSAddBankCardInfo_Cell_Attribute";
NSString* const GYHSAddBankCardInfo_Cell_Image = @"GYHSAddBankCardInfo_Cell_Image";
NSString* const GYHSAddBankCardInfo_Cell_Image_Arrow = @"GYHSAddBankCardInfo_Cell_Image_Arrow";
NSString* const GYHSAddBankCardInfo_Cell_Placeholder = @"GYHSAddBankCardInfo_Cell_Placeholder";
NSString* const GYHSAddBankCardInfo_Cell_keyBoardNumber = @"GYHSAddBankCardInfo_Cell_keyBoardNumber";

NSString* const GYHSAddBankCardInfo_Cell_Info_Identify = @"GYHSAddBankCardInfo_Cell_Info_Identify";
NSString* const GYHSAddBankCardInfo_Cell_Button_Identify = @"GYHSAddBankCardInfo_Cell_Button_Identify";

@interface GYHSAddBankCardInfoVC () <UITableViewDelegate, UITableViewDataSource, GYHSButtonCellDelegate, GYHSAddBankCardInfoTableViewCellDelegate, GYHSBankListSelectBankDeleage, GYNetRequestDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@property (nonatomic, strong) NSString* bankNumber;
@property (nonatomic, strong) NSString* confirmBankNumber;

@property (nonatomic, strong) GYHSBankListModel* bankListModel;
@property (nonatomic, strong) NSString* countryNo;
@property (nonatomic, strong) NSString* provinceNo;
@property (nonatomic, strong) NSString* cityNo;

@property (nonatomic, copy) NSString* bankRealName;
@property (nonatomic,strong)UIButton * defaultBtn;

@end

@implementation GYHSAddBankCardInfoVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(citysInfoHandler:) name:kGYHSAddBankCardInfoSelectCitysNotification object:nil];
    if (!globalData.loginModel.cardHolder) {
        [self requestData];
    }
}

- (void)requestData
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"userId"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kHSGetInfo parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 800;
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DDLogDebug(@"%s", __FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (indexPath.section == 0) {
        GYHSAddBankCardInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHSAddBankCardInfo_Cell_Info_Identify forIndexPath:indexPath];
        [self bingInfoCellData:cell dataDic:dic indexPath:indexPath];
        return cell;
    }
    else {
        GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHSAddBankCardInfo_Cell_Button_Identify forIndexPath:indexPath];
        cell.backgroundColor = kDefaultVCBackgroundColor;
        [cell.btnTitle setTitle:kLocalized(@"GYHS_Banding_Rightnow") forState:UIControlStateNormal];
        cell.btnDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 300, 40)];
        self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.defaultBtn.selected = NO;
        self.defaultBtn.frame = CGRectMake(10,  10, 20, 20);
        [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"hs_un_select"] forState:UIControlStateNormal];
        [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_didSelect"] forState:UIControlStateSelected];
        [self.defaultBtn addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.defaultBtn];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 150, 20)];
        lb.text = kLocalized(@"GYHS_Banding_Default_Card");
        [lb setTextColor:UIColorFromRGB(0x8C8C8C)];
        [view addSubview:lb];
        return view;
    }
    return nil;
}
- (void)defaultBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - GYHSAddBankCardInfoTableViewCellDelegate
- (void)chooseButtonAction:(NSIndexPath*)indexPath
{
    DDLogDebug(@"Enter %s tag:%ld", __FUNCTION__, (long)indexPath.row);
    // 选择开户行
    if (indexPath.row == 2) {
        GYHSelectBankListVC* vc = [[GYHSelectBankListVC alloc] init];
        vc.delegate = self;
        vc.selectIndexPath = indexPath;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 开户地区
    else if (indexPath.row == 3) {
        GYHSAddressSelectCountryVC* vc = [[GYHSAddressSelectCountryVC alloc] init];
        vc.selectIndexPath = indexPath;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)inputValue:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    DDLogDebug(@"Enter %s value:%@", __FUNCTION__, value);

    // 银行账号
    if (indexPath.row == 4) {
        self.bankNumber = value;
    }
    // 确认账号
    else if (indexPath.row == 5) {
        self.confirmBankNumber = value;
    }
}

#pragma mark - GYHSBankListSelectBankDeleage
- (void)getSelectBank:(GYHSBankListModel*)model selectIndexPath:(NSIndexPath*)selectIndexPath
{
    DDLogDebug(@"model:%@", model);
    self.bankListModel = model;
    [self upateCellValue:selectIndexPath value:model.bankName];
}

#pragma mark - GYHSButtonCellDelegate
- (void)nextBtn
{
    DDLogDebug(@"Enter %s", __FUNCTION__);
    NSString* realName = globalData.loginModel.cardHolder ? [self getCustName] : self.bankRealName;
    NSString* payCurrency = [self currencyName];

    if ([GYUtils checkStringInvalid:realName]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Real_Name_Empty") confirm:nil];
        return;
    }

    if ([GYUtils checkStringInvalid:payCurrency]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Current_Currency_Empty") confirm:nil];
        return;
    }

    if ([GYUtils checkStringInvalid:self.bankListModel.bankName] ||
        [GYUtils checkStringInvalid:self.bankListModel.bankNo]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Please_Select_Bank") confirm:nil];
        return;
    }

    if ([GYUtils checkStringInvalid:self.countryNo] ||
        [GYUtils checkStringInvalid:self.provinceNo] ||
        [GYUtils checkStringInvalid:self.cityNo]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Please_Select_Account_Area") confirm:nil];
        return;
    }

    if (self.bankNumber.length == 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Bank_Card_Number_Cannot_Empty") confirm:nil];
        return;
    }

    if (self.confirmBankNumber.length == 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Confirm_Card_Number_Cannot_Empty") confirm:nil];
        return;
    }

    if (![self.bankNumber isEqualToString:self.confirmBankNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Card_Number_Not_Agree_Please_Confirm_Again") confirm:nil];
        return;
    }

    if ([GYUtils isValidCreditNumber:self.bankNumber] ||
        [GYUtils isValidCreditNumber:self.confirmBankNumber]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Enter_Bank_Account_Not_Correct") confirm:nil];
        return;
    }
    
    if((self.bankNumber.length < 5 || self.bankNumber.length >30) || (self.confirmBankNumber.length < 5 || self.confirmBankNumber.length >30)) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_Bank_Card_Number5To30") confirm:nil];
        return;
    }
    
    if([GYUtils isIncludeChineseInString:self.bankNumber]) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Bank_Card_Number_Illegal")];
        return;
    }

    [self bindBankAccount:realName bankNumber:self.bankNumber];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];
    if(request.tag == 801) {
        if ([GYUtils checkDictionaryInvalid:responseObject]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_Return_Data_Parsing_Error") confirm:nil];
            return;
        }
        
        GYHSLoginModel* model = [self loginModel];
        model.isBindBank = kAuthHad;
        [[GYHSLoginManager shareInstance] saveLoginModel:model];
        
        NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
        if (returnCode == 200) {
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_Tip_Your_Card_Is_Banding") confirm:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            globalData.loginModel.isBindBank = @"1";
        }
        else {
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_BankCardBoundToFail") confirm:nil];
        }
    }else if(request.tag == 800) {
        if (responseObject) {
            
            self.bankRealName = kSaftToNSString(responseObject[@"data"][@"name"]);
            [self.view addSubview:self.tableView];
            
        }
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYGIFHUD dismiss];
    if(request.tag == 801) {
        [GYUtils parseNetWork:error resultBlock:nil];
    }else if(request.tag == 800) {
        [GYUtils parseNetWork:error resultBlock:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - events response
- (void)citysInfoHandler:(NSNotification*)notification
{
    NSDictionary* paramDic = [notification object];
    DDLogDebug(@"paramDic:%@", paramDic);

    self.countryNo = [paramDic valueForKey:@"countryNo"];
    self.provinceNo = [paramDic valueForKey:@"provinceNo"];
    self.cityNo = [paramDic valueForKey:@"cityNo"];

    NSString* cityInfo = [paramDic valueForKey:@"cityInfo"];
    NSIndexPath* indexPath = [paramDic valueForKey:@"selectIndexPath"];
    [self upateCellValue:indexPath value:cityInfo];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Banding_Bank_Card_Binding");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    if (globalData.loginModel.cardHolder) {
        [self.view addSubview:self.tableView];
    }
}

- (void)bingInfoCellData:(GYHSAddBankCardInfoTableViewCell*)cell dataDic:(NSDictionary*)dataDic indexPath:(NSIndexPath*)indexPath
{
    NSString* title = [dataDic valueForKey:GYHSAddBankCardInfo_Cell_Name];
    NSString* value = [dataDic valueForKey:GYHSAddBankCardInfo_Cell_Value];

    NSString* canEditTextField = [dataDic valueForKey:GYHSAddBankCardInfo_Cell_Attribute];
    BOOL canEnidt = YES;
    if ([canEditTextField isEqualToString:@"NO"]) {
        canEnidt = NO;
    }

    NSString* image = [dataDic valueForKey:GYHSAddBankCardInfo_Cell_Image];
    BOOL isArrow = NO;
    if (![GYUtils checkStringInvalid:image]) {
        NSString* arrowName = [dataDic valueForKey:GYHSAddBankCardInfo_Cell_Image_Arrow];
        if ([@"YES" isEqualToString:arrowName]) {
            isArrow = YES;
        }
    }

    NSString* placeholder = [dataDic valueForKey:GYHSAddBankCardInfo_Cell_Placeholder];

    [cell setCellValue:title
                 value:value
            valueColor:kBlackTextColor
             valueEdit:canEnidt
             imageName:image
           arrowButton:isArrow
           placeholder:placeholder
                   tag:indexPath];

    BOOL keyBoard = [dataDic valueForKey:GYHSAddBankCardInfo_Cell_keyBoardNumber];
    if (keyBoard) {
        [cell numberKeyBoard];
    }

    cell.cellDelegate = self;
}

- (GYHSLoginModel*)loginModel
{
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

- (NSString*)getCustName
{
    GYHSLoginModel* model = [self loginModel];
    return [GYUtils saftToNSString:model.custName];
}

- (NSString*)currencyName
{
    return globalData.custGlobalDataModel.currencyName;
}

- (void)upateCellValue:(NSIndexPath*)indexPath value:(NSString*)value
{
    GYHSAddBankCardInfoTableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setValueInfo:value];
}

- (void)bindBankAccount:(NSString*)realName bankNumber:(NSString*)bankNumber
{

    NSString* url = kUrlBindBank;
    GYHSLoginModel* loginModel = [self loginModel];
    NSDictionary* paramDic = @{
        @"custId" : loginModel.custId,
        @"bankCode" : self.bankListModel.bankNo,
        @"bankName" : self.bankListModel.bankName,
        @"bankAcctNo" : bankNumber,
        @"isDefault" : self.defaultBtn.selected == YES ? @"1" : @"0",
        @"userType" : loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"bankBranch" : @"",
        @"acctType" : @"1",
        @"countryCode" : self.countryNo,
        @"provinceCode" : self.provinceNo,
        @"cityCode" : self.cityNo,
        @"bankAccName" : realName,
        @"hsResNo" : loginModel.resNo
    };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:url parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 801;
    [request setValue:loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 15) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.scrollEnabled =NO;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSAddBankCardInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:GYHSAddBankCardInfo_Cell_Info_Identify];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:GYHSAddBankCardInfo_Cell_Button_Identify];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        [_dataArray addObject:@[
            @{ GYHSAddBankCardInfo_Cell_Name : kLocalized(@"GYHS_Banding_Real_Name"),
                GYHSAddBankCardInfo_Cell_Value : globalData.loginModel.cardHolder ? [self getCustName] : self.bankRealName,
                GYHSAddBankCardInfo_Cell_Attribute : @"NO",
                GYHSAddBankCardInfo_Cell_Image : @"",
                GYHSAddBankCardInfo_Cell_Placeholder : @"",
                GYHSAddBankCardInfo_Cell_keyBoardNumber : [NSNumber numberWithBool:NO]
            },
            @{ GYHSAddBankCardInfo_Cell_Name : kLocalized(@"GYHS_Banding_SettlementCurrency"),
                GYHSAddBankCardInfo_Cell_Value : kSaftToNSString([self currencyName]),
                GYHSAddBankCardInfo_Cell_Attribute : @"NO",
                GYHSAddBankCardInfo_Cell_Image : @"",
                GYHSAddBankCardInfo_Cell_Placeholder : @"",
                GYHSAddBankCardInfo_Cell_keyBoardNumber : [NSNumber numberWithBool:NO]
            },
            @{ GYHSAddBankCardInfo_Cell_Name : kLocalized(@"GYHS_Banding_Bank"),
                GYHSAddBankCardInfo_Cell_Value : @"",
                GYHSAddBankCardInfo_Cell_Attribute : @"NO",
                GYHSAddBankCardInfo_Cell_Image : @"hs_img_bank_icon",
                GYHSAddBankCardInfo_Cell_Image_Arrow : @"NO",
                GYHSAddBankCardInfo_Cell_Placeholder : @"",
                GYHSAddBankCardInfo_Cell_keyBoardNumber : [NSNumber numberWithBool:NO]
            },
            @{ GYHSAddBankCardInfo_Cell_Name : kLocalized(@"GYHS_Banding_Bank_Open_Area"),
                GYHSAddBankCardInfo_Cell_Value : @"",
                GYHSAddBankCardInfo_Cell_Attribute : @"NO",
                GYHSAddBankCardInfo_Cell_Image : @"hs_cell_btn_right_arrow",
                GYHSAddBankCardInfo_Cell_Image_Arrow : @"YES",
                GYHSAddBankCardInfo_Cell_Placeholder : @"",
                GYHSAddBankCardInfo_Cell_keyBoardNumber : [NSNumber numberWithBool:NO]
            },
            @{ GYHSAddBankCardInfo_Cell_Name : kLocalized(@"GYHS_Banding_Bank_Card_Number"),
                GYHSAddBankCardInfo_Cell_Value : @"",
                GYHSAddBankCardInfo_Cell_Attribute : @"YES",
                GYHSAddBankCardInfo_Cell_Image : @"",
                GYHSAddBankCardInfo_Cell_Placeholder : kLocalized(@"GYHS_Banding_EnterTheBankAccount"),
                GYHSAddBankCardInfo_Cell_keyBoardNumber : [NSNumber numberWithBool:YES]
            },
            @{ GYHSAddBankCardInfo_Cell_Name : kLocalized(@"GYHS_Banding_ConfirmCardNumber"),
                GYHSAddBankCardInfo_Cell_Value : @"",
                GYHSAddBankCardInfo_Cell_Attribute : @"YES",
                GYHSAddBankCardInfo_Cell_Image : @"",
                GYHSAddBankCardInfo_Cell_Placeholder : kLocalized(@"GYHS_Banding_EnterTheBankAccountAgain"),
                GYHSAddBankCardInfo_Cell_keyBoardNumber : [NSNumber numberWithBool:YES]
            }
        ]];

        [_dataArray addObject:@[
            @{ GYHSAddBankCardInfo_Cell_Name : kLocalized(@"GYHS_Banding_Rightnow") }
        ]];
    }
    
    return _dataArray;
}

@end
