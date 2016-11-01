//
//  CellUserInfo.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//我的账户主界面的 个人信息cell

#import "CellUserInfo.h"
#import "Masonry.h"

@implementation CellUserInfo

- (void)awakeFromNib
{
    // Initialization code
    [self.lbLabelCardNo setTextColor:UIColorFromRGB(0x787878)];
    [self.lbLabelHello setTextColor:UIColorFromRGB(0xA0A0A0)];
    [self.lbLastLoginInfo setTextColor:UIColorFromRGB(0xA0A0A0)];
    _btnUserPicture.layer.masksToBounds = YES;
    _btnUserPicture.layer.cornerRadius = self.btnUserPicture.bounds.size.width / 2;
    self.lbLastLoginInfo.adjustsFontSizeToFitWidth = YES;

    if (!globalData.loginModel.cardHolder) {
        [self.lbLabelCardNo mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.mas_top).with.offset(35);
        }];

        [self.lbLastLoginInfo mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.lbLabelCardNo.mas_bottom).with.offset(15);
        }];

        [self.btnPhoneYes mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self.btnUserPicture.mas_right).with.offset(15);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
