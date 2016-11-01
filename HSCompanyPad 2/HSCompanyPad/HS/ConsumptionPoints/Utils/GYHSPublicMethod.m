//
//  GYHSPublicMethod.m
//
//  Created by apple on 16/8/16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPublicMethod.h"

@implementation GYHSPublicMethod

#pragma mark - 转为12位数金额
+ (NSString*)transAmount:(NSString*)amountString
{
    NSString* string = [NSString stringWithFormat:@"%.f", [amountString doubleValue] * 100];
    if (string.length >= 12) {
        return @"";
    } else {
        for (int i = 0; i < 12; i++) {
            if (i > string.length - 1) {
                string = [NSString stringWithFormat:@"%@%@", @"0", string];
            }
        }
        return string;
    }
}

#pragma mark - 抵扣券转为6位数
+ (NSString*)transferTicket:(NSString*)ticket
{
    NSString* string = ticket;
    if (ticket.length > 6) {
        return @"";
    }
    
    for (int i = 0; i < 6; i++) {
        if (i > string.length - 1) {
            string = [NSString stringWithFormat:@"%@%@", @"0", string];
        }
    }
    return string;
}

#pragma mark - 找到view所在的控制器
+ (UIViewController*)viewControllerWithView:(UIView*)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 判断日期时间是否大于当前时间，如果大于当前时间返回当前时间
+ (NSString*)compareWithTimeString:(NSString*)timeString
{

    NSDate* nowDate = [NSDate date];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString* locationString = [dateformatter stringFromDate:nowDate];
    
    NSDate* date1 = [dateformatter dateFromString:locationString];
    NSDate* date2 = [dateformatter dateFromString:timeString];
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedDescending) {
        //选择日期小于当前日期
        return timeString;
    } else {
        //选择日期大于等于当前日期
        return locationString;
    }
}

#pragma mark - 比较两个时间大小，第二个时间大于第一个时间返回yes否则返回no
+ (BOOL)compareWithDateString:(NSString*)dateString ohterDateString:(NSString*)otherDateString
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* date1 = [dateformatter dateFromString:dateString];
    NSDate* date2 = [dateformatter dateFromString:otherDateString];
    NSComparisonResult result = [date1 compare:date2];
    if (result != NSOrderedDescending) {
        //date2大于等于date1
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 判断日期时间是否在当前日期n天范围内，如果不在范围内返回当前日期-n
+ (NSString *)compareWithLimitString:(NSString *)timeString days:(NSInteger)days;
{
    NSDate* nowDate = [NSDate date];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString* locationString = [dateformatter stringFromDate:nowDate];

    NSDate* date1 = [dateformatter dateFromString:timeString];
    NSDate* date2 = [dateformatter dateFromString:locationString];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents  * comp = [calendar components:NSCalendarUnitDay
                                           fromDate:date1
                                             toDate:date2
                                            options:NSCalendarWrapComponents];
    if (comp.day >= 0 && comp.day <= days) {
        return timeString;
    }else if (comp.day < 0){
        return locationString;
    }
    else{
        return [dateformatter stringFromDate:[date2 dateByAddingTimeInterval:60 * 60 * 24 * (-days)]] ;
    }

}

#pragma mark - 渠道类型
+ (NSString*)transWithChannelType:(NSString*)chanelType
{
    switch ([chanelType integerValue]) {
    case 1:
        return kLocalized(@"GYHS_Point_Chanel_Type1");
        break;
    case 2:
        return kLocalized(@"GYHS_Point_Chanel_Type2");
        break;
    case 3:
        return kLocalized(@"GYHS_Point_Chanel_Type3");
        break;
    case 4:
        return kLocalized(@"GYHS_Point_Chanel_Type4");
        break;
    case 5:
        return kLocalized(@"GYHS_Point_Chanel_Type5");
        break;
    case 6:
        return kLocalized(@"GYHS_Point_Chanel_Type6");
        break;
    case 7:
        return kLocalized(@"GYHS_Point_Chanel_Type7");
        break;
    case 8:
        return kLocalized(@"GYHS_Point_Chanel_Type8");
        break;
    default:
        return @"";
        break;
    }
}

#pragma mark - 时间转换(将20160817163448转为2016-08-17 16:34:48)
+ (NSString*)transDate:(NSString*)stringDate
{
    // 2016-04-26 09:04:40
    return [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@", [stringDate substringWithRange:NSMakeRange(0, 4)], [stringDate substringWithRange:NSMakeRange(4, 2)], [stringDate substringWithRange:NSMakeRange(6, 2)], [stringDate substringWithRange:NSMakeRange(8, 2)], [stringDate substringWithRange:NSMakeRange(10, 2)], [stringDate substringWithRange:NSMakeRange(12, 2)]];
}

#pragma mark - 金额保留两位小数，并格式化
+ (NSString*)keepTwoDecimal:(NSString*)string
{
    if (string == nil || string.length == 0) {
        return @"";
    }
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0.00"];
    
    NSString* formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:string.doubleValue]];
    
    return formattedNumberString;
}

#pragma mark - 积分比率保留四位小数
+ (NSString*)keepPointDecimal:(NSString*)string
{
    return [NSString stringWithFormat:@"%.4f", string.doubleValue];
}

#pragma mark - 无数据显示
+ (UIView*)noDataTipWithSuperView:(UIView*)superView
{
    UIView* vBack = [[UIView alloc] initWithFrame:superView.bounds];
    vBack.backgroundColor = kDefaultVCBackgroundColor;
    UIImageView* noDataImage = [[UIImageView alloc] init];
    noDataImage.image = [UIImage imageNamed:@"gyhs_nodata"];
    noDataImage.size = CGSizeMake(39, 45);
    noDataImage.center = vBack.center;
    [vBack addSubview:noDataImage];
    
    UILabel* lbTip = [[UILabel alloc] init];
    lbTip.text = kLocalized(@"GYHS_Point_No_Data_Tip");
    lbTip.textColor = kGray333333;
    lbTip.font = kFont32;
    lbTip.backgroundColor = [UIColor clearColor];
    lbTip.textAlignment = NSTextAlignmentCenter;
    CGSize tipSize = [lbTip.text boundingRectWithSize:CGSizeMake(vBack.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    lbTip.size = tipSize;
    lbTip.centerX = vBack.centerX;
    lbTip.y = CGRectGetMaxY(noDataImage.frame) + 15;
    [vBack addSubview:lbTip];
    
    [superView addSubview:vBack];
    
    return vBack;
}

+ (UIView*)addNoDataTipViewWithSuperView:(UIView*)superView
{
    
    UIView* vBack = [[UIView alloc] init];
    [superView addSubview:vBack];
    
    vBack.backgroundColor = kDefaultVCBackgroundColor;
    UIImageView* noDataImage = [[UIImageView alloc] init];
    noDataImage.image = [UIImage imageNamed:@"gyhs_nodata"];
    //noDataImage.size = CGSizeMake(39, 45);
    //noDataImage.center = vBack.center;
    [vBack addSubview:noDataImage];
    [noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kDeviceProportion(39)));
        make.height.equalTo(@(kDeviceProportion(45)));
        make.centerX.equalTo(vBack.mas_centerX);
        make.centerY.mas_equalTo(vBack.centerY - 100);
    }];
    
    
    UILabel* lbTip = [[UILabel alloc] init];
    lbTip.text = kLocalized(@"GYHS_Point_No_Data_Tip");
    lbTip.textColor = kGray333333;
    lbTip.font = kFont32;
    lbTip.backgroundColor = [UIColor clearColor];
    lbTip.textAlignment = NSTextAlignmentCenter;
    CGSize tipSize = [lbTip.text boundingRectWithSize:CGSizeMake(vBack.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    //    lbTip.size = tipSize;
    //    lbTip.centerX = noDataImage.centerX;
    //    lbTip.y = CGRectGetMaxY(noDataImage.frame) + 15;
    [vBack addSubview:lbTip];
    [lbTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(tipSize.width));
        make.height.equalTo(@(tipSize.height));
        make.centerX.equalTo(vBack.mas_centerX);
        make.centerY.equalTo(noDataImage.mas_bottom).offset(kDeviceProportion(25));
    }];
    
    
    return vBack;
}

#pragma mark - 成员企业注销状态
+ (NSString*)explainStatus:(NSString*)status
{
    NSString* finaltatus = @"";
    switch (status.intValue) {
    case 0:
        finaltatus = kLocalized(@"GYHS_Point_Approval_Status1");
        break;
        
    case 1:
        finaltatus = kLocalized(@"GYHS_Point_Approval_Status2");
        break;
    case 2:
        finaltatus = kLocalized(@"GYHS_Point_Approval_Status3");
        break;
    case 3:
        finaltatus = kLocalized(@"GYHS_Point_Approval_Status4");
        break;
    case 4:case 5:case 6:
        finaltatus = kLocalized(@"GYHS_Point_Approval_Status_Reject");
        break;
            
    default:
        break;
    }
    return finaltatus;
}

#pragma mark -  图片显示合适大小
+ (UIImage*)buttonImageStrech:(NSString*)imagename
{
    UIImage* btnImage = [UIImage imageNamed:imagename];
    CGFloat btnImageW = btnImage.size.width * 0.5;
    CGFloat btnImageH = btnImage.size.height * 0.5;
    UIImage* newBtnImage = [btnImage resizableImageWithCapInsets:UIEdgeInsetsMake(btnImageH, btnImageW, btnImageH, btnImageW) resizingMode:UIImageResizingModeStretch];
    return newBtnImage;
}


@end
