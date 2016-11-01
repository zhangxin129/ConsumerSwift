//
//  GYOrderStoreInvoicingView.m
//  GYRestaurant
//
//  Created by apple on 15/10/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYOrderStoreInvoicingView.h"
#import "GYOrdDetailModel.h"
#import "NSString+GYJSONObject.h"

@interface GYOrderStoreInvoicingView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *resNoLabel;//互生号／手机号
@property (weak, nonatomic) IBOutlet UILabel *orderPayCountLabel;//订单金额
@property (weak, nonatomic) IBOutlet UILabel *pvLabel;//积分
@property (weak, nonatomic) IBOutlet UILabel *settlementAmountLabel;//结算金额
@property (weak, nonatomic) IBOutlet UILabel *hsRebateTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *hsRebateTextFild;//互生抵扣券输入框
@property (weak, nonatomic) IBOutlet UILabel *hsRebateUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;//折扣率
@property (weak, nonatomic) IBOutlet UILabel *discountUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDepositTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDepositLabel;//退还定金
@property (weak, nonatomic) IBOutlet UIImageView *returnDepositImgView;
@property (weak, nonatomic) IBOutlet UILabel *AccountsReceivableAmountLabel;//应收金额
@property (weak, nonatomic) IBOutlet UIButton *hsRebateBtn;//抵扣券按钮
@property (weak, nonatomic) IBOutlet UIButton *discountBtn;//店内折扣按钮

@property (nonatomic, strong)GYOrdDetailModel* model;
@end

@implementation GYOrderStoreInvoicingView

#pragma mark - 为界面添加数据
/**为页面添加数据*/
- (void)loadViewData:(GYOrdDetailModel*)model{
    self.model = model;
    self.orderLabel.text = model.orderId;
    self.resNoLabel.text = model.resNo;
    self.orderPayCountLabel.text = model.totalAmount;
    self.orderPayCount = model.totalAmount;;
    self.pvLabel.text = model.totalPv;
   // self.pvLabel.tintColor = kBlueFontColor;
    self.settlementAmountLabel.text = model.totalAmount;
    self.AccountsReceivableAmountLabel.text = model.totalAmount;
    self.receivedDepositLabel.text = model.prePayAmount;
    
    self.hsRebateTextFild.delegate = self;
    self.discountTextField.delegate = self;
    self.servicePayTextFild.delegate = self;
    self.serviceContentTextFild.delegate = self;
    [self.serviceContentTextFild addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    
    self.discountedAmountTextFild.font = [UIFont systemFontOfSize:18];
    if ([model.prePayAmount doubleValue] == 0) {
        self.useDepositBtn.hidden = YES;
        self.returnDepositBtn.hidden = YES;
    }
    
    if ([model.orderStatus isEqualToString:kLocalized(@"Untilcheckout,ithastoplayasingle")]) {
        self.serviceContentTextFild.text = model.amountOtherMsg;
     
        self.servicePayTextFild.text = model.amountOther;
        
        if ([model.discountType isEqualToString:@"2"]) {
            self.discountTextField.text = [NSString stringWithFormat:@"%.0f",[model.discountRate doubleValue]*100];
            self.discountBtn.selected = NO;
            [self discountWayAction:self.discountBtn];
        }else if ([model.discountType isEqualToString:@"1"]) {
            NSDictionary *coponInfoDic = [model.couponInfo dictionaryValue];
            self.hsRebateTextFild.text = [coponInfoDic[@"num"] stringValue];
          // self.hsRebateTextFild.text = model.couponInfo.num;
            self.hsRebateBtn.selected = NO;
            [self discountWayAction:self.hsRebateBtn];
        }else if ([model.discountType isEqualToString:@"0"]) {
            self.discountedAmountTextFild.text = self.settlementAmountLabel.text;
            [self hsRebateIsHide:YES];
            [self discountIsHide:YES];
        }
        
        if ([model.checkOutType isEqualToString:@"1"]) {
            [self depositAction:self.useDepositBtn];
        }
        if ([model.checkOutType isEqualToString:@"2"]) {
             [self depositAction:self.returnDepositBtn];
        }
        
        if ([model.checkOutType isEqualToString:@"0"]) {
            [self returnDeposit:YES];
        }
    }else{
        //自动调用按钮 选择默认的行为方式
        if ([model.checkOutType isEqualToString:@"0"]) {//没有定金不显示
            [self returnDeposit:YES];
        }else{
            [self depositAction:self.useDepositBtn];
        }
        
        self.discountedAmountTextFild.text = self.settlementAmountLabel.text;
        
        [self hsRebateIsHide:YES];
        [self discountIsHide:YES];
//        [self returnDeposit:YES];
    }

}

-(void)change:(UITextField *)text
{
    DDLogCInfo(@"%@",text);
    if (text.text.length>6) {

        text.text = [text.text substringToIndex:6];
    }
}

#pragma mark - 传打单 结单的字典
/**
 * 获取打预结单字典
 */
- (NSMutableDictionary *)getViewSendOrderMessageDic{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"orderType"];
    [dic setValue:globalData.attribute.currencyCode forKey:@"currency"];

    if (self.hsRebateBtn.selected) {
        [dic setValue:@"1" forKey:@"discountType"];
        [dic setValue:@"10" forKey:@"ticketValue"];
        [dic setValue:self.hsRebateTextFild.text  forKey:@"ticketNumber"];
    }else if (self.discountBtn.selected){
        [dic setValue:@"2" forKey:@"discountType"];
        NSString *str = [NSString stringWithFormat:@"%.4f",[self.discountTextField.text doubleValue] / 100];
        [dic setValue:str forKey:@"discountRate"];
        float fsssmoney = [self.discountedAmountTextFild.text doubleValue];
        fsssmoney = roundf(fsssmoney*10);
        fsssmoney = fsssmoney*.1;
        float mmmoney = [self.settlementAmountLabel.text doubleValue];
        [dic setValue:[NSString stringWithFormat:@"%.1f", mmmoney - fsssmoney] forKey:@"amountCoupon"];
    
    }else{
        [dic setValue:@"0" forKey:@"discountType"];
    }
    
    
    if (self.returnDepositBtn.selected == YES) {
        [dic setValue:@"2" forKey:@"checkOutType"];
        [dic setValue:self.returnDepositLabel.text forKey:@"moneyEarnestRefund"];
    }else if(self.useDepositBtn.selected == YES){
        [dic setValue:@"1" forKey:@"checkOutType"];
        if ([self.returnDepositLabel.text doubleValue] > 0) {
            [dic setValue:self.returnDepositLabel.text forKey:@"moneyEarnestRefund"];
        }
    }else{
        [dic setValue:@"0" forKey:@"checkOutType"];
    }
    
    if (self.servicePayTextFild.text.length > 0) {
        [dic setValue:self.serviceContentTextFild.text forKey:@"amountOtherMsg"];
        [dic setValue:[self siSheWuRuwithString:self.servicePayTextFild.text] forKey:@"amountOther"];
    }
    [dic setValue:[self siSheWuRuwithString:self.AccountsReceivableAmountLabel.text] forKey:@"amountActually"];
    return dic;
}

#pragma mark - 判断显示与否
/**互生抵扣券*/
- (void)hsRebateIsHide:(BOOL)isHide{
    if (isHide) {
        self.hsRebateTextFild.hidden = YES;
        self.hsRebateTitleLabel.hidden = YES;
        self.hsRebateUnitLabel.hidden = YES;
    }else{
        self.hsRebateTextFild.hidden = NO;
        self.hsRebateTitleLabel.hidden = NO;
        self.hsRebateUnitLabel.hidden = NO;
    }
}


/**店内折扣*/
- (void)discountIsHide:(BOOL)isHide{
    if (isHide) {
        self.discountTextField.hidden = YES;
        self.discountTitleLabel.hidden = YES;
        self.discountUnitLabel.hidden = YES;
    }else{
        self.discountTextField.hidden = NO;
        self.discountTitleLabel.hidden = NO;
        self.discountUnitLabel.hidden = NO;
    }
}

/**退还定金*/
- (void)returnDeposit:(BOOL)isReturnShow{
    if (isReturnShow) {
        self.returnDepositImgView.hidden = YES;
        self.returnDepositLabel.hidden = YES;
        self.returnDepositTitleLabel.hidden = YES;
    }else{
        self.returnDepositImgView.hidden = NO;
        self.returnDepositLabel.hidden = NO;
        self.returnDepositTitleLabel.hidden = NO;
    }
}

#pragma mark - 计算并刷新界面的数据
- (IBAction)amountOfCalculation {
    //订单金额
    //  float orderPayCount = [self.orderPayCountLabel.text doubleValue];
    NSDecimalNumber *orderPayCount = [NSDecimalNumber decimalNumberWithString:self.orderPayCountLabel.text];
    //要返还的定金
    //    float returnDeposit = [self.model.prePayAmount doubleValue];
    NSDecimalNumber *returnDeposit = [NSDecimalNumber decimalNumberWithString:self.model.prePayAmount];
    //服务费
    //    float servicePay = [self.servicePayTextFild.text doubleValue];
    NSDecimalNumber *servicePay;
    if (self.servicePayTextFild.text.length == 0) {
        if ([servicePay compare:[NSDecimalNumber zero]] == NSOrderedSame || [[NSDecimalNumber notANumber] isEqualToNumber:servicePay]) {
            servicePay = [NSDecimalNumber zero];
        }
    }else if (self.servicePayTextFild.text.length > 0 ){
        
        servicePay = [NSDecimalNumber decimalNumberWithString:self.servicePayTextFild.text];
    }
    //抵扣券张数
    //    float hsRebate = [self.hsRebateTextFild.text doubleValue];
    NSDecimalNumber *hsRebate;
    if (self.hsRebateTextFild.text.length == 0) {
        hsRebate = [NSDecimalNumber zero];
    }else if (self.hsRebateTextFild.text.length > 0){
        hsRebate = [NSDecimalNumber decimalNumberWithString:self.hsRebateTextFild.text];
    }
    //折扣率
    //    float discount = [self.discountTextField.text doubleValue];
    NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:self.discountTextField.text];
    NSDecimalNumber *percent = [NSDecimalNumber decimalNumberWithString:@"100"];
    
    NSDecimalNumber *perDiscount;
    if (self.discountTextField.text.length == 0) {
        if ([perDiscount compare:[NSDecimalNumber zero]] == NSOrderedSame || [[NSDecimalNumber notANumber] isEqualToNumber:perDiscount]) {
            perDiscount = [NSDecimalNumber zero];
        }
    }else if (self.discountTextField.text.length > 0){
        perDiscount = [discount decimalNumberByDividingBy:percent];
    }
    //    if ([perDiscount compare:[NSDecimalNumber zero]] == NSOrderedSame || [[NSDecimalNumber notANumber] isEqualToNumber:perDiscount]) {
    //        perDiscount = [NSDecimalNumber zero];
    //    }else{
    //       perDiscount = [discount decimalNumberByDividingBy:percent];
    //    }
    //   NSDecimalNumber *perDiscount = [discount decimalNumberByDividingBy:percent];
    
    //消费结算金额
    
    //    NSString *strSettlementAmount = [self siSheWuRuwithString:[NSString stringWithFormat:@"%.3f",orderPayCount+ servicePay]];
    
    //    NSDecimalNumber *settlementAmountSum;
    //    if ([settlementAmountSum compare:[NSDecimalNumber zero]] == NSOrderedSame || [[NSDecimalNumber notANumber] isEqualToNumber:settlementAmountSum]) {
    //        settlementAmountSum = [NSDecimalNumber zero];
    //    }else{
    //        settlementAmountSum = [orderPayCount decimalNumberByAdding:servicePay withBehavior:kRoundUp]
    //    }
    NSDecimalNumber *settlementAmountSum = [orderPayCount decimalNumberByAdding:servicePay withBehavior:kRoundUp];
    self.settlementAmountLabel.text = [settlementAmountSum stringValue];
    //    float settlementAmount = [self.settlementAmountLabel.text doubleValue];
    NSDecimalNumber *settlementAmount = [NSDecimalNumber decimalNumberWithString:self.settlementAmountLabel.text];
    NSString *strDiscountedAmount;
    if (self.hsRebateBtn.selected == YES) {
        //        strDiscountedAmount = [NSString stringWithFormat:@"%.2f",settlementAmount- hsRebate*10];
        NSDecimalNumber *hsRebateValue = [NSDecimalNumber decimalNumberWithString:@"10"];
        NSDecimalNumber *hsRebateNum = [hsRebate decimalNumberByMultiplyingBy:hsRebateValue];
        strDiscountedAmount = [[settlementAmount decimalNumberBySubtracting:hsRebateNum] stringValue];
        self.discountedAmountTextFild.text = strDiscountedAmount;
    }else if(self.discountBtn.selected == YES){
        if (self.discountTextField.text.length == 0) {
            strDiscountedAmount = self.settlementAmountLabel.text;
            self.discountedAmountTextFild.text = strDiscountedAmount;
        }else{
            //            sDiscountedAmount = [NSString stringWithFormat:@"%.2f",orderPayCount *(discount /100) +servicePay ];
            strDiscountedAmount = [[[orderPayCount decimalNumberByMultiplyingBy:perDiscount withBehavior:kRoundUp] decimalNumberByAdding:servicePay withBehavior:kRoundUp] stringValue];
            
            //            self.discountedAmountTextFild.text = [self siSheWuRuwithString:strDiscountedAmount];
            self.discountedAmountTextFild.text = strDiscountedAmount;
            
        }
        
    }else{
        self.discountedAmountTextFild.text = self.settlementAmountLabel.text;
    }
    
    
    //折后金额
    //    float discountedAmount = [self.discountedAmountTextFild.text doubleValue];
    NSDecimalNumber *discountedAmount = [NSDecimalNumber decimalNumberWithString:self.discountedAmountTextFild.text];
    NSString *strAccountsReceivableAmount;
    if (self.useDepositBtn.selected == YES) {
        
        if ([[discountedAmount decimalNumberBySubtracting:returnDeposit] doubleValue] < 0) {
            
            strAccountsReceivableAmount = @"0.00";
            [self returnDeposit:NO];
            //            self.returnDepositLabel.text = [NSString stringWithFormat:@"%.2f",returnDeposit-discountedAmount];
            self.returnDepositLabel.text = [[returnDeposit decimalNumberBySubtracting:discountedAmount withBehavior:kRoundUp] stringValue];
            
        }else{
            [self returnDeposit:YES];
            //            strAccountsReceivableAmount = [NSString stringWithFormat:@"%.2f",discountedAmount -returnDeposit];
            strAccountsReceivableAmount = [[discountedAmount decimalNumberBySubtracting:returnDeposit withBehavior:kRoundUp] stringValue];
        }
    }else{
        self.returnDepositLabel.text = self.model.prePayAmount;
        //        strAccountsReceivableAmount = [NSString stringWithFormat:@"%.2f",discountedAmount];
        strAccountsReceivableAmount = [discountedAmount stringValue];
    }
    
    //    self.AccountsReceivableAmountLabel.text = [self siSheWuRuwithString:strAccountsReceivableAmount];
    self.AccountsReceivableAmountLabel.text = strAccountsReceivableAmount;
}

#pragma mark - btnAction
/**选个折扣方式*/
- (IBAction)discountWayAction:(UIButton *)sender {
    //互生抵扣券
    if (sender.tag == 1000) {
        sender.selected = !sender.selected;
        if (sender.selected == YES) {
            [self hsRebateIsHide:NO];
            [self discountIsHide:YES];
            self.discountBtn.selected = NO;
        }else{
            self.hsRebateBtn.selected = NO;
            self.hsRebateTextFild.text = nil;
            [self hsRebateIsHide:YES];
            [self discountIsHide:YES];
            
        }
        [self amountOfCalculation];
    }
    
    //店内折扣
    if (sender.tag == 1001) {
        sender.selected = !sender.selected;
        if (sender.selected == YES) {
            [self hsRebateIsHide:YES];
            [self discountIsHide:NO];
            self.hsRebateBtn.selected = NO;
        }else{
            self.discountBtn.selected = NO;
            self.discountTextField.text = nil;
            [self hsRebateIsHide:YES];
            [self discountIsHide:YES];
        }
        [self amountOfCalculation];
    }

}

/**是否退还定金*/
- (IBAction)depositAction:(UIButton *)sender {
    //定金支付
    if (sender.tag == 1003) {
        sender.selected = !sender.selected;
        if (sender.selected == YES) {
            [self returnDeposit:YES];
            self.returnDepositBtn.selected = NO;
        }else{
            self.useDepositBtn.selected = YES;
        }
    }
    
    //退还定金
    if (sender.tag == 1004) {
        sender.selected = !sender.selected;
        if (sender.selected == YES) {
            [self returnDeposit:NO];
            self.useDepositBtn.selected = NO;
        }else{
            self.returnDepositBtn.selected = YES;
        }
    }
    [self amountOfCalculation];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //互生抵扣券数量
    if (textField.tag == 2000) {
        if (toBeString.length > 3) {
            textField.text = [toBeString substringToIndex:3];
            return NO;
        }
    }
    //服务内容
    if (textField == self.serviceContentTextFild) {
        if (toBeString.length > 6) {
            textField.text = [toBeString substringToIndex:6];
            // [textField resignFirstResponder];
            //  return NO;
        }else{
            return YES;
        }
    }
    //折扣率
    if (textField.tag == 2002) {
        // textField.text = textField.text.integerValue > 100?@"100" : textField.text;
        if (textField.text.length < 3) {
            textField.text = textField.text;
        }else if(textField.text.length > 3){
            textField.text = [textField.text substringToIndex:3];
            [textField resignFirstResponder];
            return NO;
        }
    }
    //服务金额
    if (textField.tag == 2003) {
        if (toBeString.length > 9) {
            textField.text = [toBeString substringToIndex:9];
            [textField resignFirstResponder];
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField == self.servicePayTextFild) {
        if ([textField.text doubleValue] > 999999.94) {
            textField.text = @"999999.94";
            self.servicePayTextFild.text = textField.text;
            [self amountOfCalculation];
            [textField resignFirstResponder];
            kNotice(@"费用金额最大值不能超过999999.94");
        }
    }
    return YES;
}

#pragma mark - 四舍五入
/**四舍五入处理*/
- (NSString *)siSheWuRuwithString:(NSString *)string
{
    double fstring = [string doubleValue];
    fstring = roundl(fstring*10);
    fstring = fstring * 0.1;
    return [NSString stringWithFormat:@"%.2f",fstring];
}

@end
