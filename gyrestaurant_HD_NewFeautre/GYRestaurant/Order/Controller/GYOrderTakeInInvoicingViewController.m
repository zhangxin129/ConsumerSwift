//
//  GYOrderTakeInInvoicingViewController.m
//  GYRestaurant
//
//  Created by apple on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderTakeInInvoicingViewController.h"
#import "GYOrderListModel.h"
#import "GYOrderStoreInvoicingView.h"
#import "GYOrderManagerViewModel.h"
#import "GYOrderInDetailViewController.h"
#import "GYOrdDetailModel.h"

@interface GYOrderTakeInInvoicingViewController ()

@property (nonatomic, weak)GYOrderStoreInvoicingView *osiView;
@property (nonatomic, strong)GYOrdDetailModel *model;
@property (nonatomic, weak) UIButton * cashSettlementBtn;
@end

@implementation GYOrderTakeInInvoicingViewController
#pragma mark - 继承系统
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self RequestOderDetailData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationItemSetting];
    [self viewSetting];
}


#pragma mark - 视图初始化
//导航栏
- (void)navigationItemSetting{
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"Storesettlement") withTarget:self withAction:@selector(popBack)];
}

//view
-(void)viewSetting{
    @weakify(self);
    GYOrderStoreInvoicingView *mainView = [[[NSBundle mainBundle] loadNibNamed:@"GYOrderStoreInvoicingView" owner:self options:nil] objectAtIndex:0];
    self.osiView = mainView;
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];

    int a = (kScreenWidth - 150 *3 - 200)/4;
    UIButton *changeOrdersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeOrdersBtn.layer.cornerRadius = 5;
    changeOrdersBtn.layer.borderWidth = 2;
    changeOrdersBtn.layer.borderColor = [UIColor clearColor].CGColor;
    changeOrdersBtn.backgroundColor = [UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    changeOrdersBtn.tag = 100;
    [changeOrdersBtn setAttributedTitle: [[NSAttributedString alloc] initWithString:kLocalized(@"ChangeOrder") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21], NSForegroundColorAttributeName:kDeepBlueFontColor}] forState:UIControlStateNormal];
    [changeOrdersBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeOrdersBtn];
    [changeOrdersBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.view.mas_left).offset(a +100);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    
    UIButton *makepreliminaryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    makepreliminaryBtn.layer.cornerRadius = 5;
    makepreliminaryBtn.layer.borderWidth = 2;
    makepreliminaryBtn.layer.borderColor = [UIColor clearColor].CGColor;
    makepreliminaryBtn.backgroundColor = [UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    makepreliminaryBtn.tag = 101;
    [makepreliminaryBtn setAttributedTitle: [[NSAttributedString alloc] initWithString:kLocalized(@"Pre-fightstatements") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21], NSForegroundColorAttributeName:kDeepBlueFontColor}] forState:UIControlStateNormal];
    [makepreliminaryBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:makepreliminaryBtn];
    [makepreliminaryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(changeOrdersBtn.mas_right).offset(a);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    
    UIButton *cashSettlementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cashSettlementBtn.layer.cornerRadius = 5;
    cashSettlementBtn.layer.borderWidth = 2;
    cashSettlementBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [cashSettlementBtn setTitle:kLocalized(@"PayMoney") forState:UIControlStateNormal];
    cashSettlementBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    cashSettlementBtn.backgroundColor = kRedFontColor;
    [cashSettlementBtn setTintColor:kBlueFontColor];
    cashSettlementBtn.tag = 102;
    [cashSettlementBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cashSettlementBtn];
    [cashSettlementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(makepreliminaryBtn.mas_right).offset(a);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    cashSettlementBtn.hidden = YES;
    self.cashSettlementBtn = cashSettlementBtn;
}


#pragma mark - btnAction
//返回
- (void)popBack{
    
    UIViewController *v = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"GYOrderViewController")]) {
            v = vc;
        }else if([vc isKindOfClass:NSClassFromString(@"GYOrderInDetailViewController")]){
        
            v = vc;
        }else if ([vc isKindOfClass:NSClassFromString(@"GYQueryViewController")]){
            v = vc;
        
        }
    }
    if (v) {
        [self.navigationController popToViewController:v animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}

-(void)pop{

    UIViewController *v = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"GYOrderViewController")]) {
            v = vc;
        }else if ([vc isKindOfClass:NSClassFromString(@"GYQueryViewController")]){
            v = vc;
            
        }
    }
    if (v) {
        [self.navigationController popToViewController:v animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)btnAction:(UIButton *)btn{
    
    //修改订单
    if (btn.tag == 100) {
        if (self.isPush == YES) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            GYOrderInDetailViewController *vc = [[GYOrderInDetailViewController alloc] init];
            vc.infoDic = self.infoDic;
            vc.status = kLocalized(@"ToBeCheckout");
            vc.strType = kLocalized(@"Store");
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    @weakify(self);
    //打预结单
    if (btn.tag == 101) {
        NSString *str;
        if ([self.model.orderStatus isEqualToString:kLocalized(@"Untilcheckout,ithastoplayasingle")]) {
            str = kLocalized(@"OKagaintoplaythepre-invoice?");
        }else{
            str = kLocalized(@"Determinedtoplayapre-invoice?");
        }
        if (_osiView.serviceContentTextFild.text.length > 0 && _osiView.servicePayTextFild.text.length == 0) {
            [self notifyWithText:kLocalized(@"PleaseEnterDifferentAmountOfServices!")];
        }else if(_osiView.serviceContentTextFild.text.length == 0 && _osiView.servicePayTextFild.text.length > 0){
            [self notifyWithText:kLocalized(@"PleaseEnterDifferentServiceProjectOfServices!")];
        }else{
            GYAlertView *alert = [[GYAlertView alloc] initWithTitle:str contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
            [alert show];
            alert.rightBlock = ^{
                
                @strongify(self);
                [self sendOrderMessage:btn];
                
            };

        }
        
    }
    
    //现金结账
    if (btn.tag == 102) {
        if (_osiView.serviceContentTextFild.text.length > 0 && _osiView.servicePayTextFild.text.length == 0) {
            [self notifyWithText:kLocalized(@"PleaseEnterDifferentAmountOfServices!")];
        }else if(_osiView.serviceContentTextFild.text.length == 0 && _osiView.servicePayTextFild.text.length > 0){
            [self notifyWithText:kLocalized(@"PleaseEnterDifferentServiceProjectOfServices!")];
        }else if(_osiView.returnDepositBtn.selected == YES){
        GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToSettleAccounts"), @"？") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
        [alert show];
        alert.rightBlock = ^{
            @strongify(self);
            [self payOrderByCash:btn];
        };
        
        }else if ([_osiView.discountedAmountTextFild.text intValue] <= [_osiView.receivedDepositLabel.text intValue]){
            if (_osiView.useDepositBtn.selected == YES) {
                GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToSettleAccounts"), @"？") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
                [alert show];
                alert.rightBlock = ^{
                    @strongify(self);
                    [self payOrderByCash:btn];
                };
 
            }
        }else if ([_osiView.discountedAmountTextFild.text intValue] > [_osiView.receivedDepositLabel.text intValue] && [_osiView.receivedDepositLabel.text intValue] != 0){
            if (_osiView.useDepositBtn.selected == YES) {
                GYAlertView *alert = [[GYAlertView alloc] initWithTitle:nil contentText:kLocalized(@"LackOfDownPaymentPaidInCashToDetermine") leftButtonTitle:nil rightButtonTitle:kLocalized(@"Determine")];
                alert.lineView.hidden = YES;
                alert.bottomLineView.hidden = NO;
                alert.alertContentLabel.textAlignment = NSTextAlignmentCenter;
                alert.alertContentLabel.font = [UIFont systemFontOfSize:20.0f];
                [alert.rightbtn setBackgroundColor:[UIColor redColor]];
                [alert.rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [alert show];
                
            }

        }else if ([_osiView.receivedDepositLabel.text intValue] == 0){
            GYAlertView *alert = [[GYAlertView alloc] initWithTitle:kLocalizedAddParams(kLocalized(@"AreYouSureToSettleAccounts"), @"？") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
            [alert show];
            alert.rightBlock = ^{
                @strongify(self);
                [self payOrderByCash:btn];
            };

        }
    }
}

#pragma mark - private method
/** 判断字典是否符合要求*/
- (BOOL)isFitDic:(NSMutableDictionary*)dic{
    NSString *strOrderPayCount = self.osiView.orderPayCount;
    int fOrderPayCount, fAmountOther,fticketNumber = 0;
    float fDiscountRate;
    fOrderPayCount = [strOrderPayCount intValue];
    
    if (dic[@"discountRate"]) {
        fDiscountRate = [dic[@"discountRate"] floatValue];
        if (dic[@"discountRate"] && (fDiscountRate < 0.5 || fDiscountRate > 1)) {
            [self notifyWithText:kLocalized(@"TheDiscountRateShouldBeBetween50% -100%")];
            return NO;
        }
    }
    if (dic[@"ticketNumber"]) {
        fticketNumber = [dic[@"ticketNumber"] intValue];
        if (![Utils checkIsNumber:dic[@"ticketNumber"]]) {
            [self notifyWithText:kLocalized(@"HS-voucherNumberOfSheetsMustBeANon-negativeInteger")];
            return NO;
        }
        
        if (dic[@"amountOther"]) {
            fAmountOther = [dic[@"amountOther"] intValue];
            NSString *regex = @"^[0-9]+(.[0-9]{1,2})?$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (![predicate evaluateWithObject:dic[@"amountOther"]]) {
                
                [self notifyWithText:kLocalized(@"OtherServicesAtMostAmountToTheCents")];
                return NO;
            }
            
            if ((fOrderPayCount + fAmountOther)/2 <= fticketNumber *10) {
                [self notifyWithText:kLocalized(@"StoreDiscountCanNotExceedHalfOfTheTotal")];
                return NO;
            }
        }else{
            if (fOrderPayCount/2 <= (int)fticketNumber *10) {
                [self notifyWithText:kLocalized(@"StoreDiscountCanNotExceedHalfOfTheTotal")];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 网络请求
/**请求订单详情数据*/
-(void)RequestOderDetailData{
    @weakify(self);
    GYOrderManagerViewModel *orderListDetail = [[GYOrderManagerViewModel alloc]init];
    [self modelRequestNetwork:orderListDetail :^(id resultDic) {
        @strongify(self);
        self.model = resultDic[0];
        if ([self.model.orderStatus isEqualToString:kLocalized(@"Untilcheckout,ithastoplayasingle")]) {
            self.cashSettlementBtn.hidden = NO;
        }else{
            self.cashSettlementBtn.hidden = YES;
        }
        [self.osiView loadViewData:resultDic[0]];
    } isIndicator:YES];
    [orderListDetail GetOrderDetailWithUserIdId:_infoDic[@"userId"] orderId:_infoDic[@"orderId"]];
}

/**打预结单*/
- (void)sendOrderMessage:(UIButton *)button{
    @weakify(self);
    NSMutableDictionary *dic = [self.osiView getViewSendOrderMessageDic];
    if (![self isFitDic:dic]) {
        return;
    }
    [dic setValue:_infoDic[@"userId"] forKey:@"userId"];
    [dic setValue:_infoDic[@"orderId"] forKey:@"orderId"];
    GYOrderManagerViewModel *manager = [[GYOrderManagerViewModel alloc]init];
    [button controlTimeOut];
    [self modelRequestNetwork:manager :^(id resultDic) {
       @strongify(self);
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
           [self notifyWithText:kLocalized(@"Thesuccessofthepre-fightstatements")];
            [self RequestOderDetailData];
        }else if([resultDic[@"retCode"] isEqualToNumber:@777]){
            [self notifyWithText:kLocalized(@"Printstatementstoomanytimes")];
            [self.osiView loadViewData:self.model];
        }else{
            [self notifyWithText:kLocalized(@"Pre-fightstatementsfail")];
        }
        
    } isIndicator:YES];
    
    [manager sendOrderMessageWithParams:dic];

}

/**现金结账*/
- (void)payOrderByCash:(UIButton *)button {
    @weakify(self);
    NSMutableDictionary *dic = [self.osiView getViewSendOrderMessageDic];
    if (![self isFitDic:dic]) {
        return;
    }
    GYOrderManagerViewModel *vmodel = [[GYOrderManagerViewModel alloc] init];
    [button controlTimeOut];
    [self modelRequestNetwork:vmodel :^(id resultDic) {
        @strongify(self);
        
        if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
           
            [self notifyWithText:kLocalized(@"CheckoutSuccess")];
            [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
         
        }else if ([resultDic[@"retCode"] isEqualToNumber:@590]){
            [self notifyWithText:kLocalized(@"CashCheckoutFailure,LackOfIntegrationPrepaidAccountBalance! PleasePromptlyRecharge!")];
        }else if ([resultDic[@"retCode"] isEqualToNumber:@589]){
            [self notifyWithText:kLocalized(@"CorporateAccountBalanceIsInsufficient")];
        }else{
            [self notifyWithText:kLocalized(@"Checkoutfailure")];
        }
        
    } isIndicator:YES ];
    
    [vmodel orderPayWithUserId:_infoDic[@"userId"] withOrderId:_infoDic[@"orderId"] withDic:dic];
}

@end
