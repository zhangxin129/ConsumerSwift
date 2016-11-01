//
//  GYHSBankCardDetailVC.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBankCardDetailVC.h"
#import "GYHSNetworkAPI.h"
#import "GYNetRequest.h"
#import "GYHSLoginManager.h"
#import "GYHSAddBankCardInfoTableViewCell.h"
#import "GYHSButtonCell.h"
#import "GYHSCardBandModel.h"
#import "GYHSLoginModel.h"
#import "GYHSAddressSelectCityDataController.h"
#import "GYHSCityAddressModel.h"
#import "GYHSAlternateModel.h"
#import "GYHSConstant.h"
NSString* const GYHSBankCardDetail_Cell_Button_Identify = @"GYHSBankCardDetail_Cell_Button_Identify";
NSString* const GYHSBankCardDetail_Cell_Info_Identify = @"GYHSBankCardDetail_Cell_Info_Identify";
NSString* const GYHSBankCardDetail_Cell_Name = @"GYHSBankCardDetail_Cell_Name";
NSString* const GYHSBankCardDetail_Cell_Value = @"GYHSBankCardDetail_Cell_Value";
NSString* const GYHSBankCardDetail_Cell_Area = @"GYHSBankCardDetail_Cell_Area";

@interface GYHSBankCardDetailVC () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate, GYHSButtonCellDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYHSAddressSelectCityDataController* selectCityDC;

@end

@implementation GYHSBankCardDetailVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self initDataArray];
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

    NSDictionary* cellDic = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        GYHSAddBankCardInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHSBankCardDetail_Cell_Info_Identify forIndexPath:indexPath];
        [self bingInfoCellData:cell dataDic:cellDic indexPath:indexPath];
        return cell;
    }
    else {

        GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:GYHSBankCardDetail_Cell_Button_Identify forIndexPath:indexPath];
        cell.backgroundColor = kDefaultVCBackgroundColor;
        NSString* title = [cellDic valueForKey:GYHSBankCardDetail_Cell_Name];
        [cell.btnTitle setTitle:kLocalized(title) forState:UIControlStateNormal];
        cell.btnDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([self.carBindModel.isDefault isEqualToString:@"1"]) {
            cell.hidden = YES;
        }
        else {
            cell.hidden = NO;
        }

        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_SetTheDefaultCardFailedPleaseTryAgain")];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (returnCode == 200) {
        WS(weakSelf)

            [GYUtils showToast:@"设置成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHS_Banding_SetTheDefaultCardFailedPleaseTryAgain")];
    }
}

- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

#pragma mark - GYHSButtonCellDelegate
- (void)nextBtn
{
    GYHSLoginModel* model = [self loginModel];
    NSDictionary* paramDic = @{ @"custId" : model.custId,
        @"userType" : model.cardHolder ? kUserTypeCard : kUserTypeNoCard,
        @"accId" : self.carBindModel.accId
    };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlSetDefaultBindBank parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:model.token forHTTPHeaderField:@"token"];
    [request start];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Banding_Bank_Card_Binding");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
}

- (void)initDataArray
{
    
    WS(weakSelf)
        [self.selectCityDC queryCity:self.carBindModel.countryCode
                           prvinceNo:self.carBindModel.provinceCode
                              cityNo:self.carBindModel.cityCode
                         resultBlock:^(GYHSCityAddressModel* model) {
         NSString *cityName = model.cityFullName;
         if ([GYUtils checkStringInvalid:cityName]) {
             cityName = @"";
         }
         
         NSMutableArray *infoAry = [NSMutableArray array];
         [infoAry addObject:@{GYHSBankCardDetail_Cell_Name : kLocalized(@"GYHS_Banding_Real_Name"),
                             GYHSBankCardDetail_Cell_Value : [weakSelf realName]
                              }];
         
         [infoAry addObject:@{GYHSBankCardDetail_Cell_Name : kLocalized(@"GYHS_Banding_SettlementCurrency"),
                             GYHSBankCardDetail_Cell_Value : [weakSelf currencyName]
                              }];
         
         [infoAry addObject:@{GYHSBankCardDetail_Cell_Name : kLocalized(@"GYHS_Banding_Bank"),
                             GYHSBankCardDetail_Cell_Value : [weakSelf bankName]
                              }];
         
         [infoAry addObject:@{GYHSBankCardDetail_Cell_Name : kLocalized(@"GYHS_Banding_Bank_Open_Area"),
                             GYHSBankCardDetail_Cell_Value : cityName
                              }];
         
         [infoAry addObject:@{GYHSBankCardDetail_Cell_Name : kLocalized(@"GYHS_Banding_Bank_Card_Number"),
                             GYHSBankCardDetail_Cell_Value : [weakSelf bankNumber]
                              }];
         [_dataArray addObject:infoAry];
         
         [_dataArray addObject:@[
                                 @{GYHSBankCardDetail_Cell_Name : kLocalized(@"GYHS_Banding_Default_Card")}
                                 ]];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.tableView reloadData];
         });
                         }];
}

- (NSString*)realName
{
    NSMutableString* star = [[NSMutableString alloc] initWithString:@"*"];
    if (self.carBindModel.realName.length != 0) {
        for (NSInteger i = 1; i < self.carBindModel.realName.length - 1; i++) {
            [star appendString:@"*"];
        }
    }
    else {
        return @"";
    }
    return kSaftToNSString([[self.carBindModel.realName substringToIndex:1] stringByAppendingString:star]);
}

- (NSString*)currencyName
{
    return kSaftToNSString(globalData.custGlobalDataModel.currencyName);
}

- (NSString*)bankName
{
    if ([GYUtils checkStringInvalid:self.carBindModel.bankName]) {
        return @"";
    }

    return kSaftToNSString(self.carBindModel.bankName);
}

- (NSString*)bankNumber
{
    if ([GYUtils checkStringInvalid:self.carBindModel.bankAccNo]) {
        return @"";
    }

    NSString* cardNumber = @"";
    if (self.carBindModel.bankAccNo.length > 8) {
        cardNumber = [[[self.carBindModel.bankAccNo substringToIndex:4] stringByAppendingString:@"**** ****"] stringByAppendingString:[self.carBindModel.bankAccNo substringFromIndex:self.carBindModel.bankAccNo.length - 4]];
    }
    else {
        cardNumber = self.carBindModel.bankAccNo;
    }

    return kSaftToNSString(cardNumber);
}

- (GYHSLoginModel*)loginModel
{
    return [[GYHSLoginManager shareInstance] loginModuleObject];
}

- (void)bingInfoCellData:(GYHSAddBankCardInfoTableViewCell*)cell dataDic:(NSDictionary*)dataDic indexPath:(NSIndexPath*)indexPath
{
    NSString* title = [dataDic valueForKey:GYHSBankCardDetail_Cell_Name];
    NSString* value = [dataDic valueForKey:GYHSBankCardDetail_Cell_Value];

    [cell setCellValue:title
                 value:value
            valueColor:kBlackTextColor
             valueEdit:NO
             imageName:@""
           arrowButton:NO
           placeholder:@""
                   tag:indexPath];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 15) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;

        [_tableView registerNib:[UINib nibWithNibName:@"GYHSAddBankCardInfoTableViewCell" bundle:nil] forCellReuseIdentifier:GYHSBankCardDetail_Cell_Info_Identify];
        [_tableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:GYHSBankCardDetail_Cell_Button_Identify];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }

    return _dataArray;
}

- (GYHSAddressSelectCityDataController*)selectCityDC
{
    if (_selectCityDC == nil) {
        _selectCityDC = [[GYHSAddressSelectCityDataController alloc] init];
    }

    return _selectCityDC;
}

@end
