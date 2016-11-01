//
//  GYHDDingDanModel.h
//  HSConsumer
//
//  Created by shiang on 16/1/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDMessageListModel : NSObject
/**
 * 订单正文
 */
@property (nonatomic, copy, readonly) NSString* messageListContent;
/**
 * 订单正文富文本
 */
@property (nonatomic, strong, readonly) NSMutableAttributedString* messageListContentAttributedStr;
/**
 * 订单标题
 */
@property (nonatomic, copy, readonly) NSString* messageListTitle;
/**
 * 订单时间
 */
@property (nonatomic, copy, readonly) NSString* messageListTimer;
/**消息二进制*/
@property (nonatomic, copy, readonly) NSString* messageData;
/**消息MSG_ID*/
@property (nonatomic, copy, readonly) NSString* messageID;
/**消息Code*/
@property (nonatomic, assign, readonly) NSInteger messageCode;
/**消息体*/
@property (nonatomic, copy, readonly) NSString* messageBody;
+ (instancetype)dingDanModelWithDictionary:(NSDictionary*)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
