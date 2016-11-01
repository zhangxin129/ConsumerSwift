//
//  GYHSCusResManHttpTool.h
//  HSCompanyPad
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSCusResManHttpTool : NSObject

+ (void)getResourceStatistics:(HTTPSuccess)success failure:(HTTPFailure)failure; //资源管理 关联消费者统计 (服务公司与托管企业)

+ (void)getResourceListWithBeginCard:(NSString *)beginCard EndCard:(NSString *)endCard CardStatus:(NSString *)cardStatus AuthStatus:(NSString *)authStatus CurPage:(NSString *)curPage PageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)failure; //消费者资源列表

@end
