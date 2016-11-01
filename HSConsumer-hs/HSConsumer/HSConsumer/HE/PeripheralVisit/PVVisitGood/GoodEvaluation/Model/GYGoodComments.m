//
//  GYGoodComments.m
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGoodComments.h"

@implementation GYGoodComments
// by songjk 计算内容高度
- (void)setStrComments:(NSString*)strComments
{
    _strComments = strComments;
    // 计算内容高度
    CGFloat width = kScreenWidth - 13 * 2;
    CGSize contentSize = [GYUtils sizeForString:strComments font:[UIFont systemFontOfSize:17] width:width];
    _contentHeight = contentSize.height;
}

@end
