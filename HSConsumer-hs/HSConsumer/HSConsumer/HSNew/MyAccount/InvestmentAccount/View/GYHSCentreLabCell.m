//
//  GYHSCentreLabCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCentreLabCell.h"
#import "GYHSTools.h"

@implementation GYHSCentreLabCell

- (void)awakeFromNib {
    self.titleLab1.textColor = kCellTitleBlack;
    self.titleLab1.font = kCellImportTextFont;
    self.titleLab1.text = kLocalized(@"GYHS_HSAccount_yearDividendHSCoin");
    self.textLab1.textColor = kSelectedRed;
    self.textLab1.font = kCellImportTextFont;
    
    self.titleLab2.textColor = kCellTitleBlack;
    self.titleLab2.font = kCellOtherTextFont;
    self.titleLab2.text = kLocalized(@"GYHS_HSAccount_circulationCoinIs");
    self.textLab2.textColor = kCellTitleBlack;
    self.textLab2.font = kCellOtherTextFont;
    
    self.titleLab3.textColor = kCellTitleBlack;
    self.titleLab3.font = kCellOtherTextFont;
    self.titleLab3.text = kLocalized(@"GYHS_HSAccount_onlyBuyCoinIs");
    self.textLab3.textColor = kCellTitleBlack;
    self.textLab3.font = kCellOtherTextFont;
    
}
- (IBAction)showDetail:(id)sender {
    if([self.delegate respondsToSelector:@selector(showInvestmentDetail:)]) {
        [self.delegate showInvestmentDetail:self];
    }
}

@end
