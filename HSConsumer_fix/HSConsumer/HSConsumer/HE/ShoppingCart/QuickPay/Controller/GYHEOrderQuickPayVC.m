//
//  GYHEOrderQuickPayVC.m
//  HSConsumer
//
//  Created by wangfd on 16/5/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEOrderQuickPayVC.h"
#import "GYHEOrderQuickPayInfoCell.h"
#import "GYHSVConfirmTableCell.h"
#import "GYHSRegisterTableCell.h"
#import "GYBankTableViewCell.h"
#import "GYQuickPayModel.h"
#import "GYHSSMSRequestData.h"
#import "GYResultView.h"
#import "GYEPMyAllOrdersViewController.h"
#import "GYRestaurantOrderViewController.h"
#import "UIButton+GYExtension.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "UIButton+GYTimeOut.h"
#import "GYHSNOLinkQuickPayCardView.h"
#import "GYLinkQuickPayCardViewController.h"

#define kUrlQueryQuickPayBanksList_Tag 100
#define kUrlSendConfirmQuickPay_Tag 101
#define kUrlGetPinganQuickBindBankUrl_Tag 102

@interface GYHEOrderQuickPayVC () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate, GYHSVConfirmTableCellDelegate, GYHSRegisterTableCellDelegate, GYResultViewDelegate,GYLinkQuickPayCardDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYHSSMSRequestData* smsRequest;

@property (nonatomic, strong) NSString* inputSmsCode;
@property (nonatomic, strong) GYQuickPayModel* selectQuickPayModel;
@property (nonatomic, strong) NSString* batchNo;
@property (nonatomic, assign) BOOL isSendSMSCode;

@property (nonatomic, strong) GYHSNOLinkQuickPayCardView *tipsView;
@property (nonatomic, copy) NSString *bindBankUrl;
@property (nonatomic, copy) NSString *returnUrl;

@property (nonatomic, assign) NSInteger oldIndex;

@end

@implementation GYHEOrderQuickPayVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.oldIndex = 0;
    [self initView];
    [self queryQuickBankList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.smsRequest clearTimer];
}

#pragma mark - GYLinkQuickPayCardDelegate
- (void)refreshDataWhenback {
    if (self.tipsView) {
        [self.tipsView removeFromSuperview];
    }
    
    [self queryQuickBankList];
}

#pragma mark - Table view delegate
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
    NSDictionary* dic = nil;
    if (self.dataArray.count > indexPath.section) {
        dic = self.dataArray[indexPath.section][indexPath.row];
    }

    if (indexPath.section == 0) {
        GYHEOrderQuickPayInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHEOrderQuickPayInfoCell_Identify"];

        NSString* name = [dic valueForKey:@"Name"];
        NSString* orderNo = [dic valueForKey:@"Value"];
        NSString* money = [dic valueForKey:@"Money"];
        [cell setCellValue:name orderNum:orderNo money:money];

        return cell;
    }

    // 没有银行列表时为第二段
    NSInteger smsIndex = 1;
    if ([self.dataArray count] == 4) {
        if (indexPath.section == 1) {
            GYBankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYBankTableViewCell_Identify"];
            cell.model = [dic valueForKey:@"Value"];
            BOOL cellState = [[dic valueForKey:@"CellState"] boolValue];
            cell.notSystemSelect = YES;
            [cell setSelectedState:cellState];
            return cell;
        }

        smsIndex = 2;
    }

    if (indexPath.section == smsIndex) {
        GYHSRegisterTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSRegisterTableCell_Identify"];
        NSString* name = [dic valueForKey:@"Name"];
        NSString* value = [dic valueForKey:@"Value"];
        NSString* placeHolder = [dic valueForKey:@"placeHolder"];

        [cell setCellValue:name
                     value:value
               placeHolder:placeHolder
                   pwdType:NO
                   maxSize:6
               keyBoardNum:YES
                showSmsBtn:YES
              showArrowBtn:NO
                 indexPath:indexPath];

        cell.cellDelegate = self;
        return cell;
    }

    GYHSVConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSVConfirmTableCell_Identify"];
    NSString* name = [dic valueForKey:@"Name"];
    [cell setCellName:name];
    cell.cellDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat height = 44.0;
    if (indexPath.section == 0) {
        height = 88.0;
    }

    return height;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section != 1) {
        return;
    }

    if (indexPath.section >= [self.dataArray count]) {
        DDLogDebug(@"The section:%ld more than array:%ld", (long)indexPath.section, (unsigned long)[self.dataArray count]);
        return;
    }

    if (indexPath.row >= [self.dataArray[indexPath.section] count]) {
        DDLogDebug(@"The row:%ld more than array:%ld", (long)indexPath.row, (unsigned long)[self.dataArray[indexPath.section] count]);
        return;
    }
    
    NSArray* bankAry = self.dataArray[indexPath.section];
    for (NSMutableDictionary* indexDic in bankAry) {
        [indexDic setValue:[NSNumber numberWithBool:NO] forKey:@"CellState"];
    }

    NSDictionary* dic = self.dataArray[indexPath.section][indexPath.row];
    self.selectQuickPayModel = [dic valueForKey:@"Value"];
    [dic setValue:[NSNumber numberWithBool:YES] forKey:@"CellState"];
    
    if (indexPath.row != self.oldIndex) {
        [self.smsRequest clearTimer];
    }
    [self.tableView reloadData];
    self.oldIndex = indexPath.row;
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_RequestNetDataFailed")];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (returnCode != 200) {
        DDLogDebug(@"responseObject:%@", responseObject);
        [GYAlertView showMessage:kErrorMsg];
        return;
    }

    if (netRequest.tag == kUrlQueryQuickPayBanksList_Tag) {
        [self parsequeryQuickBankList:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kUrlSendConfirmQuickPay_Tag) {
        [self parseConfirmQuickPay:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kUrlGetPinganQuickBindBankUrl_Tag) {
        self.bindBankUrl = responseObject[@"data"][@"bindBankUrl"];
        self.returnUrl = responseObject[@"data"][@"returnUrl"];
        GYLinkQuickPayCardViewController *vc = [[GYLinkQuickPayCardViewController alloc] init];
        vc.navigationItem.title = kLocalized(@"GYHE_SC_BindQuicklyCard");
        vc.bindBankUrl = self.bindBankUrl;
        vc.returnUrl = self.returnUrl;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"Error:%@", [error localizedDescription]);

    if (netRequest.tag == kUrlSendConfirmQuickPay_Tag) {
        NSInteger errorRetCode = [error code];
        if (errorRetCode == -9000) {
            [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                        confirmBlock:^{
                            if (self.orderType == GYHEOrderQuickPayVCOrderTypeGoods) {
                                GYEPMyAllOrdersViewController* epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
                                epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
                                [self.navigationController pushViewController:epMyOrderVc animated:YES];
                            } else if (self.orderType == GYHEOrderQuickPayVCOrderTypeFood) {
                                GYRestaurantOrderViewController* orderVc = [[GYRestaurantOrderViewController alloc] init];
                                orderVc.strTyp = @"1";
                                [self.navigationController pushViewController:orderVc animated:YES];
                            } else {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }];
        } else {
            [GYAlertView showMessage:kLocalized(@"GYHE_SC_OrderPayFailureWithAgain")];
        }
        return;
    }
    
    NSDictionary* responseObject = netRequest.responseObject;
    NSString* errorMsg = kErrorMsg;

    if ([responseObject[@"retCode"] isEqualToNumber:@204]) {
        
        self.tipsView = [[[NSBundle mainBundle] loadNibNamed:@"GYHSNOLinkQuickPayCardView" owner:self options:nil] lastObject];
        [self.tipsView.linkButton addTarget:self action:@selector(linkQuickCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.tipsView];
        return;
    }
    
    if ([GYUtils checkStringInvalid:errorMsg]) {
        [self parseNetWork:responseObject resultBlock:nil];
    }
    else {
        [GYAlertView showMessage:kErrorMsg];
    }
}

#pragma mark - GYHSVConfirmTableCellDelegate
- (void)confirmButtonAction:(UIButton*)button
{
    [button controlTimeOut];
    [self.view endEditing:YES];
    
    if ([GYUtils checkObjectInvalid:self.selectQuickPayModel]) {
        [GYUtils showToast:kLocalized(@"GYHE_SC_PleaseChooseQuickPayBankList")];
        return;
    }
    if (!self.isSendSMSCode) {
        [GYUtils showToast:kLocalized(@"GYHE_SC_PleaseGetSMSCode")];
        return;
    }
    if ([GYUtils checkStringInvalid:self.inputSmsCode]) {
        [GYUtils showToast:kLocalized(@"GYHE_SC_PleaseInputSMSCode")];
        return;
    }
    if (!(kSaftToNSString(self.inputSmsCode).length == 6)) {
        [GYUtils showToast:kLocalized(@"GYHE_SC_SMSCodeError")];
        return;
    }
    
    if (self.orderType == GYHSCashBuyHSBQuickPay) {
        [self cashBuyHSBQuickPayConfirm];
    } else if (self.orderType == GyHEReApplyCardQuickPay) {
        [self reApplyCardQuickPayConfirm];
    } else if (self.orderType == GyHSQRPayCardQuickPay) {
        [self QRPayQuickPayConfirm];
    } else {
        [self phapiUrlQuickPayConfirm];
    }
}

#pragma mark - GYHSRegisterTableCellDelegate
- (void)buttonAction:(UIButton*)button indexPath:(NSIndexPath*)indexPath
{
    DDLogDebug(@"%s", __FUNCTION__);

    if (indexPath.section != 2) {
        return;
    }

    if ([GYUtils checkObjectInvalid:self.selectQuickPayModel]) {
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_PleaseChooseQuickPayBankList")];
        return;
    }
    
    if (self.orderType == GYHSCashBuyHSBQuickPay) {
        [self cashBuyHSBGetSmsCodeWithButton:button];
    }else if (self.orderType == GyHEReApplyCardQuickPay) {
        [self reApplyCardGetSmsCodeWithButton:button];
    } else if (self.orderType == GyHSQRPayCardQuickPay) {
        [self QRPayGetSmsCodeWithButton:button];
    }else{
        [self phapiUrlGetSmsCodeWithButton:button];
    }

    
}

- (void)inputTextField:(NSString*)value indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section != 2 || indexPath.row != 0) {
        return;
    }

    self.inputSmsCode = value;
}

#pragma mark - GYResultViewDelegate
- (void)ResultViewConfrimButtonClicked:(GYResultView*)ResultView success:(BOOL)success
{
    if (success) {
        if (self.orderType == GYHEOrderQuickPayVCOrderTypeGoods) {
            GYEPMyAllOrdersViewController* epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
            epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
            [self.navigationController pushViewController:epMyOrderVc animated:YES];
        }
        else if (self.orderType == GYHEOrderQuickPayVCOrderTypeFood) {
            GYRestaurantOrderViewController* orderVc = [[GYRestaurantOrderViewController alloc] init];
            orderVc.strTyp = @"1";
            [self.navigationController pushViewController:orderVc animated:YES];
        }
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHE_SC_PaymentConfirmation");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    self.isSendSMSCode = NO;
}

- (void)queryQuickBankList
{
    self.batchNo = @"";
    NSDictionary* paramDic = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,@"bindingChannel":@"P" };

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlListQkBanksByBindingChannel parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];//kUrlListQkBanks
    request.tag = kUrlQueryQuickPayBanksList_Tag;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)parseNetWork:(NSDictionary*)serverDic resultBlock:(void (^)(NSInteger retCode))resultBlock
{
    
    if ([GYUtils checkDictionaryInvalid:serverDic]) {
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_RequestNetDataFailed")];
        return;
    }

    NSString* msg = [serverDic objectForKey:@"msg"];
    if ([GYUtils checkStringInvalid:msg]) {
        msg = kLocalized(@"GYHE_SC_RequestNetDataFailed");
    }
    [GYAlertView showMessage:msg];
}

- (void)parsequeryQuickBankList:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{

    NSArray* serverAry = responseObject[@"data"];
    if ([GYUtils checkArrayInvalid:serverAry] || [serverAry count] <= 0) {

        self.tipsView = [[[NSBundle mainBundle] loadNibNamed:@"GYHSNOLinkQuickPayCardView" owner:self options:nil] lastObject];
        [self.tipsView.linkButton addTarget:self action:@selector(linkQuickCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.tipsView];
        return;
    }

    NSMutableArray* quickAry = [NSMutableArray array];
    NSInteger index = 0;
    BOOL cellState = NO;

    for (NSDictionary* tempDic in serverAry) {
        cellState = NO;
        if (index == 0) {
            cellState = YES;
        }

        GYQuickPayModel* model = [[GYQuickPayModel alloc] initWithDictionary:tempDic error:nil];
        NSMutableDictionary* tmpDic = [NSMutableDictionary dictionary];
        [tmpDic setObject:model forKey:@"Value"];
        [tmpDic setObject:[NSNumber numberWithBool:cellState] forKey:@"CellState"];
        [quickAry addObject:tmpDic];

        if (cellState) {
            self.selectQuickPayModel = model;
        }

        index++;
    }

    if ([quickAry count] > 0) {
        // 刷新时重新加载下数据
        if (self.dataArray.count == 4) {
            [self.dataArray removeObjectAtIndex:1];
        }
        [self.dataArray insertObject:quickAry atIndex:1];
        [self.tableView reloadData];
    }
}

- (void)linkQuickCardBtnClick {
    NSDictionary* paramDic = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId)};
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlGetPinganQuickBindBankUrl parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kUrlGetPinganQuickBindBankUrl_Tag;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)parseConfirmQuickPay:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    [GYAlertView showMessage:kLocalized(@"GYHE_SC_YourOrderPaySuccess") confirmBlock:^{
        if (self.orderType == GYHEOrderQuickPayVCOrderTypeGoods) {
            GYEPMyAllOrdersViewController* epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
            epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
            [self.navigationController pushViewController:epMyOrderVc animated:YES];
        } else if (self.orderType == GYHEOrderQuickPayVCOrderTypeFood) {
            GYRestaurantOrderViewController* orderVc = [[GYRestaurantOrderViewController alloc] init];
            orderVc.strTyp = @"1";
            [self.navigationController pushViewController:orderVc animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (NSString*)getOrderNumber
{
    return kSaftToNSString(self.orderNO);
}

- (NSString*)getAmount
{
    return kSaftToNSString(self.amount);
}

- (void)cashBuyHSBGetSmsCodeWithButton:(UIButton *)button {
    NSDictionary* dict = @{
                           @"transNo" : kSaftToNSString(self.orderNO),
                           @"bindingNo" : kSaftToNSString(self.selectQuickPayModel.signNo),
                           @"bindingChannel" : @"P"
                           };
    self.isSendSMSCode = NO;
    [GYGIFHUD show];
    [self.smsRequest sendSMSCode:kUrlhGetQuickPaymentSmsCode
                        paramDic:dict
                          button:button
                         timeOut:60
                   requestMethod:GYRequestMethodGET
                     resultBLock:^(BOOL result, NSDictionary *serverDic) {
                         if (!result) {
                             [GYAlertView showMessage:kLocalized(@"GYHE_SC_SMSCodeSendFailed")];
                             return;
                         }
                         
                         self.isSendSMSCode = YES;

                     }];

}

- (void)reApplyCardGetSmsCodeWithButton:(UIButton *)button {
    [button controlTimeOut];
    NSDictionary* dict = @{
                           @"bindingNo" : kSaftToNSString(self.selectQuickPayModel.signNo),
                           @"transNo" : kSaftToNSString(self.orderNO),
                           @"bindingChannel" : @"P"
                           };
    
    [GYGIFHUD show];
    [self.smsRequest sendSMSCode:kUrlcGetQuickPaymentSmsCode
                        paramDic:dict
                          button:button
                         timeOut:60
                   requestMethod:GYRequestMethodGET
                     resultBLock:^(BOOL result, NSDictionary *serverDic) {
                         if (!result) {
                             [GYAlertView showMessage:kLocalized(@"GYHE_SC_SMSCodeSendFailed")];
                             return;
                         }
                         
                         self.isSendSMSCode = YES;

                     }];

}

- (void)QRPayGetSmsCodeWithButton:(UIButton *)button {
    
    [button controlTimeOut];
        
    [GYGIFHUD show];
    [self.smsRequest sendSMSCode:[HSReconsitutionUrl stringByAppendingString:@"/customer/pointFinishBanking"]
                        paramDic:@{ @"bindingNo" : kSaftToNSString(self.selectQuickPayModel.signNo),@"transNo" : self.orderNO,@"bindingChannel" : @"P",@"custId":kSaftToNSString(globalData.loginModel.custId)}
                          button:button
                         timeOut:60
                   requestMethod:GYRequestMethodGET
                     resultBLock:^(BOOL result, NSDictionary *serverDic) {
                         if (!result) {
                             [GYAlertView showMessage:kLocalized(@"GYHE_SC_SMSCodeSendFailed")];
                             return;
                         }
                         
                         self.isSendSMSCode = YES;
                         
                     }];

}

- (void)phapiUrlGetSmsCodeWithButton:(UIButton *)button {
    [button controlTimeOut];
    GYHSLoginModel* model = globalData.loginModel;
    NSDictionary* paramDic = @{ @"token" : kSaftToNSString(model.token),
                                @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                                @"custId" : kSaftToNSString(model.custId),
                                @"orderIds" : kSaftToNSString(self.orderNO),
                                @"orderType" : [NSString stringWithFormat:@"%ld", self.orderType],
                                @"tradecAmount" : kSaftToNSString(self.amount),
                                @"bankCardNo" : kSaftToNSString(self.selectQuickPayModel.bankCardNo),
                                @"bankCardType" : kSaftToNSString(self.selectQuickPayModel.bankCardType),
                                @"bankId" : kSaftToNSString(self.selectQuickPayModel.accId),
                                @"bindingNo" : kSaftToNSString(self.selectQuickPayModel.signNo),
                                @"bindingChannel" : @"P"
                                };
    
    self.isSendSMSCode = NO;
    [self.smsRequest sendSMSCode:kUrlSendOrderQuickPaySmsCode
                        paramDic:paramDic
                          button:button timeOut:60
                   requestMethod:GYRequestMethodPOST
                     resultBLock:^(BOOL result, NSDictionary *serverDic) {
        if (!result) {
            [GYAlertView showMessage:kLocalized(@"GYHE_SC_SMSCodeSendFailed")];
            return;
        }
        
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            [GYAlertView showMessage:kLocalized(@"GYHE_SC_GetBatchNoFailed")];
            return;
        }
        
        self.isSendSMSCode = YES;
        self.batchNo = [serverDic valueForKey:@"data"];
    }];
}

- (void)QRPayQuickPayConfirm {
    
    WS(weakSelf)
    NSDictionary *dict = @{ @"bindingNo" : kSaftToNSString(self.selectQuickPayModel.signNo), @"transNo" : self.orderNO, @"smsCode" : kSaftToNSString(self.inputSmsCode), @"custId" : kSaftToNSString(globalData.loginModel.custId), @"bindingChannel" : @"P"};
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/customer/pointQuickPayUrl"] parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }];
            } else if (errorRetCode == 220) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_POSThisDealIsPaid") confirmBlock:^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
            } else if (errorRetCode == 201) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                    
                    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];//设定时间格式,这里可以设置成自己需要的格式
                    
                    NSDate *date = [dateFormat dateFromString:self.model.date];
                    [Network Post:[HSReconsitutionUrl stringByAppendingString:@"/customer/checkOrderIsPay"] hidenHUD:YES parameters:@{ @"entResNo":self.model.entResNo, @"entCustId":self.model.entCustId,  @"sourcePosDate":[GYUtils dateToString:date], @"equipmentNo":self.model.posDeviceNo, @"sourceBatchNo":self.model.batchNo, @"custId" : kSaftToNSString(globalData.loginModel.custId), @"equipmentType":@"2", @"termRunCode":self.model.voucherNo, @"bindingChannel" : @"P"} completion:^(id responseObject, NSError *error) {
                        [GYGIFHUD dismiss];
                        if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
                            if ([responseObject[@"data"] isEqualToString:@"1"]) {
                                [GYAlertView showMessage:kLocalized(@"GYHE_SC_YourOrderPaySuccess") confirmBlock:^{
                                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                }];
                            }else {
                                [GYAlertView showMessage:kLocalized(@"GYHE_SC_OrderPayFailureWithAgain")];
                            }
                        }
                        
                    }];
                });
            } else {
                [GYUtils showToast:kErrorMsg];
            }
            return;
        }
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_YourOrderPaySuccess") confirmBlock:^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)cashBuyHSBQuickPayConfirm {

    NSDictionary* dict = @{
                           @"transNo" : kSaftToNSString(self.orderNO),
                           @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                           @"custId" : kSaftToNSString(globalData.loginModel.custId),
                           //@"transPwd":[self.tfPayPassword.text md5String],
                           @"smsCode" : kSaftToNSString(self.inputSmsCode),
                           @"bindingNo" : kSaftToNSString(self.selectQuickPayModel.signNo),
                           @"bindingChannel" : @"P"
                           };
    
    [GYGIFHUD show];
    WS(weakSelf)
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlhPaymentByQuickPay parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }];
            } else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
        } else {
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_YourOrderPaySuccess") confirmBlock:^{
                    [weakSelf popToViewControllerWithClassName:@"GYHSDToCashAccoutViewController" animated:YES];
                }];
            } else {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_OrderPayFailureWithAgain")];
            }
        }

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)reApplyCardQuickPayConfirm {

    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    
    [allParas setValue:kSaftToNSString(self.orderNO) forKey:@"orderNo"];
    [allParas setValue:@"102" forKey:@"payChannel"];
    [allParas setValue:kSaftToNSString(self.inputSmsCode) forKey:@"smsCode"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kUserTypeCard forKey:@"userType"];
    [allParas setValue:kSaftToNSString(self.selectQuickPayModel.signNo) forKey:@"bindingNo"];
    [allParas setValue:@"P" forKey:@"bindingChannel"];
    
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSCardMendCardPayUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
            } else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
            return;
        }
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_YourOrderPaySuccess")];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)phapiUrlQuickPayConfirm {

    if ([GYUtils checkStringInvalid:self.batchNo]) {
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_DontGetBatchNo")];
        return;
    }
    
    GYHSLoginModel* model = globalData.loginModel;
    NSDictionary* paramDic = @{ @"token" : kSaftToNSString(model.token),
                                @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                                @"custId" : kSaftToNSString(model.custId),
                                @"orderIds" : kSaftToNSString(self.orderNO),
                                @"orderType" : [NSString stringWithFormat:@"%ld", self.orderType],
                                @"tradecAmount" : kSaftToNSString(self.amount),
                                @"smsCode" : kSaftToNSString(self.inputSmsCode),
                                @"batchNo" : kSaftToNSString(self.batchNo),
                                @"bindingNo" : kSaftToNSString(self.selectQuickPayModel.signNo),
                                @"bindingChannel" : @"P"
                                };
    
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlSendConfirmQuickPay parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kUrlSendConfirmQuickPay_Tag;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - getter and setter
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"GYHEOrderQuickPayInfoCell" bundle:nil]
            forCellReuseIdentifier:@"GYHEOrderQuickPayInfoCell_Identify"];

        [_tableView registerNib:[UINib nibWithNibName:@"GYBankTableViewCell" bundle:nil]
            forCellReuseIdentifier:@"GYBankTableViewCell_Identify"];

        [_tableView registerNib:[UINib nibWithNibName:@"GYHSRegisterTableCell" bundle:nil]
            forCellReuseIdentifier:@"GYHSRegisterTableCell_Identify"];

        [_tableView registerNib:[UINib nibWithNibName:@"GYHSVConfirmTableCell" bundle:nil]
            forCellReuseIdentifier:@"GYHSVConfirmTableCell_Identify"];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
        linkLabel.text = kLocalized(@"GYHE_SC_BindQuicklyCard");
        linkLabel.textColor = [UIColor redColor];
        linkLabel.font = [UIFont systemFontOfSize:15.0f];
        UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        backbutton.frame = linkLabel.frame;
        [backbutton addTarget:self action:@selector(linkQuickCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:linkLabel];
        [footerView addSubview:backbutton];
        _tableView.tableFooterView = footerView;

    }

    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];

        [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"GYHE_OrderSubmitSuccessAndPleasePay"),
            @"Value" : [self getOrderNumber],
            @"Money" : [self getAmount],
            @"placeHolder" : @""
        } ]];

        [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"GYHE_SC_SMSCode"),
            @"Value" : @"",
            @"Money" : @"",
            @"placeHolder" : kLocalized(@"GYHE_SC_InputSMSCode")
        } ]];

        [_dataArray addObject:@[ @{ @"Name" : kLocalized(@"GYHE_SC_PaymentRightAway"),
            @"Value" : @"",
            @"Money" : @"",
            @"placeHolder" : @""
        } ]];
    }
    
    return _dataArray;
}

- (GYHSSMSRequestData *) smsRequest {
    if (_smsRequest == nil) {
        _smsRequest = [[GYHSSMSRequestData alloc] init];
    }
    
    return _smsRequest;
}

@end
