//
//  GYHSMyPayYearFeeModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSMyPayYearFeeModel : JSONModel
/*!
 *    欠费总金额
 */
@property (nonatomic, copy) NSString *annualfeePrice;
/*!
 *    缴费区间-结束日期
 */
@property (nonatomic, copy) NSString *areaEndDate;
/*!
 *    缴费区间-开始日期
 */
@property (nonatomic, copy) NSString *areaStartDate;
/*!
 *    年费截止日期
 */
@property (nonatomic, copy) NSString *endDate;
/*!
 *    互生币余额
 */
@property (nonatomic, copy) NSString *hsbBalance;
/*!
 *    缴费提示日期
 */
@property (nonatomic, copy) NSString *warningDate;
/*!
 *    系统使用年费
 */
@property (nonatomic, copy) NSString *price;

@end
