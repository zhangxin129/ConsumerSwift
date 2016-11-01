//
//  GYHDChatUserInfoModel.h
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDChatUserInfoModel : NSObject
/**名字*/
@property(nonatomic, copy)NSString *nameString;
/**头像*/
@property(nonatomic, copy)NSString *iconString;
/**聊天完整账号*/
@property(nonatomic, copy)NSString *accountID;
/**聊天custID*/
@property(nonatomic, copy)NSString *custID;
/**消费者 c 企业 e*/
@property(nonatomic, copy)NSString *userState;
/**客服会话id*/
@property(nonatomic, copy)NSString *sessionid;
@end
