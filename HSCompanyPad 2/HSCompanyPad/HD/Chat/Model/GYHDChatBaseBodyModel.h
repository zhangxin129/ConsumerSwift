//
//  GYHDChatBaseBodyModel.h
//
//  Created by wangbiao on 16/8/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>


@interface GYHDChatBaseBodyModel :JSONModel
@property(nonatomic, copy)NSString *msg_code;
@property(nonatomic, copy)NSString *msg_type;
@property(nonatomic, copy)NSString *sub_msg_code;
@property(nonatomic, copy)NSString *msg_icon;
@property(nonatomic, copy)NSString *msg_note;
@property(nonatomic, copy)NSString *msg_content;
- (NSString *)jsonString;
@end
                                                