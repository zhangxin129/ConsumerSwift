//
//  GYAccidtFootView.m
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAccidtFootView.h"

@interface GYAccidtFootView ()

@property (weak, nonatomic) IBOutlet UILabel* lbNeed;

@end

@implementation GYAccidtFootView

- (void)awakeFromNib
{
    self.lbNeed.textColor = kCellItemTextColor;
    self.lbNeed.text = kLocalized(@"GYHS_BP_Special_Note_Photo_Upload_Less_Than_2MB");

    [self.proveSuggestBtn setTitle:kLocalized(@"GYHS_BP_Prove_That_Data_Suggest") forState:UIControlStateNormal];

    [self.applyImmediatelyBtn setTitle:kLocalized(@"GYHS_BP_Now_Apply") forState:UIControlStateNormal];
}

- (IBAction)btnAction:(UIButton*)sender
{

    if (sender.tag == 100) {
        if (_btnActBlock) {
            self.btnActBlock(100);
        }
    }
    else if (sender.tag == 101) {
        if (_btnActBlock) {
            self.btnActBlock(101);
        }
    }
}

@end
