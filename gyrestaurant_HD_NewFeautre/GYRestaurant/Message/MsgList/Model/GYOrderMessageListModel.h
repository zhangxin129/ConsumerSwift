//
//  GYOrderMessageListModel.h
//  GYRestaurant
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYOrderMessageListModel : NSObject

@property(nonatomic, copy) NSString *messageListContent;//消息内容
@property(nonatomic, copy) NSMutableAttributedString *messageListContentAttributedStr;
@property(nonatomic, copy) NSString *messageListTitle;//消息标题
@property(nonatomic, copy) NSString *messageListTimer;//消息发送时间
@property(nonatomic, copy) NSString *submessgeCode;//消息编码
@property(nonatomic, copy) NSString *orderId;//订单id
@property(nonatomic, copy) NSString *moderType;//消息类型
@property(nonatomic, copy) NSString *messageListMessageBody;//消息体
@property(nonatomic, copy) NSString *pageUrl;//显示网址
@property(nonatomic, assign)BOOL isShowPage;//是否有html5显示
@property(nonatomic,assign)BOOL isShowAllContent;//是否展示全部
@property(nonatomic, copy) NSString*ID;//消息ID
@property(nonatomic, copy) NSString*readStatus;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
