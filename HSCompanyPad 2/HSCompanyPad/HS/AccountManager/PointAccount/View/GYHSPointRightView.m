//
//  GYHSPointRightView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointRightView.h"

@interface GYHSPointRightView ()
//显示账户余数的label
@property (weak, nonatomic) IBOutlet UILabel *showAccountBalance;

//显示可用余数的label
@property (weak, nonatomic) IBOutlet UILabel *canUsePointLabel;


//显示昨日积分数的label

@property (weak, nonatomic) IBOutlet UILabel *yesterdayPointLabel;


//显示积分余数=账户余数-10的说明
@property (weak, nonatomic) IBOutlet UILabel *showTipsOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *showTipsTwoLabel;
//查询明细按钮
@property (weak, nonatomic) IBOutlet UIButton *detailCheckBtn;
//账户余数
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
//可用积分数
@property (weak, nonatomic) IBOutlet UILabel *canUsePointNameLabel;

//昨日积分数
@property (weak, nonatomic) IBOutlet UILabel *yesterdayPointNameLabel;
//积分转互生币
@property (weak, nonatomic) IBOutlet UIButton *pointTransformHsbBtn;
//积分投资
@property (weak, nonatomic) IBOutlet UIButton *pointInvestmentBtn;
//温馨提示
@property (weak, nonatomic) IBOutlet UILabel *tipsTitleLabel;

//成员企业下单独的积分转互生币
@property (weak, nonatomic) IBOutlet UIButton *anotherPointTransformHsbBtn;

//成员企业下要显示的view
@property (weak, nonatomic) IBOutlet UIView *viewAnother;



@end

@implementation GYHSPointRightView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.detailCheckBtn
     setTitle:kLocalized(@"GYHS_Account_Detail_Query")
     forState:UIControlStateNormal];
    self.accountLabel.text         = kLocalized(@"GYHS_Account_Account_Number");
    self.canUsePointNameLabel.text = kLocalized(@"GYHS_Account_Available_Integral_Number");

    self.yesterdayPointNameLabel.text = kLocalized(@"GYHS_Account_Yesterday's_Plot");
    if (globalData.companyType == kCompanyType_Membercom)
    {
        self.pointTransformHsbBtn.hidden = YES;
        self.pointInvestmentBtn.hidden   = YES;
        self.viewAnother.hidden          = NO;
        [self.anotherPointTransformHsbBtn setAttributedTitle:[self giveString:kLocalized(@"GYHS_Account_Point_Transform_HSB") imageNamed:@"gyhs_smallarrow_blue"] forState:UIControlStateNormal];
        

    }
    else
    {
        self.pointTransformHsbBtn.hidden = NO;
        self.pointInvestmentBtn.hidden   = NO;
        self.viewAnother.hidden          = YES;

        [self.pointTransformHsbBtn setAttributedTitle:[self giveString:kLocalized(@"GYHS_Account_Point_Transform_HSB") imageNamed:@"gyhs_smallarrow_blue"] forState:UIControlStateNormal];
        

        
        [self.pointInvestmentBtn setAttributedTitle:[self giveString:kLocalized(@"GYHS_Account_Point_Investment") imageNamed:@"gyhs_smallarrow_blue"] forState:UIControlStateNormal];
    }


    self.tipsTitleLabel.text   = kLocalized(@"GYHS_Account_The_Tips");
    self.showTipsOneLabel.text = [kLocalized(@"GYHS_Account_Available_Integral_Number_Equal_Integral_Remainder_Less__Account") stringByAppendingString:[[NSString stringWithFormat:@"%.0f", globalData.config.pointSave.doubleValue] stringByAppendingString:kLocalized(@"GYHS_Account_The_End_Of_Volume_Point")]];
    self.showTipsTwoLabel.text = kLocalized(@"GYHS_Account__The_End_Of_Integral_Is_Used_To_Ensure_That_The_Consumer_Integral_Cancellation_Return_Smoothly");
}


//点击上面的明细查询按钮
- (IBAction)clickbutton:(id)sender
{
    [self.delegate
     pointView:self
     didTouchEvent:kPointAccountTouchEventDetail];
}

//点击右边的小箭头
- (IBAction)clickTag55:(id)sender
{
    [self.delegate
     pointView:self
     didTouchEvent:kPointAccountTouchEventDetail];
}

//跳转到积分转互生币

- (IBAction)gotoTransformHSBView:(id)sender
{
    [self.delegate
     pointView:self
     didTouchEvent:kPointAccountTouchEventPointToHsb];
}

//成员企业下的点击
- (IBAction)gotoAnotherPointTransformHsb:(id)sender
{
    [self.delegate
     pointView:self
     didTouchEvent:kPointAccountTouchEventPointToHsb];
}

//跳转到积分投资界面
- (IBAction)gotoPointInvestmentView:(id)sender
{
    [self.delegate
     pointView:self
     didTouchEvent:kPointAccountTouchEventPointToInvest];
}

- (void)setData:(GYHSAccountCenter *)data
{
    _data                         = data;
    self.showAccountBalance.text  = [GYUtils formatCurrencyStyle:_data.accountBalance.doubleValue];
    self.canUsePointLabel.text    = [GYUtils formatCurrencyStyle:_data.canUsePoints.doubleValue];
    self.yesterdayPointLabel.text = [GYUtils formatCurrencyStyle:_data.yesterdayPoints.doubleValue];
}



#pragma mark 富文本
/**
 *  制作富文本
 *
 *  @param titleStr   传标题
 *  @param imageNamed 传标题旁边的图片
 *
 *  @return 返回富文本
 */
-(NSMutableAttributedString*)giveString:(NSString*)titleStr imageNamed:(NSString*)imageNamed{
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:kFont48,NSForegroundColorAttributeName:kGray333333}];
    UIImage *image = [UIImage imageNamed:imageNamed];
    NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = image;
    imageMent.bounds = CGRectMake(0,-3, image.size.width, image.size.height);
    NSAttributedString *imageAttr =
    [NSAttributedString attributedStringWithAttachment:imageMent];
    [placeholder appendAttributedString:imageAttr];
    return placeholder;
}



@end
