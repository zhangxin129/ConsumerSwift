//
//  GYHSStaffHttpTool.m
//
//  Created by apple on 16/8/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSStaffHttpTool.h"
#import "GYNetwork.h"
#import "GYNetApiMacro.h"
#import "GYUtilsConst.h"
#import "GYHSStaffManModel.h"
#import <MJExtension/MJExtension.h>
#import "GYUtils+companyPad.h"

@implementation GYHSStaffHttpTool
/**
 *  查询操作员列表
 *
 *  @param entCustId   企业客户号
 */
+(void)getOperatorListWithEntCustId:(NSString *)entCustId success:(HTTPSuccess)success failure:(HTTPFailure)failure{

    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSOperatorList) parameter:@{ @"entCustId" : entCustId} success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            NSMutableArray *modelArrM = [NSMutableArray array];
            
            id arr = returnValue[GYNetWorkDataKey];
            if ([arr isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }else if ([arr isKindOfClass:[NSArray class]]){
                NSArray *dictArr = returnValue[GYNetWorkDataKey];
                for (NSDictionary *dic in dictArr) {
                    GYHSStaffManModel *model = [GYHSStaffManModel mj_objectWithKeyValues:dic];
                    [modelArrM addObject:model];
                }
                KExcuteBlock(success,modelArrM)
            }
        }else{
              [GYUtils showToast:kErrorReturncodeMsg];
        }
    } failure:^(NSError *error) {
        
    } isIndicator:YES MaskType:kMaskViewType_Deault];
    
}

+ (void)getSalerShopListWithVShopId:(NSString *)vShopId success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSSalerShopList) parameter:@{@"vShopId" : vShopId} success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            NSMutableArray *modelArrM = [NSMutableArray array];
            id arr = returnValue[GYNetWorkDataKey];
            if ([arr isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }else if ([arr isKindOfClass:[NSArray class]]){
                NSArray *dictArr = returnValue[GYNetWorkDataKey];
                for (NSDictionary *d in dictArr) {
                    GYRelationShopsModel *model = [GYRelationShopsModel mj_objectWithKeyValues:d];
                    [modelArrM addObject:model];
                }
                KExcuteBlock(success,modelArrM)
            }
        }else {
            [GYUtils showToast:kErrorReturncodeMsg];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}
/**
 *  获取角色列表
 */
+ (void)getRoleList:(HTTPSuccess)success
            failure:(HTTPFailure)failure
{
    if (globalData.loginModel.entCustId && globalData.loginModel.entCustId) {
        [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSRoleList) parameter:@{ @"entCustId" : globalData.loginModel.entCustId,@"custType" : globalData.loginModel.entResType} success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                NSMutableArray *modelArrM = [NSMutableArray array];
                id arr = returnValue[GYNetWorkDataKey];
                if ([arr isKindOfClass:[NSNull class]]) {
                    KExcuteBlock(failure,nil)
                }else if ([arr isKindOfClass:[NSArray class]]){
                    NSArray *dictArr = returnValue[GYNetWorkDataKey];
                    for (NSDictionary *d in dictArr) {
                        GYRoleListModel *model = [GYRoleListModel mj_objectWithKeyValues:d];
                        [modelArrM addObject:model];
                    }
                    KExcuteBlock(success,modelArrM)
                }
            }else {
                [GYUtils showToast:kErrorReturncodeMsg];
            }
        } failure:^(NSError *error) {
            
        }isIndicator:YES];

    }
}
/**
 *  新增操作员
 *
 *  @param userName      用户名（员工账号）
 *  @param loginPwd      初始登录密码
 *  @param realName      真实姓名
 *  @param duty          职务
 *  @param remark        描述
 *  @param accountStatus 0：启用，1：禁用 2:已删除
 *  @param mobile        操作员手机
 *  @param adminCustId   管理员客户号(AES加密时的秘钥)
 *  @param curUserCustId  操作员客户id
 */
+ (void)addOperatorUserName:(NSString*)userName
                   loginPwd:(NSString*)loginPwd
                   realName:(NSString*)realName
                   operDuty:(NSString*)duty
                     remark:(NSString*)remark
              accountStatus:(NSString*)accountStatus
                     mobile:(NSString*)mobile
                    success:(HTTPSuccess)success
                    failure:(HTTPFailure)failure{
    
    loginPwd = [loginPwd encodeWithKey:globalData.loginModel.custId];
    NSDictionary *paramer = @{@"entResNo" : globalData.loginModel.entResNo,
                              @"userName" : userName,
                              @"loginPwd" : loginPwd,
                              @"adminCustId" : globalData.loginModel.custId,
                              @"curUserCustId" : globalData.loginModel.custId,
                              @"realName" : realName,
                              @"operDuty" : duty,
                              @"remark" : remark,
                              @"accountStatus" : accountStatus,
                              @"mobile" : mobile};
    
    if (globalData.loginModel.custId && globalData.loginModel.entResNo) {
        [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSAddNewOperator) parameter:paramer success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success,returnValue[GYNetWorkDataKey])
                
            }else{
                [GYUtils showToast:kErrorReturncodeMsg];
                
            }
        } failure:^(NSError *error) {
            
        }isIndicator:YES];

    }
    
}

/**
 *  删除操作员
 *
 *  @param operCustId 操作员客户号
 *  @param entResNo   企业资源号
 *  @param userName   被删除4位数的账号
 *  @param adminCustId  管理员客户号
 */
+ (void)deleteOperatorOperCustId:(NSString*)operCustId
                        entResNo:(NSString*)entResNo
                        userName:(NSString*)userName
                         success:(HTTPSuccess)success
                         failure:(HTTPFailure)failure{
    
    NSDictionary *paramer = @{ @"adminCustId" : globalData.loginModel.entCustId,
                               @"entResNo" : entResNo,
                               @"userName" : userName,
                               @"operCustId" : operCustId};
    if (globalData.loginModel.entCustId) {
        [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSDeleteOperator) parameter:paramer success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                
                KExcuteBlock(success,returnValue)
                
            }else {
//                [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                    KExcuteBlock(err,nil)
//                }];
            }
        } failure:^(NSError *error) {
            
        }isIndicator:YES];

    }
    
}

/**
 *  修改操作员
 *
 *  @param realName      真实姓名
 *  @param operDuty      职务
 *  @param operCustId    操作员客户号
 *  @param remark        描述
 *  @param mobile        操作员手机
 *  @param accountStatus 0：启用，1：禁用 2:已删除
 */
+ (void)editOperatorRealName:(NSString*)realName
                    operDuty:(NSString*)operDuty
                  operCustId:(NSString*)operCustId
                      remark:(NSString*)remark
                      mobile:(NSString*)mobile
               accountStatus:(NSString*)accountStatus
                     success:(HTTPSuccess)success
                     failure:(HTTPFailure)failure{
    
    NSDictionary *paramar = @{@"adminCustId" : globalData.loginModel.custId,
                              @"curUserCustId" : globalData.loginModel.custId,
                              @"realName" : realName,
                              @"entCustId" : globalData.loginModel.entCustId,
                              @"operDuty" : operDuty,
                              @"mobile" : mobile,
                              @"operCustId" : operCustId,
                              @"accountStatus" : accountStatus,
                              @"remark" : remark
                              };
    if (globalData.loginModel.custId && globalData.loginModel.entCustId) {
        [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSEditOperator) parameter:paramar success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success,returnValue[GYNetWorkDataKey])
            
            }else{
            
                [GYUtils showToast:kErrorReturncodeMsg];
            }

        } failure:^(NSError *error) {
        
        }isIndicator:YES];
    }
}
/**
 *  修改操作员客服功能
 *
 *  @param realName      真实姓名
 *  @param operDuty      职务
 *  @param operCustId    操作员客户号
 *  @param remark        描述
 *  @param mobile        操作员手机
 *  @param accountStatus 0：启用，1：禁用 2:已删除
 */
+ (void)editOperatorCustomerServiceFunctionRealName:(NSString*)realName
                                                   operDuty:(NSString*)operDuty
                                                 operCustId:(NSString*)operCustId
                                                     remark:(NSString*)remark
                                                     mobile:(NSString*)mobile
                                              accountStatus:(NSString*)accountStatus operType:(NSString *)operType
                                                    success:(HTTPSuccess)success
                                                    failure:(HTTPFailure)failure{
    
    NSDictionary *paramar = @{@"adminCustId" : globalData.loginModel.custId,
                              @"curUserCustId" : globalData.loginModel.custId,
                              @"realName" : realName,
                              @"entCustId" : globalData.loginModel.entCustId,
                              @"operDuty" : operDuty,
                              @"mobile" : mobile,
                              @"operCustId" : operCustId,
                              @"accountStatus" : accountStatus,
                              @"remark" : remark,
                              @"operType":operType};
    if (globalData.loginModel.custId && globalData.loginModel.entCustId) {
        [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSEditOperator) parameter:paramar success:^(id returnValue) {
            if (kHTTPSuccessResponse(returnValue)) {
                KExcuteBlock(success,returnValue[GYNetWorkDataKey])
                
            }else{
                
                [GYUtils showToast:kErrorReturncodeMsg];
            }
            
        } failure:^(NSError *error) {
            
        }isIndicator:YES];
    }
}

/**
 *  管理员重置操作员登录密码
 *
 *  @param newLoginPwd 新的登录密码(需要进行AES加密)
 *  @param operCustId  操作员客户号(AES加密使用该字段为秘钥)
 *  @param userName    4位数的账号
 */
+ (void)resetLoginPasswordNewLoginPwd:(NSString*)newLoginPwd
                           operCustId:(NSString*)operCustId
                             userName:(NSString*)userName
                              success:(HTTPSuccess)success
                              failure:(HTTPFailure)failure{
    newLoginPwd = [newLoginPwd encodeWithKey:operCustId];
    
    NSDictionary *paramar = @{ @"operNo" : userName,
                               @"newLoginPwd" : newLoginPwd,
                               @"adminCustId" : operCustId};
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSResetLoginPwdByAdmin) parameter:paramar success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue)
            
        }else{
            [GYUtils showToast:kErrorReturncodeMsg];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  绑定角色
 *
 *  @param roleList   角色列表,多个角色用逗号隔开
 *  @param operCustId 被授权操作员的客户号
 */
+ (void)grantRoleWithRoleList:(NSString*)roleList operCustId:(NSString*)operCustId success:(HTTPSuccess)success
                      failure:(HTTPFailure)failure{

    NSDictionary *paramar = @{ @"curUserCustId" : globalData.loginModel.custId,
                               @"roleList" : roleList,
                               @"operCustId" : operCustId };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSGrantRole) parameter:paramar success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
            
        }else{
            
//            [GYUtils alertWithContext:kErrorRetcodeMsg buttonTitle:kLocalized(@"GYHS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];
        }
   
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}
/**
 *  关联营业点
 */
+ (void)relationShopWithUserName:(NSString*)userName shopId:(NSString*)shopId curOperCustId:(NSString*)curOperCustId roleList:(NSString*)list success:(HTTPSuccess)success
                         failure:(HTTPFailure)failure{
    
    NSDictionary *pararmar = @{ @"entResNo" : globalData.loginModel.entResNo,
                               @"roleList" : list,
                               @"userName" : userName,
                               @"entCustId" : globalData.loginModel.entCustId,
                               @"shopId" : shopId,
                               @"curOperCustId" : curOperCustId };
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSRelationShop)  parameter:pararmar success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
            
        }else{
//            [GYUtils alertWithContext:kErrorRetcodeMsg buttonTitle:kLocalized(@"GYHS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];

        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  互生卡登录绑定
 *
 *  @param operCustId    操作员编号
 *  @param operResNo     操作员互生号
 *  @param adminLoginPwd 管理员登录密码
 */
+ (void)bindCardLoginOperCustId:(NSString*)operCustId
                      operResNo:(NSString*)operResNo
                  adminLoginPwd:(NSString*)adminLoginPwd
                        success:(HTTPSuccess)success
                        failure:(HTTPFailure)failure{
    adminLoginPwd = [adminLoginPwd encodeWithKey: operCustId];
    NSDictionary *paramar = @{ @"operCustId" : operCustId,
                               @"operResNo" : operResNo,
                               @"adminCustId" : globalData.loginModel.custId,
                               @"adminLoginPwd" : adminLoginPwd,
                               @"userType" : GYUserTypeOperater };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSBindCardLogin) parameter:paramar success:^(id returnValue) {
//        if (kHTTPSuccessResponse(returnValue)) {
//            KExcuteBlock(success,returnValue)
//            
//        }else{
//            
//        }
        KExcuteBlock(success,returnValue);
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}

/**
 *  互生卡登录解绑
 *
 *  @param operCustId 操作员客户号
 *  @param loginPwd   登录密码
 */
+ (void)unBindCardLoginOperCustId:(NSString*)operCustId
                         loginPwd:(NSString*)loginPwd
                          success:(HTTPSuccess)success
                          failure:(HTTPFailure)failure{
    loginPwd = [loginPwd encodeWithKey:operCustId];
    
    NSDictionary *paramar = @{ @"operCustId" : operCustId,
                               @"loginPwd" : loginPwd,
                               @"userType" : GYUserTypeOperater,
                               @"adminCustId" : globalData.loginModel.custId };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSUnbindCardLogin) parameter:paramar success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue)
            
        }else{
//            [GYUtils alertWithContext:kErrorRetcodeMsg buttonTitle:kLocalized(@"GYHS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];
            
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];

}
@end
