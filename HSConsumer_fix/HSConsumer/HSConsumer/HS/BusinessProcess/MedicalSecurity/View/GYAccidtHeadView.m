//
//  GYAccidtHeadView.m
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAccidtHeadView.h"

@interface GYAccidtHeadView ()

@property (weak, nonatomic) IBOutlet UILabel* lbTitleHealthCare;

@end

@implementation GYAccidtHeadView

- (void)awakeFromNib
{
    self.lbTitleHealthCare.textColor = kCellItemTitleColor;
    self.lbTitleHealthCare.text = kLocalized(@"GYHS_BP_Medicare_Number");
    self.tfHealthCare.placeholder = kLocalized(@"GYHS_BP_Input_Medicare_Number");
}

@end
