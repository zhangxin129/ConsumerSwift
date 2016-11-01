//
//  GYHDPushMsgModel.h
//  HSCompanyPad
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDPushMsgModel : NSObject
@property(nonatomic,copy)NSString*fromid;//推送id
@property(nonatomic,copy)NSString*pushtime;//推送消息时间
@property(nonatomic,copy)NSString*toid;//推送对象
@property(nonatomic,copy)NSString*content;//推送消息内容
@property(nonatomic,copy)NSString*msgtype;//推送消息类型
@property(nonatomic,copy)NSString*msgid;//推送消息id
@end
