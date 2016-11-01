//
//  GYCollectionFooterView.m
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCollectionFooterView.h"

@implementation GYCollectionFooterView

- (void)awakeFromNib
{
    // Initialization code
    self.lbStructions.text = kLocalized(@"GYHS_BP_Data_Upload_Attachment_Content");
    NSString* strShow = self.lbStructions.text;
    NSInteger length = strShow.length;
    NSRange posi = [strShow rangeOfString:@"*"];
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:strShow];
    [str setAttributes:@{ NSForegroundColorAttributeName : kNavigationBarColor } range:posi];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, length)];
    self.lbStructions.attributedText = str;

    [self.btnapply setTitle:kLocalized(@"GYHS_BP_Now_Apply") forState:UIControlStateNormal];
    [self.btnapply addTarget:self action:@selector(btnapply:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnapply setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];
    self.btnapply.layer.cornerRadius = 10.0;
    self.btnapply.clipsToBounds = YES;

    self.lbUploadinstructions.text = kLocalized(@"GYHS_BP_Data_Upload_Attachments");
}

- (void)btnapply:(UIButton*)btn
{

    _cb();

}

@end
