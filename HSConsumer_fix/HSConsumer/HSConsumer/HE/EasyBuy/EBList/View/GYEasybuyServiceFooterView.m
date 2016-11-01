//
//  GYEasybuyServiceFooterView.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyServiceFooterView.h"

@interface GYEasybuyServiceFooterView ()

@end

@implementation GYEasybuyServiceFooterView

- (void)awakeFromNib
{
    [self addTopBorder];

    [_sureBtn setTitle:kLocalized(@"GYHE_Easybuy_sure") forState:UIControlStateNormal];
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_surebtn_background_color_red"] forState:UIControlStateNormal];
}

@end
