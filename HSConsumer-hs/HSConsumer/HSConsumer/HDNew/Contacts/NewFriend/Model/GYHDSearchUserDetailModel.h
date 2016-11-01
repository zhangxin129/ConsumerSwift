//
//  GYHDSearchUserDetailModel.h
//  HSConsumer
//
//  Created by wangbiao on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSearchUserDetailModel : NSObject
@property(nonatomic, copy)NSString *iconString;
@property(nonatomic, copy)NSString *nikeNameString;
@property(nonatomic, copy)NSString *huShengString;
@property(nonatomic, copy)NSString *sexString;
/**用户信息*/
@property (nonatomic, copy) NSString* userInfo;
/**用户信息标题*/
@property (nonatomic, copy) NSString* userInfoName;
@end
