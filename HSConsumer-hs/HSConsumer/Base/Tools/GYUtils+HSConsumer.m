//
//  Utils+HSConsumer.m
//  HSConsumer
//
//  Created by sqm on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUtils+HSConsumer.h"
#import "GYShopBrandModel.h"
#import "pinyin.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"

#define kUserInfoAppPlayTimes @"kUserInfoAppPlayTimes"
#define kUserInfoAppMapLocations @"kUserInfoAppMapLocations"
#define kUserInfoAppRequestURLs @"kUserInfoAppRequestURLs"

const void* stringKey = "stringKey";
const void* pinYinKey = "pinYinKey";

@implementation GYUtils (HSConsumer)

- (void)setString:(NSString*)string
{
    objc_setAssociatedObject(self, stringKey, string, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)string
{

    return objc_getAssociatedObject(self, stringKey);
}

- (void)setPinYin:(NSString*)pinYin
{
    objc_setAssociatedObject(self, pinYinKey, pinYin, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)pinYin
{
    return objc_getAssociatedObject(self, pinYinKey);
}
+ (NSString*)localizedStringWithKey:(NSString*)key
{

    return NSLocalizedString(key, nil); //当前随系统语言进行本地化
}

+ (NSString*)deformatterCurrencyStyle:(NSString*)value flag:(NSString*)flag
{
    return [value stringByReplacingOccurrencesOfString:flag withString:@""];
}

+ (void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor*)color
{
    if (width == 0) {
        [view removeAllBorder];
    }
    else {
        [view addAllBorder];
    }

    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
}

+ (void)setPlaceholderAttributed:(UITextField*)textField withSystemFontSize:(CGFloat)fontSize withColor:(UIColor*)color
{
    if (color) {
        textField.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:textField.placeholder ? textField.placeholder : @""
                                            attributes:@{
                                                NSForegroundColorAttributeName : color,
                                                NSFontAttributeName : [UIFont systemFontOfSize:fontSize]
                                            }];
    }
    else {
        textField.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:textField.placeholder ? textField.placeholder : @""
                                            attributes:@{
                                                NSFontAttributeName : [UIFont systemFontOfSize:fontSize]
                                            }];
    }
}

+ (id)loadVcFromClassStringName:(NSString*)className
{
    return [[NSClassFromString(className) alloc] init];
}

//是否是空字符串
+ (BOOL)isBlankString:(NSString*)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkObjectInvalid:(id)param
{
    if ((!param) || ([param isEqual:[NSNull null]])) {
        return YES;
    }

    return NO;
}

+ (BOOL)checkArrayInvalid:(id)param
{
    if ([self checkObjectInvalid:param] || [param isKindOfClass:[NSArray class]] == NO) {
        return YES;
    }

    return NO;
}

+ (BOOL)checkDictionaryInvalid:(id)param
{
    if ([self checkObjectInvalid:param] || [param isKindOfClass:[NSDictionary class]] == NO) {
        return YES;
    }

    return NO;
}

+ (BOOL)checkStringInvalid:(NSString*)param
{
    if ((!param) || ([param isEqual:[NSNull null]]) || ([param isKindOfClass:[NSString class]] == NO) || (0 == param.length) || ([param isEqualToString:@"<null>"]) || ([param isEqualToString:@"(null)"])) {
        return YES;
    }

    return NO;
}

//验证字符串是不是空，返回不是空的字符串，否则返回@“”，主要是过滤字符串首位的空格
+ (NSString*)formatNullString:(NSString*)string
{
    NSString* strTemp = kTrimmingString(string);
    if ([strTemp isEqualToString:@"null"] || [strTemp isEqualToString:@"NULL"]) {
        return @"";
    }
    else {
        return strTemp;
    }
}

+ (BOOL)isNumber:(char)ch
{
    if (!(ch >= '0' && ch <= '9')) {
        return NO;
    }

    return YES;
}

+ (BOOL)isValidNumber:(NSString*)value
{
    const char* cvalue = [value UTF8String];
    long len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if (![[self class] isNumber:cvalue[i]]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isValidCreditNumber:(NSString*)value
{
    BOOL result = YES;
    NSInteger length = [value length];
    if (length >= 13) {
        result = [GYUtils isValidNumber:value];
        if (result) {
            NSInteger begin = [[value substringWithRange:NSMakeRange(0, 6)] integerValue];
            //CUP
            if ((begin >= 622126 && begin <= 622925) && (19 != length)) {
                result = NO;
            }
            //other
            else {
                result = YES;
            }
        }
        if (result) {
            NSInteger digitValue;
            NSInteger checkSum = 0;
            NSInteger index = 0;
            NSInteger leftIndex;
            //even length, odd index
            if (0 == length % 2) {
                index = 0;
                leftIndex = 1;
            }
            //odd length, even index
            else {
                index = 1;
                leftIndex = 0;
            }
            while (index < length) {
                digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
                digitValue = digitValue * 2;
                if (digitValue >= 10) {
                    checkSum += digitValue / 10 + digitValue % 10;
                }
                else {
                    checkSum += digitValue;
                }
                digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
                checkSum += digitValue;
                index += 2;
                leftIndex += 2;
            }
            result = (0 == checkSum % 10) ? YES : NO;
        }
    }
    else {
        result = NO;
    }
    return result;
}

+ (float)heightForString:(NSString*)value fontSize:(float)fontSize andWidth:(float)width
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributesDic = @{
        NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
        NSParagraphStyleAttributeName : paragraphStyle
    };
    return [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size.height;
}

+ (BOOL)isValidByTrimming:(NSString*)str
{
    DDLogDebug(@"%@", str);
    NSCharacterSet* doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    str = [[str componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];
    DDLogDebug(@"%@", str);
    return NO;
}

//是否包含中文
+ (BOOL)isIncludeChineseInString:(NSString*)value
{
    for (int i = 0; i < value.length; i++) {
        unichar ch = [value characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

+ (BOOL)isValidFixedLineTelephone:(NSString*)phoneNum
{
    NSString* check = @"^(\\+?\\d{2,3}\\-)?(0\\d{2,3}-?)?\\d{7,8}$";

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", check];
    return [predicate evaluateWithObject:phoneNum];
}

//验证输入的是否是正确格式的手机号
+ (BOOL)isMobileNumber:(NSString*)mobileNum
{
    /**
     * 手机号码
     *移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    //NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString* MOBILE = @"^1\\d{10}$"; //不需要配备这么多规则，只用验证11位且开头是1的数字即可

    /**
     10         *中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString* CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         *中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString* CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         *中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString* CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";

    /**
     29         *国际长途中国区(+86)
     30         *区号：+86
     31         *号码：十一位
     32         */
    NSString* IPH = @"^\\+861(3|5|8)\\d{9}$";

    //判断是否为正确格式的手机号码
    NSPredicate* regextestmobile;
    NSPredicate* regextestcm;
    NSPredicate* regextestcu;
    NSPredicate* regextestct;
    NSPredicate* regextestiph;

    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    regextestiph = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IPH];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestiph evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    else {
        return NO;
    }
}

// 备用email验证支援格式xxx.xxx@xxx.xxx.xxx
+ (BOOL)emailCheck:(NSString*)str
{

    if (([str rangeOfString:@".@"].length > 0) || ([str rangeOfString:@"@."].length > 0)) {
        return NO;
    }
    if ([str rangeOfString:@"@"].length <= 0) {
        return NO;
    }
    else {
        NSString* headStr = [str substringToIndex:[str rangeOfString:@"@"].location];
        NSString* endStr = [str substringFromIndex:[str rangeOfString:@"@"].location];

        if ([headStr length] == 0) {
            return NO;
        }
        if ([headStr characterAtIndex:0] == '.') {
            return NO;
        }
        if ([endStr length] == 0) {
            return NO;
        }
        if ([endStr rangeOfString:@"."].length == 0) {
            return NO;
        }
        if ([endStr characterAtIndex:[endStr length] - 1] == '.') {
            return NO;
        }
    }

    return YES;
}

//判断邮箱是否有效的方法
+ (BOOL)isValidateEmail:(NSString*)Email
{
    NSString* emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", emailCheck];
    return [emailTest evaluateWithObject:Email];
}

//判断是否是正确的邮编
+ (BOOL)isValidZipcode:(NSString*)value
{
    const char* cvalue = [value UTF8String];
    long len = strlen(cvalue);
    if (len != 6) {
        return NO;
    }
    for (int i = 0; i < len; i++) {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9')) {
            return NO;
        }
    }
    return YES;
}

//判断是否是正确的护照
+ (BOOL)isValidPassport:(NSString*)value
{
    const char* str = [value UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G')) {
        return NO;
    }
    if (first == 'P') {
        if (length != 8) {
            return NO;
        }
    }
    if (first == 'G') {
        if (length != 9) {
            return NO;
        }
    }
    BOOL result = YES;
    for (NSInteger i = 1; i < length; i++) {
        if (!(str[i] >= '0' && str[i] <= '9')) {
            result = NO;
            break;
        }
    }
    return result;
}

+ (void)hideHudView:(MBProgressHUD*)hud
{
    // modify by songjk 必须判断是不是MBProgressHUD类型
    if ((hud && [hud isKindOfClass:[MBProgressHUD class]])) {
        [hud hide:YES];
        hud = nil;
    }
}

//需指定 删除hub的父试图，通常是self.view self.view.window
+ (void)hideHudViewWithSuperView:(UIView*)superView
{
    MBProgressHUD* hud = (MBProgressHUD*)[superView viewWithTag:NSIntegerMax];
    if (hud) {
        [self hideHudView:hud];
    }
}

+ (NSDictionary*)stringToDictionary:(NSString*)string
{
    if ([string isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary*)string;
    }
    if (!string || string.length < 1)
        return nil;

    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
    if (error) {
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToString:(NSDictionary*)dic
{
    if (!dic)
        return nil;
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (error) {
        return nil;
    }
    return string;
}

+ (void)setFontSizeToFitWidthWithLabel:(id)view labelLines:(NSInteger)lines
{
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel* label = view;
        label.numberOfLines = lines;
        label.minimumScaleFactor = 8;
        label.adjustsFontSizeToFitWidth = YES;
    }
    else if ([view isKindOfClass:[UITextField class]]) {
        UITextField* textField = view;
        textField.minimumFontSize = 8;
        textField.adjustsFontSizeToFitWidth = YES;
    }
}

+ (CGFloat)saftToCGFloat:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSNumber class]]) {
        return [idVaule floatValue];
    }
    return [[self saftToNSString:idVaule] floatValue];
}

+ (double)saftToDouble:(id)idVaule
{
    if ([idVaule isKindOfClass:[NSNumber class]]) {
        return [idVaule doubleValue];
    }
    return [[self saftToNSString:idVaule] doubleValue];
}

+ (void)hideKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

+ (void)creatLocalNotification:(NSTimeInterval)timeInterval timeZone:(NSTimeZone*)zone userInfor:(NSDictionary*)userDic alertBody:(NSString*)body
{

    UILocalNotification* notification = [[UILocalNotification alloc] init]; //新建通知
    notification.soundName = UILocalNotificationDefaultSoundName; //

    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:timeInterval]; //距现在多久后触发代理方法
    notification.timeZone = zone; //设置时区
    notification.userInfo = userDic; //在字典用存需要的信息
    notification.alertBody = body; //提示信息弹出提示框
    notification.alertAction = @"open"; //提示框按钮
    //    notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失

    [[UIApplication sharedApplication] scheduleLocalNotification:notification]; //将新建的消息加到应用消息队列中
}

+ (BOOL)isPassportNo:(NSString*)pNo
{
    //    NSString * regex = @"^[A-Z][0-9]{7,8}$";
    //    NSString * regex = @"^([A-Z][0-9]{8}|[0-9]{9}|[A-Z][0-9]{7}[A-Z])$";
    NSString* regex = @"^[A-Za-z0-9]{9}$"; // 数字字母混9位
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:pNo];

    return isMatch;
}

//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//4. 第17位表示性别，双数表示女，单数表示男
//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
//6. 出生年份的前两位必须是19或20
+ (BOOL)verifyIDCardNumber:(NSString*)value country:(NSString*)country
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([value length] != 18 && [value length] != 15 && [value length] != 10) {
        return NO;
    }

    if ([value length] == 10) {
        NSString* regex;
        if ([country isEqualToString:kLocalized(@"GYHS_Base_China_Hong_Kong")]) {
            regex = @"^[A-Z]{1,2}[0-9]{6}\\(?[0-9A]\\)?$";
        }
        else if ([country isEqualToString:kLocalized(@"GYHS_Base_China_Macau")]) {
            regex = @"^[1|5|7][0-9]{6}\\(?[0-9A-Z]\\)?$";
        }
        else if ([country isEqualToString:kLocalized(@"GYHS_Base_China_Taiwan")]) {
            regex = @"^[a-zA-Z][0-9]{9}$";
        }
        NSPredicate* identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [identityCardPredicate evaluateWithObject:value];
    }
    // 15时粗略检查
    if ([value length] == 15) {
        NSString* regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
        NSPredicate* identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [identityCardPredicate evaluateWithObject:value];
    }

    NSString* mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString* leapMmdd = @"0229";
    NSString* year = @"(19|20)[0-9]{2}";
    NSString* leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString* yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString* leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString* yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString* area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString* regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd, @"[0-9]{3}[0-9Xx]"];

    NSPredicate* regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }

    int summary = ([value substringWithRange:NSMakeRange(0, 1)].intValue + [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7
        + ([value substringWithRange:NSMakeRange(1, 1)].intValue + [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9
        + ([value substringWithRange:NSMakeRange(2, 1)].intValue + [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10
        + ([value substringWithRange:NSMakeRange(3, 1)].intValue + [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5
        + ([value substringWithRange:NSMakeRange(4, 1)].intValue + [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8
        + ([value substringWithRange:NSMakeRange(5, 1)].intValue + [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4
        + ([value substringWithRange:NSMakeRange(6, 1)].intValue + [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2
        + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6
        + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;

    NSInteger remainder = summary % 11;
    NSString* checkBit = @"";
    NSString* checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder, 1)]; // 判断校验位

    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17, 1)] uppercaseString]];
}

+ (BOOL)isBankCardNo:(NSString*)pNo
{
    //    NSString * regex = @"^([0-9]{16}|[0-9]{19})$";
    NSString* regex = @"^([0-9]{5,30})$"; // 数字16到19位
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:pNo];

    return isMatch;
}

+ (UIImage*)imageCompressForWidth:(UIImage*)sourceImage targetWidth:(CGFloat)defineWidth
{
    UIImage* newImage = nil;
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
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }
        else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
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
    if (newImage == nil) {
        DDLogDebug(@"scale image fail");
    }

    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGSize)sizeForString:(NSString*)str font:(UIFont*)font width:(CGFloat)width
{
    return [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
}

+ (NSString*)getResNO:(NSString*)resNo
{
    if (!resNo) {
        return @"";
    }
    NSRange range = [resNo rangeOfString:@"_"];
    NSString* result = resNo;
    if (range.location != NSNotFound) {
        result = [resNo substringFromIndex:range.location + 1];
        result = [self getResNO:result];
    }
    return result;
}
+ (BOOL)isValidTelPhoneNum:(NSString*)phoneNum
{
    // NSString *check = @"^([+]\\d{2}[-]?)?(\\d{4}[-]?)?\\d{7,8}$";
    NSString* check = @"^(\\+?\\d{2,3}\\-)?(0\\d{2,3}-?)?\\d{7,8}$";

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", check];
    return [predicate evaluateWithObject:phoneNum];
}
/** 
 * 根据id获取服务名称
 *
 * 此处不可以做国际化 传回服务器的值
 *  @param serviceCode 服务码
 *
 *  @return 服务名称
 */
+ (NSString*)getServiceNameWithServiceCode:(NSString*)serviceCode
{
    if (!serviceCode || serviceCode.length == 0) {
        return @"";
    }
    NSString* strName = @"";
    if ([serviceCode isEqualToString:@"1"]) {
        strName = @"即时送达";
    }
    else if ([serviceCode isEqualToString:@"2"]) {
        strName = @"送货上门";
    }
    else if ([serviceCode isEqualToString:@"3"]) {
        strName = @"货到付款";
    }
    else if ([serviceCode isEqualToString:@"4"]) {
        strName = @"门店自提";
    }
    else if ([serviceCode isEqualToString:@"6"]) {
        strName = @"6";
    }
    return strName;
}

/** add by songjk 把英文逗号改成中文逗号
 *
 *  @return
 */
+ (NSString*)exchangeENCommaToChCommaWithString:(NSString*)string
{
    if (!string || string.length == 0 || ![string isKindOfClass:[NSString class]]) {
        return @"";
    }
    NSString* strResult = string;
    if ([strResult rangeOfString:@","].location != NSNotFound) {
        strResult = [strResult stringByReplacingOccurrencesOfString:@"," withString:@"，"];
        strResult = [self exchangeENCommaToChCommaWithString:strResult];
    }
    return strResult;
}

+ (BOOL)isCHNameWithName:(NSString*)name
{
    if (!name || name.length == 0 || ![name isKindOfClass:[NSString class]]) {
        return NO;
    }
    NSString* check = @"[\u4E00-\u9FA5]{1,10}·{0,1}•{0,1}[\u4E00-\u9FA5]{0,10}";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", check];
    return [predicate evaluateWithObject:name];
}

+ (BOOL)isUserName:(NSString*)name
{
    if ([[self class] checkStringInvalid:name]) {
        return NO;
    }

    // 匹配中文，英文字母和点 空格
    NSString* check = @"^[\u4e00-\u9fa5．▪·•.a-zA-Z\x20\t]+$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", check];
    return [predicate evaluateWithObject:name];
}

+ (BOOL)isValidTureWithName:(NSString*)validTureWithName
{
    // eg：Mick Chen
    NSString* englishSpaceName = @"^[a-zA-Z]+( ){1}([a-zA-Z]+$)";
    // eg：纯中文”或“纯英文”  eg:大兵   or：Jack
    NSString* chineseOrEnglishName = @"^[a-zA-Z]+$|^[\u4E00-\u9FA5]+$";
    //eg: 少数名族 eg：大马·奥宝宝
    NSString* lessPeopleName = @"^[\u4E00-\u9FA5]{1,18}(?:·[\u4E00-\u9FA5]{1,18}){1}";
    NSPredicate* pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", englishSpaceName];
    NSPredicate* pre1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chineseOrEnglishName];
    NSPredicate* pre2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lessPeopleName];
    return [pre evaluateWithObject:validTureWithName] || [pre1 evaluateWithObject:validTureWithName] || [pre2 evaluateWithObject:validTureWithName];
}

//中文按拼音排序, 返回tableview右方 indexArray
+ (NSMutableArray*)IndexArray:(NSArray*)stringArr
{
    NSMutableArray* tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray* A_Result = [NSMutableArray array];
    NSString* tempString;

    for (NSString* object in tempArray) {
        if (((GYUtils*)object).pinYin.length > 0) {
            char c = [((GYUtils*)object).pinYin characterAtIndex:0];
            NSString* pinyin = [((GYUtils*)object).pinYin substringToIndex:1];

            if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))) {
                if (![A_Result containsObject:@"#"]) {
                    [A_Result addObject:@"#"];
                }
                tempString = pinyin;
            }
            else {
                //不同
                if (![tempString isEqualToString:pinyin]) {
                    [A_Result addObject:pinyin];
                    tempString = pinyin;
                }
            }
        }
    }

    if ([A_Result containsObject:@"#"]) {
        [A_Result removeObject:@"#"];
        [A_Result addObject:@"#"];
    }
    return A_Result;
}

// 返回联系人
+ (NSMutableArray*)LetterSortArray:(NSArray*)stringArr
{
    NSMutableArray* tempArray = [self ReturnSortChineseArrar:stringArr];
    NSMutableArray* LetterResult = [NSMutableArray array];
    NSMutableArray* item = [NSMutableArray array];
    NSMutableArray* lastItem = [NSMutableArray array];
    NSString* tempString;
    //拼音分组
    for (NSString* object in tempArray) {
        if (((GYUtils*)object).pinYin.length > 0) {

            char c = [((GYUtils*)object).pinYin characterAtIndex:0];
            NSString* pinyin = [((GYUtils*)object).pinYin substringToIndex:1];
            NSString* string = ((GYUtils*)object).string;

            GYShopBrandModel* model = [[GYShopBrandModel alloc] init];
            //            DDLogDebug(@"#%@#",pinyin);

            if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))) {
                model.brandName = string;
                model.isSelect = NO;
                [lastItem addObject:model];
                tempString = pinyin;
            }
            else {
                //不同
                if (![tempString isEqualToString:pinyin]) {
                    //分组
                    item = [NSMutableArray array];

                    model.brandName = string;
                    model.isSelect = NO;

                    [item addObject:model];
                    [LetterResult addObject:item];
                    //遍历
                    tempString = pinyin;
                }
                else { //相同
                    model.brandName = string;
                    model.isSelect = NO;
                    [item addObject:model];
                }
            }
        }
    }

    if (lastItem.count) {
        [LetterResult addObject:lastItem];
    }

    return LetterResult;
}

//返回排序好的字符拼音
+ (NSMutableArray*)ReturnSortChineseArrar:(NSArray*)stringArr
{
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray* chineseStringsArray = [NSMutableArray array];
    for (int i = 0; i < [stringArr count]; i++) {
        GYUtils* chineseString = [[GYUtils alloc] init];
        chineseString.string = [NSString stringWithString:[stringArr objectAtIndex:i]];
        if (chineseString.string == nil) {
            chineseString.string = @"";
        }
        //去除两端空格和回车
        chineseString.string = [chineseString.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        //此方法存在一些问题 有些字符过滤不了
        //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        //chineseString.string = [chineseString.string stringByTrimmingCharactersInSet:set];

        //这里我自己写了一个递归过滤指定字符串   RemoveSpecialCharacter
        chineseString.string = [GYUtils RemoveSpecialCharacter:chineseString.string];
        DDLogDebug(@"string====%@", chineseString.string);

        //判断首字符是否为字母
        NSString* regex = @"[A-Za-z]+";
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        NSString* initialStr = [chineseString.string length] ? [chineseString.string substringToIndex:1] : @"";
        if ([predicate evaluateWithObject:initialStr]) {
            DDLogDebug(@"chineseString.string== %@", chineseString.string);
            //首字母大写
            chineseString.pinYin = [chineseString.string capitalizedString];
        }
        else {
            if (![chineseString.string isEqualToString:@""]) {
                NSString* pinYinResult = [NSString string];
                for (int j = 0; j < chineseString.string.length; j++) {
                    NSString* singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                              pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
                    //                    DDLogDebug(@"singlePinyinLetter ==%@",singlePinyinLetter);

                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseString.pinYin = pinYinResult;
            }
            else {
                chineseString.pinYin = @"";
            }
        }
        [chineseStringsArray addObject:chineseString];
    }
    //按照拼音首字母对这些Strings进行排序
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];

    for (int i = 0; i < [chineseStringsArray count]; i++) {
        DDLogDebug(@"chineseStringsArray====%@", ((GYUtils*)[chineseStringsArray objectAtIndex:i]).pinYin);
    }
    DDLogDebug(@"-----------------------------");
    return chineseStringsArray;
}

#pragma mark - 返回一组字母排序数组
+ (NSMutableArray*)SortArray:(NSArray*)stringArr
{
    NSMutableArray* tempArray = [self ReturnSortChineseArrar:stringArr];

    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray* result = [NSMutableArray array];
    for (int i = 0; i < [stringArr count]; i++) {
        [result addObject:((GYUtils*)[tempArray objectAtIndex:i]).string];
        DDLogDebug(@"SortArray----->%@", ((GYUtils*)[tempArray objectAtIndex:i]).string);
    }
    return result;
}

//过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符
+ (NSString*)RemoveSpecialCharacter:(NSString*)str
{
    NSRange urgentRange = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound) {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

+ (CGFloat)fontSizeScreen:(CGFloat)originSize
{
    return originSize / ([UIScreen mainScreen].scale);
}

+ (NSString*)getStringDateFromMillisecond:(NSString*)millisend dateFormat:(NSString*)dateFormat
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:dateFormat];

    NSString* time = millisend;
    NSDate* confromTime = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)([time longLongValue] / 1000.0)];
    return [dateFormatter stringFromDate:confromTime];
}

+ (NSDate*)stringToDate:(NSString*)string
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* fromdate = [dateformatter dateFromString:string];
    NSTimeZone* fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate* fromDate = [fromdate dateByAddingTimeInterval:frominterval];
    DDLogDebug(@"fromdate=%@", fromDate);
    return fromDate;
}

+ (NSDate*)dateFromeString:(NSString*)strDate formate:(NSString*)formatter
{
    return [self dateFromeString:strDate formate:formatter forceCnZone:NO];
}

+ (NSDate*)dateFromeString:(NSString*)strDate formate:(NSString*)formatter forceCnZone:(BOOL)cnZone
{
    NSDate* date = nil;

    @try {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        if (cnZone == YES) {
            dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600 * 8];
        }
        dateFormatter.dateFormat = formatter;
        date = [dateFormatter dateFromString:strDate];
    }
    @catch (NSException* exception) {
        DDLogDebug(@"NSException= %@", [exception description]);
        date = nil;
    }

    return date;
}

+ (NSString*)currentTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}

+ (void)collectUserInfoAppMapLocationsWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSString* locationStr = [NSString stringWithFormat:@"latitude=%f,longitude=%f", locationCoordinate.latitude, locationCoordinate.longitude];
    [dict setObject:[self currentTime] forKey:@"time"];
    [dict setObject:locationStr forKey:@"location"];
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoAppMapLocations];
    NSMutableArray* newArray;
    if (array) {
        newArray = [NSMutableArray arrayWithArray:array];
    }
    else {
        newArray = [[NSMutableArray alloc] init];
    }

    [newArray addObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:kUserInfoAppMapLocations];
}

+ (void)collectUserInfoAppPlayTimesWithStatus:(NSString*)status
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self currentTime] forKey:@"time"];
    [dict setObject:status forKey:@"status"];
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoAppPlayTimes];
    NSMutableArray* newArray;
    if (array) {
        newArray = [NSMutableArray arrayWithArray:array];
    }
    else {
        newArray = [[NSMutableArray alloc] init];
    }

    [newArray addObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:kUserInfoAppPlayTimes];
}

+ (void)collectUserInfoAppRequestURLsWith:(NSString*)url parmas:(NSDictionary*)params
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[self currentTime] forKey:@"time"];
    [dict setObject:url forKey:@"url"];
    if (!params) {
        params = [[NSDictionary alloc] init];
    }
    [dict setObject:params forKey:@"params"];
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoAppRequestURLs];
    NSMutableArray* newArray;
    if (array) {
        newArray = [NSMutableArray arrayWithArray:array];
    }
    else {
        newArray = [[NSMutableArray alloc] init];
    }

    [newArray addObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:kUserInfoAppRequestURLs];
}

+ (NSString*)encryptUserName:(NSString*)userName
{
    if ([GYUtils checkStringInvalid:userName]) {
        return @"";
    }

    NSMutableString* star = [[NSMutableString alloc] initWithString:@"*"];
    if (userName.length != 0) {
        for (NSInteger i = 1; i < userName.length - 1; i++) {
            [star appendString:@"*"];
        }
    }
    return [NSString stringWithFormat:@"%@%@", [userName substringToIndex:1], star];

    //    if (userName.length <= 1) {
    //        return [NSString stringWithFormat:@"%@ ** ", userName];
    //    }
    //
    //    return [NSString stringWithFormat:@"%@ ** ", [userName substringToIndex:1]];
}

+ (NSString*)encryptIdentityCard:(NSString*)cardId
{
    if ([GYUtils checkStringInvalid:cardId]) {
        return @"";
    }

    if (cardId.length <= 10) {
        return cardId;
    }

    return [NSString stringWithFormat:@"%@ **** %@", [cardId substringToIndex:6], [cardId substringFromIndex:cardId.length - 4]];
}

+ (NSString*)encryptBusinessLicense:(NSString*)cardId
{
    if ([GYUtils checkStringInvalid:cardId]) {
        return @"";
    }

    if (cardId.length <= 3) {
        return cardId;
    }

    return [NSString stringWithFormat:@"%@ **** %@", [cardId substringToIndex:1], [cardId substringFromIndex:cardId.length - 2]];
}

+ (NSString*)encryptPassport:(NSString*)cardId
{
    if ([GYUtils checkStringInvalid:cardId]) {
        return @"";
    }

    if (cardId.length <= 5) {
        return cardId;
    }

    return [NSString stringWithFormat:@"%@ **** %@", [cardId substringToIndex:3], [cardId substringFromIndex:cardId.length - 2]];
}

+ (NSString*)encryptEmail:(NSString*)email
{
    if ([GYUtils checkStringInvalid:email]) {
        return @"";
    }

    NSRange emailFlagRange = [email rangeOfString:@"@"];
    if (emailFlagRange.location != NSNotFound) {
        NSUInteger startIndex = 2;
        if (emailFlagRange.location < 2) {
            startIndex = emailFlagRange.location;
        }

        return [NSString stringWithFormat:@"%@***%@",
                         [email substringToIndex:startIndex],
                         [email substringFromIndex:emailFlagRange.location]];
    }

    return email;
}

#pragma mark - 消费者
+ (NSString*)deviceUdid
{
    NSUUID* deviceUDID = [[UIDevice currentDevice] identifierForVendor];
    return [deviceUDID UUIDString];
}

+ (NSString*)separatedStringByFlag:(NSString*)value flag:(NSString*)flag
{
    if ([GYUtils checkStringInvalid:value]) {
        return @"";
    }

    NSArray* valueAry = [value componentsSeparatedByString:flag];
    if ([valueAry count] >= 1) {
        return valueAry[0];
    }

    return value;
}

+ (void)showMessage:(NSString*)message
{
    //[GYAlertView showMessage:message];
    [[self class] showToast:message];
}

+ (void)showMessage:(NSString*)message confirm:(void (^)())confirmBlock
{
    [GYAlertView showMessage:message confirmBlock:^{
        if (confirmBlock) {
            confirmBlock();
        }
    }];
}

+ (void)showMessge:(NSString*)message confirm:(void (^)())confirmBlock cancleBlock:(void (^)())cancleBlock
{
    [GYAlertView showMessage:message cancleBlock:^{
        if (cancleBlock) {
            cancleBlock();
        }
    } confirmBlock:^{
        if (confirmBlock) {
            confirmBlock();
        }
    }];
}

+ (void)showMessage:(NSString*)message confirm:(void (^)())confirmBlock withColor:(UIColor*)color
{
    [GYAlertView showMessage:message confirmBlock:^{
        if (confirmBlock) {
            confirmBlock();
        }
    } withColor:color];
}

+ (void)showMessge:(NSString*)message confirm:(void (^)())confirmBlock cancleBlock:(void (^)())cancleBlock withColor:(UIColor*)color
{
    [GYAlertView showMessage:message cancleBlock:^{
        if (cancleBlock) {
            cancleBlock();
        }
    } confirmBlock:^{
        if (confirmBlock) {
            confirmBlock();
        }
    } withColor:color];
}

+ (NSDictionary*)netWorkCommonParams
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    /*
     [dic setObject:@"" forKey:@"appid"];
     [dic setObject:@"" forKey:@"userid"];
     [dic setObject:@"" forKey:@"sign"];
     [dic setObject:@"" forKey:@"ver"];
     */

    if (![self checkStringInvalid:globalData.loginModel.token]) {
        [dic setObject:globalData.loginModel.token forKey:@"token"];
    }

    return dic;
}

+ (NSDictionary*)netWorkHECommonParams
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    /*
     [dic setObject:@"" forKey:@"appid"];
     [dic setObject:@"" forKey:@"userid"];
     [dic setObject:@"" forKey:@"sign"];
     [dic setObject:@"" forKey:@"ver"];
     */
    
    if (![self checkStringInvalid:globalData.loginModel.token]) {
        [dic setObject:globalData.loginModel.token forKey:@"token"];
    }
    if (![self checkStringInvalid:globalData.loginModel.resNo]) {
        [dic setObject:globalData.loginModel.resNo forKey:@"resNo"];
    }
    if (![self checkStringInvalid:globalData.loginModel.custId]) {
        [dic setObject:globalData.loginModel.custId forKey:@"custId"];
    }
    // 1 web,2 手机 3 平板
    [dic setObject:@"2" forKey:@"channelType"];
    
    
    return dic;
}

+ (void)parseNetWork:(NSError*)error resultBlock:(void (^)(NSInteger retCode))resultBlock
{
    if (error == nil || ![error isKindOfClass:[NSError class]]) {
        DDLogInfo(@"The error:%@ is invalid.", error);
        if (resultBlock) {
            resultBlock([error code]);
        }
        return;
    }
    
    NSInteger returnCode = [error code];
    
    // 网络不可用
    if (returnCode == -9000) {
        if (resultBlock) {
            resultBlock([error code]);
        }
        return;
    }
    // 解析返回码失败
    else if (returnCode == -9001) {
        [GYUtils showToast:kLocalized(@"GYHS_Base_netError")];
        if (resultBlock) {
            resultBlock([error code]);
        }
        return;
    }
    
    // 互商、互动 key失效，需要重新登录
    NSArray *needReloginAry = @[@208, @210, @215, @810];
    
    if ([needReloginAry containsObject:[NSNumber numberWithInteger:returnCode]]) {
        DDLogInfo(@"key expire, need to relogin.");
        if (resultBlock) {
            resultBlock([error code]);
        }
        
        [[GYHSLoginManager shareInstance] reLogin];
        return;
    }
    
    NSString* msg = [[GYHSLoginManager shareInstance] showErrorMsg:[NSString stringWithFormat:@"%ld", (long)returnCode]
                                                          errorMsg:[error localizedDescription]];
    
    if (resultBlock) {
        [GYUtils showMessage:msg confirm:^{
            resultBlock(returnCode);
        }];
    }
    else {
        [GYUtils showToast:msg];
    }
}

+ (CGFloat)scaleY
{
    if (kScreenHeight > 480) {
        return kScreenHeight / 568.0;
    }
    else {
        return 1.0;
    }
}

+ (NSMutableDictionary*)valueArray:(NSArray*)valueArray keyArray:(NSArray*)keyArray
{
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
    if (keyArray.count == valueArray.count) {
        for (NSInteger i=0;i<keyArray.count;i++) {
            [mutDic setObject:valueArray[i] forKey:keyArray[i]];
        }
    }
    return mutDic;
}
@end
