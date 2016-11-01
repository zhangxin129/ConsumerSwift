//
//  GYHDAddFriendModel.h
//  HSConsumer
//
//  Created by shiang on 16/3/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDAddFriendModel : NSObject
/**头像*/
@property (nonatomic, copy) NSString* addHeadImageUrlString;
/**昵称*/
@property (nonatomic, copy) NSString* addNikeNameString;
/**用户状态*/
@property (nonatomic, assign) NSInteger addUserStatus;
/** 好友ID*/
@property (nonatomic, copy) NSString* addfriendID;
/**附加信息*/
@property(nonatomic,copy)NSString *addExtraMessage;
@property (nonatomic, copy) NSDictionary* addDobyDict;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
//@property(nonatomic, copy)NSString *addUserStatus;