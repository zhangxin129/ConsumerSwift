//
//  GYFoodsInfoModel.m
//  GYRestaurant
//
//  Created by apple on 15/10/20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYFoodsInfoModel.h"

@implementation GYFoodsInfoModel
-(NSString *)createTime{
    NSString *currentDateStr;
    NSString *str=_createTime;
    NSTimeInterval time=[str longLongValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YY-MM-dd HH:mm"];
    
    currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;

}
@end
