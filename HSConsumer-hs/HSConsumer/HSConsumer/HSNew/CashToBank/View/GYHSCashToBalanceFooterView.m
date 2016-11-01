//
//  GYHSCashToBalanceFooterView.m
//  HSConsumer
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCashToBalanceFooterView.h"
#import "YYKit.h"
#import "GYHSTools.h"

@implementation GYHSCashToBalanceFooterView

-(instancetype)init {
    
    if(self = [super init]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    self.userInteractionEnabled = YES;
    self.backgroundColor = kDefaultVCBackgroundColor;
    
    CGFloat leftX  = 13;
    CGFloat top = 8;
    CGFloat height = 12;
    UIFont *font = kCashToBalanceFooterFont;
    
    self.nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextStep.frame = CGRectMake(leftX, 16, kScreenWidth - 26, 41);
    [self.nextStep setTitle:kLocalized(@"下一步") forState:UIControlStateNormal];
    [self.nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextStep.backgroundColor = UIColorFromRGB(0x1d7dd6);
    self.nextStep.layer.cornerRadius = 15;
    self.nextStep.clipsToBounds = YES;
    [self addSubview:self.nextStep];
    
    
    //温馨提示
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftX, self.nextStep.bottom + top, kScreenWidth - 2*leftX, height)];
    tipLabel.text = kLocalized(@"GYHS_MyAccounts_WellTip");
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = font;
    tipLabel.textColor = UIColorFromRGB(0x666666);
    [self addSubview:tipLabel];
    
    //小圆点
    UIView *roundView1 = [[UIView alloc] initWithFrame:CGRectMake(leftX, tipLabel.bottom + top + 3, 7, 7)];
    roundView1.backgroundColor = UIColorFromRGB(0xef4136);
    roundView1.clipsToBounds = YES;
    roundView1.layer.cornerRadius = 3.5;
    [self addSubview:roundView1];
    
    //货币账户。。。
    UILabel *currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(roundView1.right + 5, tipLabel.bottom + top, kScreenWidth - leftX -roundView1.right - 5, height)];
    currencyLabel.text = kLocalized(@"GYHS_MyAccounts_CurrencyAccountCanTurnOutTurnTheAmountIsNotLessThan_100_Integer");
    currencyLabel.textAlignment = NSTextAlignmentLeft;
    currencyLabel.font = font;
    currencyLabel.textColor = UIColorFromRGB(0x666666);
    currencyLabel.numberOfLines = 0;
    [self addSubview:currencyLabel];
    
    //自适应
    CGSize size = [self adaptHeightForWidth:kScreenWidth - leftX -roundView1.right - 5 label:currencyLabel];
    currencyLabel.frame = CGRectMake(currencyLabel.origin.x, currencyLabel.origin.y, size.width, size.height);
    
    //小圆点
    UIView *roundView2 = [[UIView alloc] initWithFrame:CGRectMake(leftX, currencyLabel.bottom + top + 3, 7, 7)];
    roundView2.backgroundColor = UIColorFromRGB(0xef4136);
    roundView2.clipsToBounds = YES;
    roundView2.layer.cornerRadius = 3.5;
    [self addSubview:roundView2];
    
    //转账手续费...
    UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(roundView2.right +5, currencyLabel.bottom + top, kScreenWidth - roundView2.right - leftX -5, height)];
    feeLabel.text = kLocalized(@"GYHS_MyAccounts_TransferFeesDeductedFromCurrencyAccountBalancesPleaseMakeSureThatTheBalanceIsEnoughToEnsureSmoothTransfer");
    feeLabel.textColor = UIColorFromRGB(0x666666);
    feeLabel.font = font;
    feeLabel.numberOfLines = 0;
    feeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:feeLabel];
    
    size = [self adaptHeightForWidth:kScreenWidth - roundView2.right - leftX -5 label:feeLabel];
    feeLabel.frame = CGRectMake(feeLabel.origin.x, feeLabel.origin.y, size.width, size.height);
    self.frame = CGRectMake(0, 0, kScreenWidth,feeLabel.bottom);
    
}


-(CGSize)adaptHeightForWidth:(CGFloat)width label:(UILabel *)label {

    label.lineBreakMode = NSLineBreakByWordWrapping;
    return [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

@end
