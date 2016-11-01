//
//  GYHSLoginHistoryModel.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSLoginHistoryModel : NSObject <NSCoding>

// 登录用户名
@property (nonatomic, strong) NSString* userName;
// 是否持卡
@property (nonatomic, assign) BOOL holderCar;
// 用户头像
@property (nonatomic, strong) NSString* headPic;

@end
