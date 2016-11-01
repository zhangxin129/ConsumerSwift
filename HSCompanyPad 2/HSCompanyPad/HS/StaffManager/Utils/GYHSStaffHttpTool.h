//
//  GYHSStaffHttpTool.h
//
//  Created by apple on 16/8/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSStaffHttpTool : NSObject

/**
 *  查询操作员列表
 *
 *  @param entCustId   企业客户号
 */
+ (void)getOperatorListWithEntCustId:(NSString*)entCustId success:(HTTPSuccess)success failure:(HTTPFailure)failure;

+ (void)getSalerShopListWithVShopId:(NSString*)vShopId success:(HTTPSuccess)success failure:(HTTPFailure)failure;

/**
 *  获取角色列表
 */
+ (void)getRoleList:(HTTPSuccess)success
            failure:(HTTPFailure)failure;


/**
 *  新增操作员
 */
+ (void)addOperatorUserName:(NSString*)userName
                   loginPwd:(NSString*)loginPwd
                   realName:(NSString*)realName
                   operDuty:(NSString*)duty
                     remark:(NSString*)remark
              accountStatus:(NSString*)accountStatus
                     mobile:(NSString*)mobile
                    success:(HTTPSuccess)success
                    failure:(HTTPFailure)failure;
/**
 *  删除操作员
 */
+ (void)deleteOperatorOperCustId:(NSString*)operCustId
                        entResNo:(NSString*)entResNo
                        userName:(NSString*)userName
                         success:(HTTPSuccess)success
                         failure:(HTTPFailure)failure;
/**
 *  修改操作员
 */
+ (void)editOperatorRealName:(NSString*)realName
                    operDuty:(NSString*)operDuty
                  operCustId:(NSString*)operCustId
                      remark:(NSString*)remark
                      mobile:(NSString*)mobile
               accountStatus:(NSString*)accountStatus
                     success:(HTTPSuccess)success
                     failure:(HTTPFailure)failure;
/**
 *  修改操作员客服功能
 */
+ (void)editOperatorCustomerServiceFunctionRealName:(NSString*)realName
                                           operDuty:(NSString*)operDuty
                                         operCustId:(NSString*)operCustId
                                             remark:(NSString*)remark
                                             mobile:(NSString*)mobile
                                      accountStatus:(NSString*)accountStatus operType:(NSString *)operType
                                            success:(HTTPSuccess)success
                                            failure:(HTTPFailure)failure;
/**
 *  管理员重置操作员登录密码
 */
+ (void)resetLoginPasswordNewLoginPwd:(NSString*)newLoginPwd
                           operCustId:(NSString*)operCustId
                             userName:(NSString*)userName
                              success:(HTTPSuccess)success
                              failure:(HTTPFailure)failure;

/**
 *  绑定角色
 */
+ (void)grantRoleWithRoleList:(NSString*)roleList operCustId:(NSString*)operCustId success:(HTTPSuccess)success
                      failure:(HTTPFailure)failure;
/**
 *  关联营业点
 */
+ (void)relationShopWithUserName:(NSString*)userName shopId:(NSString*)shopId curOperCustId:(NSString*)curOperCustId roleList:(NSString*)list success:(HTTPSuccess)success
                         failure:(HTTPFailure)failure;
/**
 *  互生卡登录绑定
 */
+ (void)bindCardLoginOperCustId:(NSString*)operCustId
                      operResNo:(NSString*)operResNo
                  adminLoginPwd:(NSString*)adminLoginPwd
                        success:(HTTPSuccess)success
                        failure:(HTTPFailure)failure;
/**
 *  互生卡登录解绑
 */
+ (void)unBindCardLoginOperCustId:(NSString*)operCustId
                         loginPwd:(NSString*)loginPwd
                          success:(HTTPSuccess)success
                          failure:(HTTPFailure)failure;
@end
                                                