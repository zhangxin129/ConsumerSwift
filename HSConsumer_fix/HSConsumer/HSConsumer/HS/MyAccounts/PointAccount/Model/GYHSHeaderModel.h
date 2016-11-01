//
//  GYHSHeaderModel.h
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSHeaderModel : NSObject
///图片
@property (nonatomic, copy) NSString* imageName;

///积分账户余数
@property (nonatomic, copy) NSString* integralName;
@property (nonatomic, copy) NSString* IntegralBalance;
///可用积分
@property (nonatomic, copy) NSString* availableName;
@property (nonatomic, copy) NSString* AvailableIntegral;
///今日积分数
@property (nonatomic, copy) NSString* todayName;
@property (nonatomic, copy) NSString* TodayIntegral;
@end
