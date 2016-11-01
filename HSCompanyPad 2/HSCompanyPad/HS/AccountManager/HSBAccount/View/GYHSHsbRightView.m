//
//  GYHSHsbRightView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/9/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSHsbRightView.h"

@interface GYHSHsbRightView ()
//显示流通币余额
@property (weak, nonatomic) IBOutlet UILabel *showLtAccountBalanceLabel;
//显示慈善余额
@property (weak, nonatomic) IBOutlet UILabel *showCsAccountBalanceLabel;
//明细查询按钮
@property (weak, nonatomic) IBOutlet UIButton *detailCheckBtn;
//流通币
@property (weak, nonatomic) IBOutlet UILabel *name1Label;
//慈善救助基金
@property (weak, nonatomic) IBOutlet UILabel *name2Label;
//互生币转货币按钮
@property (weak, nonatomic) IBOutlet UIButton *hsbTransformCashBtn;
//兑换互生币
@property (weak, nonatomic) IBOutlet UIButton *exchangeHsbBtn;
@property (weak, nonatomic) IBOutlet UIButton *hsbTransformCashBtnAnother;
@property (weak, nonatomic) IBOutlet UIButton *exchangeHsbBtnAnother;
//显示两个按钮的view
@property (weak, nonatomic) IBOutlet UIView *showBtnView;
@property (weak, nonatomic) IBOutlet UIView *csNumberView;
@property (weak, nonatomic) IBOutlet UIView *viewOff;

@end




@implementation GYHSHsbRightView

/**
 *  按照成员企业和托管企业来进行分开显示
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.detailCheckBtn
     setTitle:kLocalized(@"GYHS_Account_Detail_Query")
     forState:UIControlStateNormal];
    self.name1Label.text = kLocalized(@"GYHS_Account_Ltb");
    self.name2Label.text = kLocalized(@"GYHS_Account_Charity_Relief_Fund");


    if (globalData.companyType == kCompanyType_Membercom)
    {
        self.showCsAccountBalanceLabel.hidden  = YES;
        self.name2Label.hidden                 = YES;
        self.showBtnView.hidden                = YES;
        self.hsbTransformCashBtnAnother.hidden = NO;
        self.exchangeHsbBtnAnother.hidden      = NO;
        [self.hsbTransformCashBtnAnother setAttributedTitle:[self giveString:kLocalized(@"GYHS_Account_HSB_To_Cash") imageNamed:@"gyhs_smallarrow_blue"] forState:UIControlStateNormal];
        
        [self.exchangeHsbBtnAnother setAttributedTitle:[self giveString:kLocalized(@"GYHS_Account_Exchange_HSB") imageNamed:@"gyhs_smallarrow_blue"] forState:UIControlStateNormal];
        self.viewOff.hidden = YES;
    }
    else
    {
        self.hsbTransformCashBtnAnother.hidden = YES;
        self.exchangeHsbBtnAnother.hidden      = YES;
        self.hsbTransformCashBtn.hidden        = NO;
        self.exchangeHsbBtn.hidden             = NO;
        
        [self.hsbTransformCashBtn setAttributedTitle:[self giveString:kLocalized(@"GYHS_Account_HSB_To_Cash") imageNamed:@"gyhs_smallarrow_blue"] forState:UIControlStateNormal];

        [self.exchangeHsbBtn setAttributedTitle:[self giveString:kLocalized(@"GYHS_Account_Exchange_HSB") imageNamed:@"gyhs_smallarrow_blue"] forState:UIControlStateNormal];
        

    }



}

//点击查询明细
- (IBAction)clickDetailCheckBtn:(id)sender
{
    [self.delegate
     hsbView:self
     didTouchEvent:kHSBAccountTouchEventDetail];
}

//点击了查询明细右边的小箭头
- (IBAction)clickTapArrow:(id)sender
{
    [self.delegate
     hsbView:self
     didTouchEvent:kHSBAccountTouchEventDetail];
}

//点击互生币转货币
- (IBAction)clickHSBTransformCashBtn:(id)sender
{
    [self.delegate
     hsbView:self
     didTouchEvent:kHSBAccountTouchEventHsbToCash];
}

//点击了兑换互生币
- (IBAction)clickExchangeHSBBtn:(id)sender
{
    [self.delegate
     hsbView:self
     didTouchEvent:kHSBAccountTouchEventExchangeHsb];
}

- (void)setData:(GYHSAccountCenter *)data
{
    _data                               = data;
    self.showLtAccountBalanceLabel.text = [GYUtils formatCurrencyStyle:_data.ltbBalance.doubleValue];
    self.showCsAccountBalanceLabel.text = [GYUtils formatCurrencyStyle:_data.csBalance.doubleValue];
}

//点击新的互生币转货币
- (IBAction)hsbTransformCashBtnNewClick:(id)sender
{
    [self.delegate
     hsbView:self
     didTouchEvent:kHSBAccountTouchEventHsbToCash];
}

//点击新的兑换互生币
- (IBAction)exchangeHSBBtnNew:(id)sender
{
    [self.delegate
     hsbView:self
     didTouchEvent:kHSBAccountTouchEventExchangeHsb];
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
