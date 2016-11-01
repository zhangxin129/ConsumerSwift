//
//  GYHDRandomCodeCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRandomCodeCell.h"
#import "GYHSTools.h"

@implementation GYHDRandomCodeCell

- (void)awakeFromNib {
    self.randomCodeTextField.placeholder = kLocalized(@"GYHS_MyAccounts_pleaseInputVerificationCode");
    self.verificationCodeLabel.text = kLocalized(@"GYHS_RealName_Verification_Code");
    [self.nextRandomCodeBtn setTitle:kLocalized(@"换一张") forState:UIControlStateNormal];
    self.nextRandomCodeBtn.titleLabel.font =kButtonCellFont;
    [self.nextRandomCodeBtn setTitleColor:kButtonCellBtnCorlor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)GYHDNextRandomCodeBtn:(id)sender {
    if ([_randomCodeBtnDelegate respondsToSelector:@selector(nextRandomCodeBtn:)]) {
        [self.randomCodeBtnDelegate nextRandomCodeBtn:self.randomCodeView];
    }
}

@end
