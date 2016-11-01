//
//  GYHDMessageModel.h
//  HSConsumer
//
//  Created by shiang on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYHDMessageCenter.h"

typedef void (^GYHDMessageModelPushNextControllerBlock)();

@interface GYHDMessageModel : NSObject

#pragma mark-- 子控件内容
/**
 * 消息置顶
 */
@property (nonatomic, assign, readonly) GYHDPopMessageState messageState;
@property (nonatomic, copy) NSString* messgeTopString;
/**
 * 用户昵称颜色
 */
@property (nonatomic, strong, readonly) UIColor* userNameColoer;
/**
 * 消息唯一标示符
 */
@property (nonatomic, copy, readonly) NSString* messageCard;
/**
 * 跳转到下个一个控制器的名字
 */
@property (nonatomic, assign, readonly) Class pushNextController;
/**
 * 消息正文
 */
@property (nonatomic, copy, readonly) NSString* messageContentStr;
/**
 * 消息富文本正文
 */
@property (nonatomic, strong, readonly) NSMutableAttributedString* messageContentAttributedString;
/**
 * 消息时间
 */
@property (nonatomic, copy, readonly) NSString* messageTimeStr;
/**
 * 用户昵称
 */
@property (nonatomic, copy, readonly) NSString* userNameStr;
/**
 * 用户头像
 */
@property (nonatomic, strong, readonly) NSURL* userIconUrl;
/**
 *  未读消息总数
 */
@property (nonatomic, copy, readonly) NSString* unreadMessageCountStr;
/**消息Code*/
@property (nonatomic, assign, readonly) NSInteger messageCode;
#pragma mark-- 子控件Frame
@property(nonatomic, assign, readonly) CGFloat cellHeight;
+ (instancetype)messageModelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

