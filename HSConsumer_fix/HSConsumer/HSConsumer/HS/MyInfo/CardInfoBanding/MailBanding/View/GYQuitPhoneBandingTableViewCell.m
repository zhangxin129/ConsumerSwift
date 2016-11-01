//
//  GYQuitPhoneBandingTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYQuitPhoneBandingTableViewCell.h"

@implementation GYQuitPhoneBandingTableViewCell {

    __weak IBOutlet UIView* vBgView; //背景View

    __weak IBOutlet UIImageView* imgIcon; //显示图片

    __weak IBOutlet UILabel* lbPhoneNumber; //电话号码

    __weak IBOutlet UIImageView* imgSeprator; //分割线

    __weak IBOutlet UILabel* lbBandingSuecces; //成功绑定Label

    __weak IBOutlet UILabel* lbauthenticateMail; //邮箱状态label
}

//初始化
- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor = kDefaultVCBackgroundColor;

    [imgSeprator addLeftBorder];
    vBgView.backgroundColor = [UIColor whiteColor];
    lbPhoneNumber.textColor = kCellItemTitleColor;
    lbBandingSuecces.textColor = kCellItemTitleColor;
    [self.btnQuitBanding setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUIWith:(GYQuitPhoneBandingModel*)model
{
    imgIcon.image = [UIImage imageNamed:model.strIconUrl];
    lbBandingSuecces.text = model.strBandingSuccess;

    DDLogDebug(@"%@------phone", model.strPhoneNo);
    NSString* phoneNumber = [NSString stringWithFormat:@"%@****%@", [model.strPhoneNo substringToIndex:3], [model.strPhoneNo substringFromIndex:7]];
    lbauthenticateMail.hidden = YES;
    lbPhoneNumber.text = phoneNumber;
    [self.btnQuitBanding setTitle:model.strBtnTitle forState:UIControlStateNormal];
}

- (void)refreshUIWithEmail:(GYQuitEmailBanding*)model
{
    imgIcon.image = [UIImage imageNamed:model.strIconUrl];
    lbauthenticateMail.text = model.strBtnTitle;
    lbPhoneNumber.text = [GYUtils encryptEmail:model.strEmail];
    
   
}

@end
