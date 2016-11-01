//
//  GYHSBindBankCardListDataController.h
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GYHSBindBankCardListDCBlock)(NSArray* resultAry);

@interface GYHSBindBankCardListDataController : NSObject

// 查询银行列表数据
- (void)queryBankList:(NSString*)userType
               custId:(NSString*)custId
          resultBlock:(GYHSBindBankCardListDCBlock)resultBlock;

@end
