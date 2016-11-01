//
//  GYHDUtils.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, GYHDDataBaseCenterMessageSendStateOption) {
    GYHDDataBaseCenterMessageSendStateSuccess = 1,          // 发送成功
    GYHDDataBaseCenterMessageSendStateSending,              // 发送中
    GYHDDataBaseCenterMessageSendStateFailure,               // 发送失败
};



@interface GYHDUtils : NSObject
/**富文本转普通文字*/
+ (NSString *)StringFromEmojiAttributedString:(NSAttributedString *)attString;
/**普通文字转富文本*/
+ (NSAttributedString *)EmojiAttributedStringFromString:(NSString *)string;
/**
 *	图片压缩
 *
 *	@param  sourceImage         要压缩的图片
 *  @param  defineWidth         压缩后的大小
 *	@return	转换后的字符串
 */
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**获取MP4文件夹*/
+(NSString *)mp4folderNameString;
/**获取MP3文件夹*/
+ (NSString *)mp3folderNameString;
/**获取Image文夹*/
+ (NSString *)imagefolderNameString;
/**字符串转字典*/
+ (NSDictionary *)stringToDictionary:(NSString *)string;
/**字典转字符串*/
+ (NSString *)dictionaryToString:(NSDictionary *)dic;
/**过滤html中特殊字符*/
+ (NSDictionary *)stringToDictionaryEscapseHtml:(NSString *)string;
/**
 * 把字典所以值转换成字符串
 */
+ (void)checkDict:(NSMutableDictionary *)dict;
/**
 * 免打扰模式设置
 */
+(BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;

+ (float)heightForString:(NSString*)value fontSize:(float)fontSize andWidth:(float)width;
+ (CGFloat)heightForAttString:(NSAttributedString *) attString widht:(CGFloat)width;

/**文字消息*/
+(NSString *)chatText;
/**图片消息*/
+(NSString *)chatImage;
/**位置消息*/
+(NSString *)chatMap;
/**音频消息*/
+(NSString *)chatAudio;
/**视频消息*/
+(NSString *)chatVdieo;
/**商品消息*/
+(NSString *)chatGoods;
/**订单消息*/
+(NSString *)chatOrder;
/**欢迎语*/
+(NSString *)chatGreeting;
/**发送中*/
+(NSString *)chatSending;
/**发送失败*/
+(NSString *)chatSendFailure;
/**发送成功*/
+(NSString *)chatSendSuccess;

/**
 * 根据时间字符串返回需要的文字
 */
+(NSString *)messageTimeStrFromTimerString:(NSString *)timeString;

/**
 * 通过指定string和字体和最大宽度得到size
 * @str string
 * @font 字体
 * @width 宽度
 *
 */
+ (CGSize)sizeForString:(NSString*)str font:(UIFont*)font width:(CGFloat)width;

@end
