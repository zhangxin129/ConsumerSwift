//
//  GYHSInvestmentRightView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSInvestmentRightView.h"

@interface GYHSInvestmentRightView ()

//2015年度投资回报率
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

//100%回报率问题
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

//积分投资总数
@property (weak, nonatomic) IBOutlet UILabel *showInvestmentTotalLabel;

//本年度投资分红互生币数额
@property (weak, nonatomic) IBOutlet UILabel *thisYearHSBTotalLabel;


//其中流通币数量
@property (weak, nonatomic) IBOutlet UILabel *ltHSBNumLabel;

//慈善救助基金数量
@property (weak, nonatomic) IBOutlet UILabel *csHSBNumLabel;

//第一个红色的GYHS_Account_Detail_Query按钮
@property (weak, nonatomic) IBOutlet UIButton *detailCheck1Btn;
//第二个蓝色的GYHS_Account_Detail_Query按钮
@property (weak, nonatomic) IBOutlet UIButton *detailCheck2Btn;
//第三个蓝色的GYHS_Account_Detail_Query按钮
@property (weak, nonatomic) IBOutlet UIButton *detailCheck3Btn;
//积分投资总数
@property (weak, nonatomic) IBOutlet UILabel *name1Label;
//本年度投资分红互生币
@property (weak, nonatomic) IBOutlet UILabel *name2Label;
//其中流通币
@property (weak, nonatomic) IBOutlet UILabel *name3Label;

//其中慈善救助基金
@property (weak, nonatomic) IBOutlet UILabel *name4Label;

@end






@implementation GYHSInvestmentRightView

/**
 *  按照样式设置字符串
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.detailCheck1Btn
     setTitle:kLocalized(@"GYHS_Account_Return_Over_The_Years")
     forState:UIControlStateNormal];
    [self.detailCheck2Btn
     setTitle:kLocalized(@"GYHS_Account_Integral_Investment_Detail")
     forState:UIControlStateNormal];
    [self.detailCheck3Btn
     setTitle:kLocalized(@"GYHS_Account_Investment_Bonus_Detail")
     forState:UIControlStateNormal];
    self.name1Label.text = kLocalized(@"GYHS_Account_Total_Investment");
    self.name2Label.text = kLocalized(@"GYHS_Account_The_Annual_Dividend_Alternate_Currency_Investment");
    self.name3Label.text = kLocalized(@"GYHS_Account_Currency_Currency");
    self.name4Label.text = kLocalized(@"GYHS_Account_Charity_Relief_Funds");
}

//第一排的明细查询

- (IBAction)clickFirstDetailCheckBtn:(id)sender
{
    [self.delegate
     investmentView:self
      didTouchEvent:kInvestmentRateTouchEvent];
}

//第一排明细后面的小箭头
- (IBAction)tapFirstArrow:(id)sender
{
    [self.delegate
     investmentView:self
      didTouchEvent:kInvestmentRateTouchEvent];
}

//第二排的明细查询

- (IBAction)clickSecondDetailCheckBtn:(id)sender
{
    [self.delegate
     investmentView:self
      didTouchEvent:kInvestmentDetailTouchEvent];
}

//第二排明细后面的小箭头
- (IBAction)tapSecondArrow:(id)sender
{
    [self.delegate
     investmentView:self
      didTouchEvent:kInvestmentDetailTouchEvent];
}

//第三排的明细查询

- (IBAction)clickThirdDetailCheckBtn:(id)sender
{
    [self.delegate
     investmentView:self
      didTouchEvent:kDividendDetailQueryTouchEvent];
}

//第三排明细后面的小箭头
- (IBAction)tapThirdArrow:(id)sender
{
    [self.delegate
     investmentView:self
      didTouchEvent:kDividendDetailQueryTouchEvent];
}

/**
 *  给视图赋值(将请求得到的数据赋值给xib)
 *
 *  @param data 中心数据
 */
- (void)setData:(GYHSAccountCenter *)data
{
    _data = data;

    self.showInvestmentTotalLabel.text = [GYUtils formatCurrencyStyle:_data.accumulativeInvestCount.doubleValue];
    self.thisYearHSBTotalLabel.text    = [GYUtils formatCurrencyStyle:_data.totalDividend.doubleValue];

    self.ltHSBNumLabel.text = [GYUtils formatCurrencyStyle:_data.normalDividend.doubleValue];
    self.csHSBNumLabel.text = [GYUtils formatCurrencyStyle:_data.directionalDividend.doubleValue];
    self.yearLabel.text     = [[NSString stringWithFormat:@"%@", _data.dividendYear] stringByAppendingString:kLocalized(@"GYHS_Account_Annual_Rate_Of_Return_On_Investment")];
    self.rateLabel.text     = [NSString stringWithFormat:@"%.2f%%", _data.yearDividendRate.doubleValue * 100];
}

@end
