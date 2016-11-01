//
//  GYSetNumCell.m
//  HSConsumer
//
//  Created by 00 on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSetNumCell.h"
#import "GYAppDelegate.h"
#import "GYAlertView.h"
@implementation GYSetNumCell

- (void)awakeFromNib
{
    self.maxGoodsNum = globalData.goodsNum;
    //self.tfNum.frame = CGRectMake(self.tfNum.frame.origin.x, self.tfNum.frame.origin.y, self.tfNum.frame.size.width, self.tfNum.frame.size.height + 0.5);
    //[self.tfNum addAllBorder];

    self.btnAdd.layer.borderWidth = 0.5f;
    self.btnCut.layer.borderWidth = 0.5f;
    self.tfNum.layer.borderWidth = 0.5f;

    self.tfNum.delegate = self;
    self.tfNum.text = @"1";
    self.num = self.tfNum.text.intValue;
    [self.tfNum addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.tfNum.keyboardType = UIKeyboardTypeNumberPad;
    self.lbNum.text = kLocalized(@"GYHE_SurroundVisit_Quantity");
}

- (IBAction)btnCutClick:(id)sender
{

    //    if (self.num > 1) {
    //
    //        self.num -- ;
    //    }else{
    //        self.num = 1;
    //    }
    //    [self setData];

    NSInteger num = [self.tfNum.text integerValue];
    if (num > 1) {

        num--;
        self.tfNum.text = @(num).stringValue;
        self.btnCut.alpha = 1;
        self.btnCut.enabled = YES;
    }
    else {
        // modify bysongjk
        [self makeAlertTip:1:kLocalized(@"GYHE_SurroundVisit_PurchaseMinNumIsOne")];
        self.btnCut.alpha = 0.8;
        self.btnCut.enabled = NO;
    }
    if (num > 1) {
        self.btnCut.enabled = YES;
        self.btnCut.alpha = 1;
    }
    if (num < 100) {
        self.btnAdd.enabled = YES;
        self.btnAdd.alpha = 1;
    }
    self.num = self.tfNum.text.integerValue;
    [self setData];
}

- (IBAction)btnAddClick:(id)sender
{
    //    if (self.num<self.maxGoodsNum) {
    //        self.num ++;
    //    }
    //    else
    //    {
    //        [self setTips];
    //    }
    //
    //    [self isHiddenBtnAdd];
    //    [self setData];
    NSInteger num = [self.tfNum.text integerValue];

    if (num < _maxGoodsNum) {

        num++;
        self.tfNum.text = @(num).stringValue;
        self.btnAdd.enabled = YES;
        self.btnAdd.alpha = 1;
    }
    else {
        [self makeAlertTip:_maxGoodsNum:[NSString stringWithFormat:@"%@%ld", kLocalized(@"GYHE_SurroundVisit_PurchaseMaxNum"), _maxGoodsNum]];
        self.btnAdd.alpha = 0.8;
        self.btnAdd.enabled = NO;
    }
    if (num > 1) {
        self.btnCut.enabled = YES;
        self.btnCut.alpha = 1;
    }
    if (num < 100) {
        self.btnAdd.enabled = YES;
        self.btnAdd.alpha = 1;
    }
    self.num = self.tfNum.text.integerValue;
    [self setData];
}

//复用刷新函数
- (void)setData
{
    self.tfNum.text = [NSString stringWithFormat:@"%ld", (long)self.num];
    [self.delegate retNum:self.num];
}

- (void)setTips
{
    [GYAlertView showMessage:[NSString stringWithFormat:@"%@%ld", kLocalized(@"GYHE_SurroundVisit_PurchaseMaxNum"), self.maxGoodsNum] confirmBlock:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* strText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger count = strText.integerValue;
    if (count < 0) {
        self.btnCut.alpha = 0.8;
        self.btnCut.enabled = NO;
        textField.text = @(1).stringValue;
        [self makeAlertTip:1:kLocalized(@"GYHE_SurroundVisit_PurchaseMinNumIsOne")];
        return NO;
    }
    return YES;
}

- (void)textFieldChanged:(UITextField*)textField
{
    //    if ([textField.text integerValue]>self.maxGoodsNum) {
    //        [self setTips];
    //        self.num = self.maxGoodsNum;
    //        [self setData];
    //        [self isHiddenBtnAdd];
    //    }
    //    self.num = [textField.text integerValue];
    //    if (self.num <=0) {
    //        self.num = 1;
    //    }
    //    [self setData];
    NSString* str = textField.text;
    NSInteger count = str.integerValue;
    if (count > _maxGoodsNum) {
        self.btnAdd.alpha = 0.8;
        self.btnAdd.enabled = NO;
        textField.text = @(_maxGoodsNum).stringValue;
        [self makeAlertTip:_maxGoodsNum:[NSString stringWithFormat:@"%@%ld", kLocalized(@"GYHE_SurroundVisit_PurchaseMaxNum"), _maxGoodsNum]];
    }
    //    if (str&&str.length>0&&count<1) { // modify by songjk
    //    if (count<1) {
    //        self.btnCut.alpha = 0.8;
    //        self.btnCut.enabled = NO;
    //        textField.text = @(1).stringValue;
    //        [self makeAlertTip:1:[NSString stringWithFormat:@"最小购买数量为%ld",1]];
    //    }
    if (count > 1) {
        self.btnCut.enabled = YES;
        self.btnCut.alpha = 1;
    }
    if (count < _maxGoodsNum) {
        self.btnAdd.enabled = YES;
        self.btnAdd.alpha = 1;
    }
    self.num = self.tfNum.text.integerValue;
    [self setData];
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([textField.text integerValue] < 1) {
        [self makeAlertTip:1:kLocalized(@"GYHE_SurroundVisit_PurchaseMinNumIsOne")];
//        _lbNum
        
    }
}

- (void)makeAlertTip:(NSInteger)goodsNum:(NSString*)tipStr
{
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    tipLabel.clipsToBounds = YES;
    tipLabel.layer.cornerRadius = 10;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:18];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    [self.window addSubview:tipLabel];
    tipLabel.text = tipStr; //;
    self.tfNum.text = @(goodsNum).stringValue;
    self.num = goodsNum;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            tipLabel.alpha = 0;
        }];
    });

    [UIView animateWithDuration:1 animations:^{
        tipLabel.alpha = 0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipLabel removeFromSuperview];
    });
    [self setData];
}

@end
