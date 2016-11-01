//
//  GYSettingHttpTool.h
//
//  Created by sqm on 16/8/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PointRateType) {
    PointRateTypeEdit,//编辑
    PointRateTypeSet //设置
};

@interface GYSettingHttpTool : NSObject
/**
 *  获取网上积分比例列表
 *
 *  @param success 成功
 *  @param err     错误
 */
+ (void)getEntPointRateList:(HTTPSuccess)success  failure:(HTTPFailure)failure;
/**
 *  修改登记积分比例
 *
 *  @param rate
 *  @param success
 *  @param err
 */
+ (void)editEntPointRateWithPointRate:(NSString*)rate pointRateType:(PointRateType)type success:(HTTPSuccess)success
                              failure:(HTTPFailure)failure;
@end
                                                