//
//  GYHSInvestRateCell.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSInvestRateCell.h"
#import "GYHSTools.h"

@interface GYHSInvestRateCell ()


@property (weak, nonatomic) IBOutlet UIButton *showDetailBtn;


@end

@implementation GYHSInvestRateCell

- (void)awakeFromNib {
    self.titleLab.textColor = kCellTitleBlack;
    self.titleLab.font = kCellImportTextFont;

    self.textLab.textColor = kSelectedRed;
    self.textLab.font = kCellImportTextFont;
    [self.showDetailBtn setTitle:kLocalized(@"GYHS_HSAccount_showYearDividendDetail") forState:UIControlStateNormal];
    [self.showDetailBtn setTitleColor:kBtnBlue forState:UIControlStateNormal];
    self.showDetailBtn.titleLabel.font = kCellOtherTextFont;
}
- (IBAction)showDetail:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(showYearInvestmentDetail:)]) {
        [self.delegate showYearInvestmentDetail:self];
    }
}


@end
