//
//  GYHDFriendDetailModel.h
//  HSConsumer
//
//  Created by shiang on 16/1/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDFriendDetailModel : NSObject
/**信息*/
@property (nonatomic, copy) NSString* userInfo;
/**信息名字*/
@property (nonatomic, copy) NSString* userInfoName;
//self.textLabel.text = friendDetailModel.userInfo;
//self.detailTextLabel.text = friendDetailModel.userInfoName;
@end
;

//@interface GYHDFriendDetailModel : NSObject
///**用户账号*/
//@property(nonatomic, copy, readonly)NSString *friendAccountID;
///**好友头像*/
//@property(nonatomic, copy, readonly)NSString *friendIcon;
///**好友名字*/
//@property(nonatomic, copy, readonly)NSString *friendName; //name = null;
///**好友互生卡*/
//@property(nonatomic, copy, readonly)NSString *friendHuShengCard;
///**好友昵称*/
//@property(nonatomic, copy, readonly)NSString *friendNikeName;//nickname = 06186010078;
///**好友备注*/
//@property(nonatomic, copy, readonly)NSString *friendRemark; //remark = "";
///**好友电话*/
//@property(nonatomic, copy, readonly)NSString *friendMobile;
///**好友地址*/
//@property(nonatomic, copy, readonly)NSString *friendCity;
///**好友聊天ID*/
//@property(nonatomic, copy, readonly)NSString *friendCustId;
//+ (instancetype)friendDetialModelWithDictionary:(NSDictionary *)dict;
//- (instancetype)initWithDictionary:(NSDictionary *)dict;
//@end
