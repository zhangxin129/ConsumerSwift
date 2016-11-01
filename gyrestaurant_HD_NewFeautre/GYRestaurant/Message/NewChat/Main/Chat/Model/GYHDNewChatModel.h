//
//  GYHDNewChatModel.h
//  HSConsumer
//
//  Created by shiang on 16/2/26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDNewChatModel : NSObject
/**消息数字ID*/
@property(nonatomic, copy, readonly)NSString *chatMessageID;
/**消息富文本*/
@property(nonatomic, strong, readonly)NSAttributedString *chatContentAttString;
/**消息体*/
@property(nonatomic, copy, readonly)NSString *chatBody;
/**消息ID*/
@property(nonatomic, copy, readonly)NSString *chatCard;
/**消息数据体*/
@property(nonatomic, copy)NSString  *chatDataString;
/**发送者FromID*/
@property(nonatomic, copy, readonly)NSString *chatFromID;
/**接收者ToID*/
@property(nonatomic, copy, readonly)NSString *chatToID;
/**接收时间*/
@property(nonatomic, copy)NSString *chatRecvTime;
/**是否为自己发送*/
@property(nonatomic, assign, readonly)BOOL chatIsSelfSend;
/**发送状态*/
@property(nonatomic, assign)NSInteger chatSendState;
@property(nonatomic, copy)NSString* headIconStr;
@property(nonatomic,copy)NSString*content;
@property(nonatomic,copy)NSString*primaryId;
//商品详情数据
@property(nonatomic,copy)NSString*iconUrl;//图片url
@property(nonatomic,copy)NSString*shopName;//商品名
@property(nonatomic,copy)NSString*descripStr;//商品描述
@property(nonatomic,copy)NSString*hsCoinDStr;//互生币
@property(nonatomic,copy)NSString*intergateStr;//积分

+ (instancetype)chatModelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
