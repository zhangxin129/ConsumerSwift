//
//  GYBankTableViewCell.m
//  HSConsumer
//
//  Created by apple on 15/12/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYBankTableViewCell.h"
#import "GYQuickPayModel.h"
#import <UIImageView+YYWebImage.h>

typedef NS_ENUM(NSInteger, kBankCardType) {
    kBankCardTypeCash = 1,
    kBankCardTypeCredit = 2
};

@interface GYBankTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel* lbBankName;

@property (weak, nonatomic) IBOutlet UIImageView* imgIsDefaut;
@property (weak, nonatomic) IBOutlet UIImageView* imgBankName;
@property (weak, nonatomic) IBOutlet UILabel* lbBankNo; //****2541
@property (weak, nonatomic) IBOutlet UILabel* lbBankCardType; //信用卡
@property (weak, nonatomic) IBOutlet UILabel* lbQuck; //快捷

@end

@implementation GYBankTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (!self.notSystemSelect) {
        [self setSelectedState:selected];
    }
}

- (void)setModel:(GYQuickPayModel*)model
{
    if (_model != model) {
        _model = model;
        NSMutableString* string = [[NSMutableString alloc] init];

        NSString* str = model.bankCardNo;
        NSString* str1, *str2, *str3;
        NSInteger lengthBankCardNo = model.bankCardNo.length;

        if (lengthBankCardNo > 8) {
            str3 = [str substringWithRange:NSMakeRange(4, lengthBankCardNo - 8)];
            str1 = [str substringToIndex:4];
            str2 = [str substringFromIndex:lengthBankCardNo - 4];
            str3 = [str3 substringToIndex:0];
            for (int i = 0; i < lengthBankCardNo - 8; i++) {
                str3 = [NSString stringWithFormat:@"%@*", str3];
            }
            [string appendFormat:@"%@%@%@", str1, str3, str2];

            self.lbBankNo.text = string;
        }
        else {
            self.lbBankNo.text = [NSString stringWithFormat:@"**** %@",model.bankCardNo];
        }

        self.lbQuck.text = kLocalized(@"GYHS_Main_Quick");
        self.lbBankName.text = model.bankName;
        //         self.imgBankName.image=[UIImage imageNamed:model.bankCode];
        //        [self.imgBankName sd_setImageWithURL:[NSURL URLWithString:model.bankCode] placeholderImage:[UIImage imageNamed:@"gycommon_image_placeholder"]];

        if ([model.bankCardType integerValue] == kBankCardTypeCash) {
            self.lbBankCardType.text = kLocalized(@"GYHS_Main_SavingsCard");
        }
        else {
            self.lbBankCardType.text = kLocalized(@"GYHS_Main_CreditCard");
        }
    }
}

- (void)setSelectedState:(BOOL)state
{
    if (state) {
        self.imgIsDefaut.image = [UIImage imageNamed:@"gyhs_select_button"];
    }
    else {
        self.imgIsDefaut.image = [UIImage imageNamed:@"gyhs_no_select_button"];
    }
}
@end
