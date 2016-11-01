//
//  GYHDUserInfoDetailModel.h
//  HSConsumer
//
//  Created by shiang on 16/7/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDUserInfoDetailModel : NSObject

@property(nonatomic, copy)NSString *iconString;
@property(nonatomic, copy)NSString *nikeNameString;
@property(nonatomic, copy)NSString *huShengString;
@property(nonatomic, copy)NSString *sexString;
/**用户信息*/
@property (nonatomic, copy) NSString* userInfo;
/**用户信息标题*/
@property (nonatomic, copy) NSString* userInfoName;
@end
