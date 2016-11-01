//
//  GYSinglepointViewModel.h
//  GYRestaurant
//
//  Created by apple on 15/10/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewModel.h"

@interface GYSinglepointViewModel : ViewModel
/**
 *      下单
 */
- (void)PostOrderSubmitOrderWithAmountTotal:(NSString *)amountTotal
                                personCount:(NSString *)personCount
                                pointsTotal:(NSString *)pointsTotal
                                     remark:(NSString *)remark
                                      resNo:(NSString *)resNo
                                     userId:(NSString *)userId isCardCustomer:(NSString *)isCardCustomer;

/**
 *      验证互生号/手机号
 */
- (void)POSTCheckAccountIdWithAccountId:(NSString *)accountId password:(NSString *)pwd;
- (void)POSTCheckAccountIdWithAccountId:(NSString *)accountId password:(NSString *)pwd UserType:(NSString *)userType isCardCustomer:(NSString *)isCardCustomer;

@end
