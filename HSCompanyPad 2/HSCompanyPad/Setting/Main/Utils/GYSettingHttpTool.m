//
//  GYSettingHttpTool.m
//
//  Created by sqm on 16/8/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingHttpTool.h"
#import "GYNetwork.h"
@implementation GYSettingHttpTool
/**
 *  获取网上积分比例列表
 *
 *  @param success <#success description#>
 *  @param err     <#err description#>
 */
+ (void)getEntPointRateList:(HTTPSuccess)success
                    failure:(HTTPFailure)failure
{
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetEntPointRateList)
         parameter:@{ @"entResNo" : globalData.loginModel.entResNo }
           success:^(id returnValue) {
               if ([returnValue[GYNetWorkDataKey] isKindOfClass:[NSNull class]]) {
                   KExcuteBlock(success, @[])
               } else {
                   KExcuteBlock(success, returnValue[GYNetWorkDataKey])
               }
           }
           failure:^(NSError* error){
               
           }isIndicator:YES];
}

/*!
 *    修改登记积分比例
 *
 *    @param rate
 *    @param type
 *    @param success
 *    @param failure
 */
+ (void)editEntPointRateWithPointRate:(NSString*)rate pointRateType:(PointRateType)type success:(HTTPSuccess)success
                              failure:(HTTPFailure)failure
{
    rate = [rate substringToIndex:rate.length - 1];
    NSString *url = (type ==PointRateTypeSet ? GYHSSetEntPointRate:GYHSEditEntPointRate);
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(url)
          parameter:@{ @"entResNo" : globalData.loginModel.entResNo,
                       @"pointRates" : rate,
                       @"operator" : globalData.loginModel.custId }
            success:^(id returnValue) {
                if (kHTTPSuccessResponse(returnValue)) {
                    KExcuteBlock(success, returnValue)
                }
                
            }
            failure:^(NSError* error) {
                
            }
        isIndicator:YES];
}



@end
