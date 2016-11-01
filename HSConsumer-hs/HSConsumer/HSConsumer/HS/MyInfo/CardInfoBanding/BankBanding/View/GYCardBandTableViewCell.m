//
//  GYCardBandTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCardBandTableViewCell.h"
#import "Masonry.h"

@implementation GYCardBandTableViewCell {
    __weak IBOutlet UILabel* lbUserName; //真实姓名
    __weak IBOutlet UIImageView* imgLine;

    __weak IBOutlet UIView* vBackground; //背景view

    __weak IBOutlet UILabel* lbCardNumber; //卡号

    __weak IBOutlet UILabel* lbLocationName; //银行卡名称

    __weak IBOutlet UILabel* lbIsCheck;
  //  __weak IBOutlet UILabel* lbIsDefaultCard; //默认银行卡

    __weak IBOutlet UIImageView *defaultbankImageView;
}

//cell的初始化
- (void)awakeFromNib
{

    self.contentView.backgroundColor = kDefaultVCBackgroundColor;

    lbLocationName.textColor = UIColorFromRGB(0x8C8C8C);
    lbCardNumber.textColor = UIColorFromRGB(0x8C8C8C);
    lbUserName.textColor = UIColorFromRGB(0x464646);
    imgLine.backgroundColor = UIColorFromRGB(0x8C8C8C);
}

- (void)setModol:(GYHSCardBandModel*)modol
{
    if (_modol != modol) {
        _modol = modol;

        defaultbankImageView.hidden = NO;
        if (![globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {

            if (modol.bankAccNo.length > 8) {
                lbCardNumber.text = [[[modol.bankAccNo substringToIndex:4] stringByAppendingString:@"**** ****"] stringByAppendingString:[modol.bankAccNo substringFromIndex:modol.bankAccNo.length - 4]];
            }
            else {
                lbCardNumber.text = modol.bankAccNo;
            }
        }
        else {
            lbCardNumber.text = modol.bankAccNo;
        }

        if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
            lbUserName.text = modol.realName;
        }
        else {
            NSMutableString* star = [[NSMutableString alloc] initWithString:@"*"];
            if (modol.realName.length != 0) {
                for (NSInteger i = 1; i < modol.realName.length - 1; i++) {
                    [star appendString:@"*"];
                }
            }

            lbUserName.text = [NSString stringWithFormat:@"%@%@", [modol.realName substringToIndex:1], star];
        }

        lbLocationName.text = modol.bankName;
        if (modol.isDefault.boolValue) {
            defaultbankImageView.image = [UIImage imageNamed:@"gyhs_defaultbank"];
        }
        else {
            defaultbankImageView.hidden = YES;
        }

        if (modol.isValidAccount.boolValue) {
            lbIsCheck.text = kLocalized(@"GYHS_Banding_Authenticated");
            lbIsCheck.textColor = UIColorFromRGB(0x8C8C8C);
        }
        else {
            lbIsCheck.text = kLocalized(@"GYHS_Banding_No_Validation");
            lbIsCheck.textColor = UIColorFromRGB(0xF0823C);
        }
    }
}

- (void)setQuickModel:(GYQuickPayModel*)quickModel
{
    if (_quickModel != quickModel) {
        _quickModel = quickModel;

        lbIsCheck.hidden = YES;
        defaultbankImageView.hidden = YES;

        lbLocationName.text = quickModel.bankName;

        NSMutableString* string = [[NSMutableString alloc] init];

        NSString* str = quickModel.bankCardNo;
        NSString* str1, *str2, *str3;
        NSInteger lengthBankCardNo = quickModel.bankCardNo.length;

        if (lengthBankCardNo > 8) {

            str3 = [str substringWithRange:NSMakeRange(4, lengthBankCardNo - 8)];
            str1 = [str substringToIndex:4];
            str2 = [str substringFromIndex:lengthBankCardNo - 4];
            str3 = [str3 substringToIndex:0];
            for (int i = 0; i < lengthBankCardNo - 8; i++) {
                str3 = [NSString stringWithFormat:@"%@*", str3];
            }
            [string appendFormat:@"%@%@%@", str1, str3, str2];

            lbCardNumber.text = string;
        }
        else {
            lbCardNumber.text = quickModel.bankCardNo;
        }

    }
}


@end
