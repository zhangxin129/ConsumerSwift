//
//  GYHDFriendModel.h
//  HSConsumer
//
//  Created by shiang on 16/1/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDFriendModel : NSObject
/**账号*/
@property (nonatomic, copy, readonly) NSString* FriendAccountID;
/**聊天账号*/
@property (nonatomic, copy, readonly) NSString* FriendCustID;
/**头像*/
@property (nonatomic, copy, readonly) NSString* FriendIconUrl;
/**昵称*/
@property (nonatomic, copy, readonly) NSString* FriendNickName;
/**签名*/
@property (nonatomic, copy, readonly) NSString* FriendSignature;
/**分组ID*/
@property (nonatomic, copy, readonly) NSString* friendTeamID;
/**好友申请状态*/
@property (nonatomic, copy) NSString* friendApplicationStatus;
/**申请点击统计*/
@property (nonatomic, assign) NSInteger friendApplicationSelectCount;
@property(nonatomic, copy, readonly)NSString *reqInfoString;
+ (instancetype)friendModelWithDictionary:(NSDictionary*)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
