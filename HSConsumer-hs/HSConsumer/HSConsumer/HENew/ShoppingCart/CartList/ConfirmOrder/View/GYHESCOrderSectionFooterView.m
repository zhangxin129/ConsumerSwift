//
//  GYHESCOrderSectionFooterView.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/28.
//  Copyright © 2016年 zhangqy. All rights reserved.
//

#import "GYHESCOrderSectionFooterView.h"
#import "GYHESCDistributionWayViewController.h"


@implementation GYHESCOrderSectionFooterView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */

- (void)awakeFromNib
{
    // Initialization code
//    self.invoiceView.hidden = YES;
    self.totalTagLabel.text = kLocalized(@"HE_SC_CartTotal");
    self.operatingPointTagLabel.text = kLocalized(@"HE_SC_OrderOperatingPoint");
    self.sendWayTagLabel.text = kLocalized(@"HE_SC_OrderDistributionWayTitle");
    self.applyCardTagLabe.text = kLocalized(@"HE_SC_OrderApplyPresentCard");
    self.invoiceTagLabel.text = kLocalized(@"HE_SC_OrderWriteInvoice");
    self.invoiceHeadTagLabel.text = kLocalized(@"HE_SC_OrderInvoiceTitle");
    self.leaveMessageTagLabel.text = kLocalized(@"HE_SC_OrderGiveMessage");//
    
    self.transFeeTagLabel.text = kLocalized(@"运费:");
    self.realMoneyTagLabel.text = kLocalized(@"实付:");

    self.coinIconWidth.constant = 0; //金币图标约束
    self.consumeLabel.adjustsFontSizeToFitWidth = YES; // 抵扣券太多的时候把字体变小
    self.operatingPointLabel.adjustsFontSizeToFitWidth = YES;//营业点字体长的话把字体变小

    self.invoiceHeadTextView.userInteractionEnabled = NO;
    //self.sendWayLabel.textColor = [UIColor lightGrayColor];

    self.leaveMessageTextView.text = kLocalized(@"选填:发票抬头或者与商家的预定等");//HE_SC_OrderLeaveMessagePlaceHolder
    self.leaveMessageTextView.textColor = [UIColor lightGrayColor];
    self.leaveMessageTextView.delegate = self;

    self.invoiceHeadTextView.delegate = self;

    UITapGestureRecognizer* distributionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(distributionTapClick)];
    [self.distributionView addGestureRecognizer:distributionTap]; //添加手势
}

#pragma mark - custom methods

- (void)distributionTapClick
{
    if ([self.delegate respondsToSelector:@selector(pushToDistributionWayWithSection:)]) {
        [self.delegate pushToDistributionWayWithSection:self.section];
    }
}

- (void)chooseAreaTapClick
{
    if ([self.delegate respondsToSelector:@selector(pushToChooseAreaWithIndexPath:)]) {
        [self.delegate pushToChooseAreaWithIndexPath:self.section];
    }
}

- (void)refreshDataWithModel:(GYHESCOrderModel*)model discountInfoModel:(GYHESCDiscountInfoModel*)discountModel

{
    self.goodsNumberLabel.text  = [NSString stringWithFormat:kLocalized(@"HE_SC_CartTotalGoods"),model.modelArray.count];
    self.moneyLabel.text = model.totalMoney;
    self.pvLabel.text = model.totalPv;
    self.operatingPointLabel.text = model.shopName;
    if ([self.isRightAway isEqualToString:@"1"]) { //为立即购买
        self.rightArrowImgView.hidden = NO;
        UITapGestureRecognizer* chooseAreaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAreaTapClick)];
        [self.chooseAreaView addGestureRecognizer:chooseAreaTap];
    }
    else {
        self.rightArrowImgView.hidden = YES;
    }
    self.sendWayLabel.text = model.sendWay;
    self.expressageLabel.text = model.sendMoney;
    self.coinIconWidth.constant = model.coinIconWidth;
    
//    if ([model.deliveryType isEqualToString:@"1"]) { //是快递支付
//        if ([model.sendMoney doubleValue] == 0) {
//            self.expressageLabel.text = kLocalized(@"免邮");
//            self.coinIconWidth.constant = 0;
//        } else {
//            self.expressageLabel.text = [NSString stringWithFormat:@"%.2lf", [model.sendMoney doubleValue]];
//            self.coinIconWidth.constant = model.coinIconWidth;
//        } 
//    }
//    else {
//        self.expressageLabel.text = @"";
//        self.coinIconWidth.constant = model.coinIconWidth;
//    }
    

    if (model.leaveMessage.length < 1) {
        self.leaveMessageTextView.text = kLocalized(@"选填:发票抬头或者与商家的预定等");
        self.leaveMessageTextView.textColor = [UIColor lightGrayColor];
    }
    else {
        self.leaveMessageTextView.text = model.leaveMessage;
        self.leaveMessageTextView.textColor = [UIColor blackColor];
    }

    if (model.enableApplyCard) {
        self.applyCardSwitch.enabled = YES;
        self.applyCardSwitch.on = model.isApplyCard;
        self.applyCardViewHeight.constant = 46.0f;
        self.applyCardTagLabe.hidden = NO;
        self.applyCardSwitch.hidden = NO;
    }
    else {
        self.applyCardSwitch.enabled = NO;
        self.applyCardViewHeight.constant = 0;
        self.applyCardTagLabe.hidden = YES;
        self.applyCardSwitch.hidden = YES;
    }

    self.invoiceSwitch.on = model.isInvoice;
    if (self.invoiceSwitch.on) {
        self.invoiceHeight.constant = 50.0f;
        self.invoiceView.hidden = NO;
        self.invoiceHeadTextView.userInteractionEnabled = YES;
        if (model.invoiceHead && ![model.invoiceHead isKindOfClass:[NSNull class]] && model.invoiceHead.length > 0) {
            self.invoiceHeadTextView.text = model.invoiceHead;
            self.invoiceHeadTextView.textColor = [UIColor blackColor];
        }
        else {
            self.invoiceHeadTextView.text = kLocalized(@"HE_SC_OrderInvoiceHeadPlaceHolder");
            self.invoiceHeadTextView.textColor = [UIColor lightGrayColor];
        }
    }
    else {
        self.invoiceHeight.constant = 0;
        self.invoiceView.hidden = YES;
        self.invoiceHeadTextView.userInteractionEnabled = NO;
        self.invoiceHeadTextView.text = @"";
    }

    NSString* couponMoney = @"0.00";
    if (kSaftToNSString(model.couponName).length > 0 && kSaftToNSInteger(model.num) > 0) {
        couponMoney = [NSString stringWithFormat:@"-%.2lf", [model.num integerValue] * [model.amount doubleValue]];
        self.consumeLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_SC_DiscountInfomationDiff"), model.couponName, model.num, couponMoney];
        self.consumeSwitch.hidden = NO;
        self.consumeSwitch.on = model.isUseConsume;
    }
    else {
        self.consumeLabel.text = kLocalized(@"HE_SC_OrderNoCouponDesc");
        self.consumeSwitch.hidden = YES;
    }
    
    self.transFeeLabel.text = [GYUtils formatCurrencyStyle:[model.sendMoney doubleValue]];
    self.couponFeeNumberLabel.text = couponMoney;
    self.realNumberLabel.text = [NSString stringWithFormat:@"%.2lf", [model.totalMoney doubleValue] + [model.sendMoney doubleValue] + [couponMoney doubleValue]];
}

//屏蔽表情
- (NSString *)disableEmoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

#pragma mark -UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    if (textView.tag == 555) {
        if ([self.invoiceHeadTextView.text isEqualToString:kLocalized(@"HE_SC_OrderInvoiceHeadPlaceHolder")]) {
            self.invoiceHeadTextView.text = @"";
            self.invoiceHeadTextView.textColor = [UIColor blackColor];
        }
    }
    else {
        if ([self.leaveMessageTextView.text isEqualToString:kLocalized(@"选填:发票抬头或者与商家的预定等")]) {
            self.leaveMessageTextView.text = @"";
            self.leaveMessageTextView.textColor = [UIColor blackColor];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    if (textView.tag == 555) {
        if (self.invoiceHeadTextView.text.length < 1) {
            self.invoiceHeadTextView.text = kLocalized(@"HE_SC_OrderInvoiceHeadPlaceHolder");
            self.invoiceHeadTextView.textColor = [UIColor lightGrayColor];
        }
    }
    if (self.leaveMessageTextView.text.length < 1) {
        self.leaveMessageTextView.text = kLocalized(@"选填:发票抬头或者与商家的预定等");
        self.leaveMessageTextView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidChange:(UITextView*)textView
{
    NSRange textRange = [textView selectedRange];
    [textView setText:[self disableEmoji:[textView text]]];
    [textView setSelectedRange:textRange];
    
    if (textView.tag == 555) {
        self.orderModel.invoiceHead = textView.text;
    }
    else {
        self.orderModel.leaveMessage = textView.text;
    }
}

#pragma mark - xib event response

- (IBAction)applyCardSwitchClick:(UISwitch*)sender
{
    if (sender.on) {
        self.orderModel.isApplyCard = YES;
    }
    else {
        self.orderModel.isApplyCard = NO;
    }
}

- (IBAction)invoiceSwitchClick:(UISwitch*)sender
{

    if (sender.on) {
        self.orderModel.isInvoice = YES;
//        self.invoiceHeadTagLabel.textColor = [UIColor blackColor];
        self.invoiceHeadTextView.userInteractionEnabled = YES;
        self.invoiceHeadTextView.text = kLocalized(@"HE_SC_OrderInvoiceHeadPlaceHolder");
        self.invoiceHeadTextView.textColor = [UIColor lightGrayColor];
    }
    else {
        self.orderModel.isInvoice = NO;
//        self.invoiceHeadTagLabel.textColor = [UIColor lightGrayColor];
        self.invoiceHeadTextView.userInteractionEnabled = NO;
        self.invoiceHeadTextView.text = @"";
    }
    _invoiceBlock();

}

- (IBAction)consumeSwitchClick:(UISwitch*)sender
{
    if (sender.on) {
        self.orderModel.isUseConsume = YES;
    }
    else {
        self.orderModel.isUseConsume = NO;
    }
    if ([self.delegate respondsToSelector:@selector(calculateWhenConsumeSwitchDidChange)]) {
        [self.delegate calculateWhenConsumeSwitchDidChange];
    }
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
