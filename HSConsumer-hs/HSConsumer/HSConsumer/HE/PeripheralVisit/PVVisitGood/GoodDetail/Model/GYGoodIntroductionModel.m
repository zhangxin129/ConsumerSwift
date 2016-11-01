//
//  GYGoodIntroductionModel.m
//  HSConsumer
//
//  Created by Apple03 on 15-5-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGoodIntroductionModel.h"

@implementation GYGoodIntroductionModel

- (CGFloat)fHight
{
    UILabel* label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"%@",self.strData];
    label.font = kDetailFont;
    return [self adaptiveWithWidth:(kScreenWidth - 30) label:label].height;
    //    return [self.strData heightForFont:kDetailFont width:kScreenWidth];
}

- (CGSize)adaptiveWithWidth:(CGFloat)width label:(UILabel*)label
{

    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size;
}

@end
