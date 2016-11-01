//
//  Utils.m
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "Utils.h"
#import "GYGIFHUD.h"
@implementation Utils



/**
 *  国际化
 *
 *  @param key key
 *
 *  @return value
 */
+ (NSString *)localizedStringWithKey:(NSString *)key
{
    
    return NSLocalizedString(key, nil); //当前随系统语言进行本地化
}

/**
 *  获取随机字符串
 *
 *  @param length 长度
 *
 *  @return 字符串
 */
+ (NSString *)getRandomString:(int)length
{
    const char list[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    char sele[24],*p;
    p = sele;
    int len = (int)strlen(list);
    for(int i = 0; i < length; i++){
        *p++ = list[arc4random() % len];
    }
    *p = 0;
    NSString *str = [NSString stringWithFormat:@"%s", sele];
    return str;
}

/**
 *  格式化卡号
 *
 *  @param cardNo 卡号
 *
 *  @return 格式化的卡号
 */
+ (NSString *)formatCardNo:(NSString *)cardNo
{
    if (cardNo.length != 11) return cardNo;
    NSString *cardNo1 = [cardNo substringWithRange:NSMakeRange(0, 2)];
    NSString *cardNo2 = [cardNo substringWithRange:NSMakeRange(2, 3)];
    NSString *cardNo3 = [cardNo substringWithRange:NSMakeRange(5, 2)];
    NSString *cardNo4 = [cardNo substringWithRange:NSMakeRange(7, 4)];
    NSString *formatCardNo = [NSString stringWithFormat:@"%@ %@ %@ %@", cardNo1, cardNo2, cardNo3, cardNo4];
    return formatCardNo;
}

/**
 *  获取格式化的国际货币
 *
 *  @param val 金额
 *
 *  @return 格式化的国际货币
 */
+ (NSString *)formatCurrencyStyle:(double)val
{
    if (val<0.0001) {
        return @"0.00";
    }
        
    //自定义方式
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0.00"];//@"$#,###0.00"
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:val]];
    return formattedNumberString;
    
}

/**
 *  判断是否空字符串
 *
 *  @param string 字符串
 *
 *  @return 布尔
 */
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


/**
 *  检查卡的类型
 *
 *  @param HSCard 卡号
 *  @param type   卡类型
 *
 *  @return 布尔
 */
+(BOOL)checkHSCardIsNotServicesCompany:(NSString *)HSCard
{
    
    if (![self isVaildNumber:HSCard])
    {
        return NO;
    }
    if (HSCard.length!=11)
    {
        return NO;
    }
    NSRange range = NSMakeRange(0, 2);
    // 检查前两位:
    NSString * first2 = [HSCard substringWithRange:range];
    if ([first2 isEqualToString:@"00"])
    {
        return NO;
    }

    // 检查67位
    range = NSMakeRange(5, 6);
    NSString * first78 = [HSCard substringWithRange:range];
    if ([first78 isEqualToString:@"000000"]) {
        return YES;
    }
    
    return NO;
    
}

+ (BOOL)isVaildNumber:(NSString *)num
{
    return YES;

}

/**
 *	id类型安全转换成字符串
 *
 *	@param 	idVaule 	要转换的id值
 *
 *	@return	转换后的字符串
 */
+ (NSString *)saftToNSString:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSString class]])
    {
        return idVaule;
    }else if ([idVaule isKindOfClass:[NSNull class]])//空
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", idVaule];
}

+ (NSDictionary *)stringToDictionary:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]] || !string || string.length < 1) return nil;
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
    if (error)
    {
        return nil;
    }
    return dic;
}

+ (NSString *)dictionaryToString:(NSDictionary *)dic
{
    if (!dic) return nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (error)
    {
        return nil;
    }
    return string;
}

+ (NSDictionary *)stringToDictionaryEscapseHtml:(NSString *)string{
    
    if ([string isKindOfClass:[NSNull class]] || !string || string.length < 1) return nil;
    
    //过滤后台返回的转义unicode html标签括号
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //过滤特殊字符串,主要是web端过来的数据by jianglincen
    
    NSString * tempString =[self removeHTML:string];
    
    
    NSData *data = [tempString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if (error)
    {
        return nil;
    }
    return dic;
    
}

+ (NSString *)removeHTML:(NSString *)htmlString {
    
    NSScanner *theScanner;
    
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:htmlString];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        
        htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        
    }
    
    return htmlString;
    
}



+ (void)creatLocalNotification:(NSTimeInterval)timeInterval timeZone:(NSTimeZone*)zone userInfor:(NSDictionary*)userDic alertBody:(NSString*)body
{
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];//新建通知
    
    notification.fireDate=[[NSDate date] dateByAddingTimeInterval:timeInterval];//距现在多久后触发代理方法
    notification.timeZone = zone;//设置时区
    notification.userInfo = userDic;//在字典用存需要的信息
    notification.alertBody = body;//提示信息弹出提示框
//    notification.alertAction = @"open";  //提示框按钮
//    //    notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
//        [GlobalData shareInstance].iconBadgeNumber ++;
//        notification.applicationIconBadgeNumber = [GlobalData shareInstance].iconBadgeNumber  ;//应用程序的角标
//    }
    
    //主线程刷新角标
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [GlobalData shareInstance].badgeValue ++;
//        UINavigationController *vc = [GlobalData shareInstance].topTabBarVC.viewControllers.firstObject;
////        if ([GlobalData shareInstance].badgeValue <= 0) {
////            
////            vc.tabBarItem.badgeValue = nil;
////        }else{
////            
////            vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[GlobalData shareInstance].badgeValue];
////        }
//        
//    });
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];//将新建的消息加到应用消息队列中
}


//+(void)reLogin
//{
//    //清除个人信息 重新登录
//    [globalDataclearLoginInfo];
// 
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIAlertView showWithTitle:@"提示" message:@"登录已失效，请重新登录？" cancelButtonTitle:nil otherButtonTitles:@[@"重新登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex == 0)
//            {
//                [UIApplication sharedApplication].delegate.window.rootViewController = globalData.navLoginVC;
//                DDLogCInfo(@"%@",[UIApplication sharedApplication].windows);
//            }
//        }];
//    });
//}
//








/**
 *	id类型安全转换成Integer
 *
 *	@param 	idVaule 	要转换的id值
 *
 *	@return	转换后的Integer
 */
+ (NSInteger)saftToNSInteger:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSNumber class]])
    {
        return [idVaule integerValue];
    }
    return [[self saftToNSString:idVaule] integerValue];
}

/**
 *	创建一个自定义的返回按钮
 *
 *	@param 	title 	返回按钮跟的名字
 *  @param  target  响应对象
 *  @param  popBack 点击事件
 */
+ (UIBarButtonItem *)createBackButtonWithTitle:(NSString *)title withTarget:(id)target withAction:(SEL)sel
{
    UIButton *gybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gybtn.frame = CGRectMake(0, 0, 250, 44);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"40back"]];
    imageView.frame = CGRectMake(0, 12, 10, 20);
    [gybtn addSubview:imageView];
    [gybtn setTitle:title forState:UIControlStateNormal];
    [gybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gybtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    gybtn.titleLabel.font = [UIFont systemFontOfSize:kBackFont];
    gybtn.titleEdgeInsets = UIEdgeInsetsMake(10, 25, 10, 10);
    gybtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *bbiTitle = [[UIBarButtonItem alloc] initWithCustomView:gybtn];
    
    return bbiTitle;
}


/**
 * 判断字符串是否是纯数字
 *
 *  @param strNumber 要判断的字符串
 */
+ (BOOL)checkIsNumber:(NSString*)strNumber{
    NSString *regex = @"[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:strNumber];
    return result;
}
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        DDLogCInfo(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  拨打号码
 *
 */
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber showInView:(UIView *)view

{
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]]];
    [view addSubview:callWebview];
    
}

/** add by songjk 根据字体和宽度返回高度
 *
 *  @return 高度
 */
+ (CGFloat)heightForString:(NSString *)str font:(UIFont *)font width:(CGFloat)width
{
    return [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height;
    
}

+ (void) showToastMessage: (NSString *)message {
    [[UIApplication sharedApplication].keyWindow makeToast:message duration:1 position:CSToastPositionBottom];
}

+ (BOOL)checkArrayInvalid:(id)param
{
    if ([self checkObjectInvalid:param] || [param isKindOfClass:[NSArray class]] == NO) {
        return YES;
    }
    
    return NO;
}

+(BOOL)checkObjectInvalid:(id)param
{
    if ((!param) || ([param isEqual:[NSNull null]])) {
        return YES;
    }
    
    return NO;
}

+(BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour{
    
    NSDate *date8 = [self getCustomDateWithHour:8];
    
    NSDate *date23 = [self getCustomDateWithHour:23];
    
    NSDate *currentDate = [NSDate date];
    
    if([currentDate compare:date8]==NSOrderedDescending&& [currentDate compare:date23]==NSOrderedAscending){
        
        DDLogInfo(@"该时间在 %d:00-%d:00 之间!", fromHour, toHour);
    }
    
    return YES;
    
}


+(NSDate *)getCustomDateWithHour:(NSInteger)hour{
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    
    [resultComps setYear:[currentComps year]];
    
    [resultComps setMonth:[currentComps month]];
    
    [resultComps setDay:[currentComps day]];
    
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    return [resultCalendar dateFromComponents:resultComps];
    
}
@end
