//
//  GYHSPhoneEmailListTableCellDelegate.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPhoneEmailListTableCell.h"
#import "GYHSConstant.h"
@implementation GYHSPhoneEmailListTableCell {
    __weak IBOutlet UIView* vBgView;
    __weak IBOutlet UIImageView* imgIcon;
    __weak IBOutlet UILabel* lbPhoneNumber;
    //分割线
    __weak IBOutlet UIImageView* imgSeprator;
    //成功绑定
    __weak IBOutlet UILabel* lbBandingSuecces;

    NSIndexPath* kIndexPath;
}

- (void)awakeFromNib
{
    self.contentView.backgroundColor = kDefaultVCBackgroundColor;
    vBgView.backgroundColor = [UIColor whiteColor];
    lbPhoneNumber.textColor = UIColorFromRGB(0x464646);
    lbPhoneNumber.font = [UIFont systemFontOfSize:14.0f];
    lbBandingSuecces.textColor = UIColorFromRGB(0x8C8C8C);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPhoneCellValue:(NSString*)imageName
                bandState:(NSString*)bandState
              phoneNumber:(NSString*)phoneNumber
                 btnTitle:(NSString*)btnTitle
                indexPath:(NSIndexPath*)indexPath
{

    imgIcon.image = [UIImage imageNamed:imageName];
    lbBandingSuecces.text = bandState;

    NSString* tmpPhone = [NSString stringWithFormat:@"%@****%@", [phoneNumber substringToIndex:3], [phoneNumber substringFromIndex:7]];
    lbPhoneNumber.text = tmpPhone;
    kIndexPath = indexPath;
}

- (void)setEmailCellValue:(NSString*)imageName
                bandState:(NSString*)bandState
                    email:(NSString*)email
                 btnTitle:(NSString*)btnTitle
                indexPath:(NSIndexPath*)indexPath
{

    imgIcon.image = [UIImage imageNamed:imageName];
    lbBandingSuecces.text = bandState;

    NSString* mailFlag = @"@";
    NSString* emailString = [NSString stringWithFormat:@"%@****%@", [email substringToIndex:2], [email substringFromIndex:[email rangeOfString:mailFlag].location]];
    lbPhoneNumber.text = emailString;

    kIndexPath = indexPath;
}


@end
