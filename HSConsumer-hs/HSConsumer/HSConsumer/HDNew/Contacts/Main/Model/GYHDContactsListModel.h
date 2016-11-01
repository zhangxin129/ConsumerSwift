//
//  GYHDContactsListModel.h
//  HSConsumer
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDContactsListModel : NSObject
@property(nonatomic,copy)NSString*iconUrl;//头像
@property(nonatomic,copy)NSString*name;//姓名
@property(nonatomic,copy)NSString*content;//内容
@property(nonatomic,copy)NSString*custid;
@property(nonatomic,copy)NSString* addState;//添加好友的状态 1:已添加 2：接受
@end
