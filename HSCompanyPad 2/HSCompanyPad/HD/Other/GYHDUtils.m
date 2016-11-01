//
//  GYHDUtils.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDUtils.h"
#import "GYHDEmojiTextAttachment.h"

static NSMutableArray *emojiArray = nil;

@implementation GYHDUtils

/**富文本转普通文字*/
+ (NSString *)StringFromEmojiAttributedString:(NSAttributedString *)attString {
    NSMutableAttributedString* att = [[NSMutableAttributedString alloc] initWithAttributedString:attString];
    __block NSMutableString* messageString = [NSMutableString string];
    
    if (!emojiArray) {
        NSMutableArray* array = [NSMutableArray array];
        for (int i = 1; i <= 60; i++) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            dict[@"emojiName"] = [NSString stringWithFormat:@"[%03d]", i];
            dict[@"emoji"] = [UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]];
            [array addObject:dict];
        }
        emojiArray = array;
    }
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:0 usingBlock:^(NSDictionary<NSString*, id>* _Nonnull attrs, NSRange range, BOOL* _Nonnull stop) {
        GYHDEmojiTextAttachment *attChment =  attrs[@"NSAttachment"];
        if (attChment) {
            for (NSDictionary *dic in emojiArray) {
                NSString *emojiName = dic[@"emojiName"];
                if ([emojiName
                     isEqualToString:attChment.emojiName]) {
                    [messageString
                     appendString:dic[@"emojiName"]];
                    break;
                }
            }
        }else {
            [messageString appendString: [att attributedSubstringFromRange:range].string];
        }
    }];
    
    return messageString;
}
/**普通文字转富文本*/
+ (NSAttributedString *)EmojiAttributedStringFromString:(NSString *)string {
    
    if (string==nil) {
        
        return nil;
    }
    
    NSMutableAttributedString *messageAttrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSString* pattern = @"\\[[0-9]{3}\\]";
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray* results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    // 3.遍历结果
    [results enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult* result, NSUInteger idx, BOOL* _Nonnull stop) {
        NSString *imageName = [[string substringWithRange:result.range] substringWithRange:NSMakeRange(1, 3)];
        GYHDEmojiTextAttachment *textAtt = [[GYHDEmojiTextAttachment alloc] init];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            textAtt.emojiName = [NSString stringWithFormat:@"[%@]",imageName];
            textAtt.image = image;
//            textAtt.bounds = CGRectMake(0, -3, 13, 13);
            NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAtt];
            [messageAttrStr replaceCharactersInRange:result.range withAttributedString:att];
        }
    }];
    return messageAttrStr;
}
/**
 *	图片压缩
 *
 *	@param  sourceImage         要压缩的图片
 *  @param  defineWidth         压缩后的大小
 *	@return	转换后的字符串
 */

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
        
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
/**获取MP4文件夹*/
+ (NSString *)mp4folderNameString
{

    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDmp4"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}
/**获取MP3文件夹*/
+ (NSString *)mp3folderNameString
{

    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDmp3"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
/**获取Image文夹*/
+(NSString *)imagefolderNameString
{

    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HDimage"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
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

/**
 * 把字典所以值转换成字符串
 */
+ (void)checkDict:(NSMutableDictionary *)dict
{
    for (NSString *key in [dict allKeys]) {
        if([dict[key] isEqual:[NSNull null]] || dict[key] == nil)
        {
            dict[key] = @"";
        }
        if ([dict[key] isKindOfClass:[NSNumber class]]) {
            dict[key] = [NSString stringWithFormat:@"%@",dict[key]];
            
        }
        if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            [ self checkDict:dict[key]];
        }
        if ([dict[key] isKindOfClass:[NSArray class]]) {
            for (NSMutableDictionary *chilidDict in dict[key]) {
                [self checkDict:chilidDict];
            }
        }
    }
    
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
+ (CGFloat)heightForAttString:(NSAttributedString *) attString widht:(CGFloat)width
{
    return  [attString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

+(BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour{
    
    NSDate *date8 = [self getCustomDateWithHour:8];
    
    NSDate *date23 = [self getCustomDateWithHour:22];
    
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

/**文字消息*/
+(NSString *)chatText {
    return @"00";
}
/**图片消息*/
+(NSString *)chatImage {
    return @"10";
}
/**位置消息*/
+(NSString *)chatMap {
    return @"11";
}
/**音频消息*/
+(NSString *)chatAudio {
    return @"13";
}
/**视频消息*/
+(NSString *)chatVdieo {
    return @"14";
}
/**商品消息*/
+(NSString *)chatGoods {
    return @"15";
}
/**欢迎语*/
+(NSString *)chatGreeting {
    return @"20";
}

/**订单消息*/
+(NSString *)chatOrder {
    return @"16";
}

+(NSString *)chatSending {
    return @"sending";
}
/**发送失败*/
+(NSString *)chatSendFailure {
    return @"sendFailure";
}
/**发送成功*/
+(NSString *)chatSendSuccess {
    return @"sendSuccess";
}

/**
 * 根据时间字符串返回需要的文字
 */
+ (NSString *)messageTimeStrFromTimerString:(NSString *)timeString
{
    if (!timeString || [timeString isEqualToString:@""]) return @"";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    _created_at = @"Tue Sep 30 17:06:25 +0600 2014";
    
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:timeString];

    if ( [self isThisYearWithData:createDate]) { // 今年
        if ([self isTheDayBeforeYesterdayWithData:createDate]) {
//            fmt.dateFormat = @"前天";
//            return [fmt stringFromDate:createDate];
            return @"前天";
        } else if ([self isYesterdayData:createDate]) { // 昨天
//            fmt.dateFormat = @"昨天";
//            return [fmt stringFromDate:createDate];
            return @"昨天";
        } else if ([self isTodayData:createDate]) { // 今天
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:createDate];
        } else { // 今年的其他日子
            fmt.dateFormat = @"yyyy-MM-dd";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
    return @"";
}

/**
 *  判断某个时间是否为今年
 */
+ (BOOL)isThisYearWithData:(NSDate *)oldData
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    if (oldData!=nil) {
    
        NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:oldData];
        NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
        return dateCmps.year == nowCmps.year;
    }else{

        return NO;
    }

}

/**
 *  判断某个时间是否为昨天
 */
+ (BOOL)isYesterdayData:(NSDate *)oldData
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:oldData];

    NSString *nowStr = [fmt stringFromDate:now];
    
    NSDate *date = [fmt dateFromString:dateStr];
    
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}
/**
 * 判断某个时间是否为前天
 */
+ (BOOL)isTheDayBeforeYesterdayWithData:(NSDate *)oldData
{
    NSDate *now = [NSDate date];

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    

    NSString *dateStr = [fmt stringFromDate:oldData];

    NSString *nowStr = [fmt stringFromDate:now];

    NSDate *date = [fmt dateFromString:dateStr];

    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 2;
}
/**
 *  判断某个时间是否为今天
 */
+ (BOOL)isTodayData:(NSDate *)oldData
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:oldData];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}

+ (CGSize)sizeForString:(NSString*)str font:(UIFont*)font width:(CGFloat)width
{
    return [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
}


@end

