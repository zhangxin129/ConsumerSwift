//
//  GYHSStoreHttpTool.m
//  HSCompanyPad
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSStoreHttpTool.h"
#import "GYNetwork.h"
#import "GYNetApiMacro.h"
#import "GYUtilsConst.h"
#import <MJExtension/MJExtension.h>
#import "GYUtils+companyPad.h"

#import "GYHSToolPurchaseModel.h"
#import "GYHSAddressListModel.h"
#import "GYAreaHttpTool.h"
#import "GYHSCardTypeModel.h"
#import "GYHSListSpecCardStyleModel.h"
#import "GYHSToolPayModel.h"
#import <YYKit/NSString+YYAdd.h>
#import "GYHSStoreQueryListModel.h"
#import <MJExtension/MJExtension.h>
#import "GYHSStoreQueryDetailModel.h"
#import "GYGIFHUD.h"

@implementation GYHSStoreHttpTool

/**
*  工具申购列表或互生卡申购
*
*  @param toolType 工具类型
*  @param custType  企业类型:分为成员企业和托管企业
*  @param entCustId  企业客户号
*/
+ (void)getApplyProgressToolType:(NSString*)toolType
                      success:(HTTPSuccess)success
                      failure:(HTTPFailure)failure
{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"custType" : globalData.loginModel.entResType,
                               @"toolType" : toolType ,
                               @"entCustId":globalData.loginModel.entCustId};
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSApplyProgress) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            
            NSMutableArray *modelArrM = [NSMutableArray array];
            
            id arr = returnValue[GYNetWorkDataKey];
            if ([arr isKindOfClass:[NSNull class]]) {
                return ;
            }else if ([arr isKindOfClass:[NSArray class]]){
                NSArray *dictArr = returnValue[GYNetWorkDataKey];
                for (NSDictionary *d in dictArr) {
                    GYHSToolPurchaseModel *model = [GYHSToolPurchaseModel mj_objectWithKeyValues:d];
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
 *  查询工具可申购数量
 *
 *  @param categoryCode 工具类别码
 *  @param entCustId    企业客户号
 */
+ (void)getQueryMayBuyToolNumCategoryCode:(NSString*)categoryCode
                                  success:(HTTPSuccess)success
                                  failure:(HTTPFailure)failure{
    
    
    NSDictionary *paramar = @{ @"entCustId" : globalData.loginModel.entCustId,
                               @"categoryCode" : categoryCode };
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryMayBuyToolNum) parameter:paramar success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}

/**
 *  收货地址列表
 *
 *  @param entCustId 企业客户号
 */
+ (void)getReciveAddr:(HTTPSuccess)success
              failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"entCustId" : globalData.loginModel.entCustId };
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSReciveAddr) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            
            NSMutableArray *modelArrM = [NSMutableArray array];
            
            id arr = returnValue[GYNetWorkDataKey];
            if ([arr isKindOfClass:[NSNull class]]) {
                return ;
            }else if ([arr isKindOfClass:[NSArray class]]){
                NSArray *dictArr = returnValue[GYNetWorkDataKey];
                for (NSDictionary *d in dictArr) {
                    GYHSAddressListModel *model = [GYHSAddressListModel mj_objectWithKeyValues:d];
                    //收货地址地区和城市
                    [GYAreaHttpTool queryCityINfoWithNo:kSaftToNSString(model.cityNo) success:^(id responsObject) {
                        model.cityModel = (GYCityAddressModel*)responsObject;
                    } failure:^{
                        
                    }];
                    
                    [modelArrM addObject:model];
                }
                
                KExcuteBlock(success,modelArrM);
            }
            
        }else{
            
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}

/**
 *  删除收货地址
 *
 *  @param addrId  地址编号
 *  @param custId 客户号
 */
+ (void)deleteAddressWithAddrId:(NSString *)addrId success:(HTTPSuccess) success failure :(HTTPFailure) failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{@"custId":globalData.loginModel.entCustId,@"addrId":addrId};
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSDeleteAddress) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey]);
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(failure,nil)
//            }];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
   
}

/**
 *  添加收货地址
 *
 *  @param receiver   收货人
 *  @param provinceNo 省
 *  @param cityNo     市
 *  @param area       区
 *  @param adress     详细地址
 *  @param postCode   邮编
 *  @param phone      手机和固话必填其一
 *  @param mobile     手机和固话必填其一
 *  @param isDefault  是否默认 1:是 0：否
 *  @param custId    客户号
 */
+ (void)postAddAddressWithReceiver:(NSString*)receiver provinceNo:(NSString*)provinceNo cityNo:(NSString*)cityNo area:(NSString*)area address:(NSString*)adress postCode:(NSString*)postCode phone:(NSString*)phone mobile:(NSString*)mobile isDefault:(NSString*)isDefault success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar =@{ @"custId" : globalData.loginModel.entCustId,
                              @"receiver" : receiver,
                              @"provinceNo" : provinceNo,
                              @"cityNo" : cityNo,
                              @"area" : area,
                              @"address" : adress,
                              @"postCode" : postCode,
                              @"phone" : phone,
                              @"mobile" : mobile,
                              @"isDefault" : isDefault };

    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSAddAdress) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey]);
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(failure,nil)
//            }];
        }
    
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  修改收货地址
 *
 *  @param addrId     地址编号
 *  @param receiver   收货人
 *  @param provinceNo 省
 *  @param cityNo     市
 *  @param area       区
 *  @param adress     详细地址
 *  @param postCode   邮编
 *  @param phone      手机和固话必填其一
 *  @param mobile     手机和固话必填其一
 *  @param isDefault  是否默认 1:是 0：否
 *  @param custId    客户号
 */
+ (void)updateAddressWithAddrId:(NSString*)addrId receiver:(NSString*)receiver provinceNo:(NSString*)provinceNo cityNo:(NSString*)cityNo area:(NSString*)area address:(NSString*)adress postCode:(NSString*)postCode phone:(NSString*)phone mobile:(NSString*)mobile isDefault:(NSString*)isDefault success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"custId" : globalData.loginModel.entCustId,
                               @"addrId" : addrId,
                               @"receiver" : receiver,
                               @"provinceNo" : provinceNo,
                               @"cityNo" : cityNo,
                               @"area" : area,
                               @"address" : adress,
                               @"postCode" : postCode,
                               @"phone" : phone,
                               @"mobile" : mobile,
                               @"isDefault" : isDefault };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSUpdateAddress) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey]);
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(failure,nil)
//            }];
        }
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  查询企业资源段
 *
 *  @param entCustId 企业客户号
 */
+ (void)getQueryEntResourceSegmentWithSuccess:(HTTPSuccess)success
                                      failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"entCustId" : globalData.loginModel.entCustId };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryEntResourceSegment) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey]);
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(failure,nil)
//            }];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  查询企业下的个性卡样列表
 *
 *  @param entResNo 企业互生号
 */
+ (void)getListConfirmCardStyle:(HTTPSuccess)success
                        failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"entResNo" : globalData.loginModel.entResNo };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSListConfirmCardStyle) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            
            NSMutableArray *modelArrM = [NSMutableArray array];
            id dic = returnValue[GYNetWorkDataKey];
            if ([dic isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }if ([dic isKindOfClass:[NSArray class]]) {
                
                NSArray *dictArr = returnValue[GYNetWorkDataKey];
                
                for (NSDictionary *d in dictArr) {
                    
                    GYHSCardTypeModel *model = [GYHSCardTypeModel mj_objectWithKeyValues:d];
                    
                    [modelArrM addObject:model];
                    
                }
                KExcuteBlock(success,modelArrM)
            }
            
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}

/**
 *  个性卡定制列表
 *
 *  @param pageSize 一页的数据大小
 *  @param curPage  当前页
 *  @param entResNo  企业互生号
 */
+ (void)getListSpecCardStylePageSize:(NSString*)pageSize
                             curPage:(NSString*)curPage
                             success:(HTTPSuccess)success
                             failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"pageSize" : pageSize,
                               @"curPage" : curPage,
                               @"entResNo" : globalData.loginModel.entResNo };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSListSpecCardStyle) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            NSMutableArray *modelArrM = [NSMutableArray array];
            id dic = returnValue[GYNetWorkDataKey];
            if ([dic isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }else if ([dic isKindOfClass:[NSDictionary class]]){
                NSArray *dictArr = dic[@"result"];
                if ([dictArr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *d in dictArr) {
                        GYHSListSpecCardStyleModel *model = [GYHSListSpecCardStyleModel mj_objectWithKeyValues:d];
                        [modelArrM addObject:model];
                    }
                    KExcuteBlock(success,modelArrM)
                }else {
                    
                    KExcuteBlock(failure,nil);
                }
            }else {
                KExcuteBlock(failure,nil)
            }
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES MaskType:kMaskViewType_Deault];
    
}

/**
 *  确认卡样
 *
 *  @param orderNo 订单号
 *  @param operCustId 操作员客户号
 */
+ (void)getConfirmCardStyleWithOrderNo:(NSString*)orderNo success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"orderNo" : orderNo,
                               @"operCustId" : globalData.loginModel.custId };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSEntConfirmCardStyle) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
   
}

/**
 *  个性卡定制 下单
 *
 *  @param cardStyleName      卡样名称
 *  @param materialMicroPic   素材卡样缩略图
 *  @param materialSourceFile 素材卡样源文件
 *  @param hsResNo 互生号
 *  @param custId 客户号
 *  @param custType 客户类型  2:成员3:托管
 *  @param custName 企业名称
 *  @param orderOperatorId 操作员
 */
+ (void)submitCardStyleOrderCardStyleName:(NSString*)cardStyleName
                                   remark:(NSString*)materialMicroPic
                       materialSourceFile:(NSString*)materialSourceFile
                                  success:(HTTPSuccess)success
                                  failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSDictionary *paramar = @{ @"cardStyleName" : cardStyleName,
                               //                                                @"materialMicroPic":materialMicroPic,
                               //                                                @"materialSourceFile":materialSourceFile,
                               @"remark" : materialMicroPic,
                               @"hsResNo" : globalData.loginModel.entResNo,
                               @"custId" : globalData.loginModel.entCustId,
                               @"custType" : globalData.loginModel.entResType,
                               @"custName" : globalData.loginModel.entCustName,
                               @"orderOperatorId" : [NSString stringWithFormat:@"%@(%@)", globalData.loginModel.userName,globalData.loginModel.operName]
                               };
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSAddCardStyleOrder) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            
            id dic = returnValue[GYNetWorkDataKey];
            
            if ([dic isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }else if ([dic isKindOfClass:[NSDictionary class]]){
                GYHSToolPayModel *model = [GYHSToolPayModel mj_objectWithKeyValues:dic];
                KExcuteBlock(success,model)
            }
        }else {
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"HS_Confirm") dismiss:^{
//                KExcuteBlock(err,nil)
//            }];
        }
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
}
/**
 *  申购互生卡或工具 提交订单
 *
 *  @param toolList       工具列表
 *  @param toolAddr       收货地址
 *  @param orderType      订单类型 103：申购工具 110：系统资源申购
 *  @param orderHsbAmount 订单互生币金额
 */
+ (void)submitToolBuyOrderToolList:(NSArray*)toolList
                              addr:(NSDictionary*)toolAddr
                         orderType:(NSString*)orderType
                    orderHsbAmount:(NSString*)orderHsbAmount
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    NSMutableDictionary* dictM = @{ @"custId" : globalData.loginModel.entCustId,
                                    @"hsResNo" : globalData.loginModel.entResNo,
                                    @"custName" : globalData.loginModel.entCustName,
                                    @"custType" : globalData.loginModel.entResType,
                                    @"orderOperatorId" : [NSString stringWithFormat:@"%@(%@)", globalData.loginModel.userName, globalData.loginModel.operName],
                                    @"toolList" : toolList,
                                    @"addr" : toolAddr,
                                    @"orderType" : orderType
                                    }.mutableCopy;
    if (orderHsbAmount) {
        [dictM addEntriesFromDictionary:@{ @"orderHsbAmount" : orderHsbAmount }];
    }
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCreateToolBuyOrder) parameter:dictM success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            
            id dic = returnValue[GYNetWorkDataKey];
            if ([dic isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }else if ([dic isKindOfClass:[NSDictionary class]]){
                GYHSToolPayModel *model = [GYHSToolPayModel mj_objectWithKeyValues:dic];
                KExcuteBlock(success,model)
            }
            
        }else {
            
//            [GYUtils alertWithContext:kErrorReturncodeMsg buttonTitle:kLocalized(@"GYHS_Confirm") dismiss:^{
//                KExcuteBlock(failure,nil)
//            }];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}

/**
 *  申购工具订单 立即支付(互生币支付)
 *
 *  @param orderNo    工具订单编号
 *  @param payChannel 支付方式 101:手机网银支付 102：快捷支付 200：互生币支付
 *  @param tradePwd   交易密码MD5 互生币支付、快捷支付必填
 *  @param userType  用户类型 1：非持卡人 2：持卡人 3：操作员 4：企业 互生币支付、快捷支付必填
 */
+ (void)HSBpayToolOrderOrderNo:(NSString*)orderNo
                    payChannel:(NSNumber*)payChannel
                      tradePwd:(NSString*)tradePwd
                       success:(HTTPSuccess)success
                       failure:(HTTPFailure)failure{
    [GYGIFHUD show];
    tradePwd = tradePwd.md5String;
    NSDictionary *paramar = @{ @"orderNo" : orderNo,
                               @"payChannel" : payChannel,
                               @"tradePwd" : tradePwd,
                               @"custId" : globalData.loginModel.entCustId,
                               @"userType" : GYUserTypeCompany };
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSPayToolOrder) parameter:paramar success:^(id returnValue) {
        [GYGIFHUD dismiss];
            KExcuteBlock(success,returnValue);
//        if (kHTTPSuccessResponse(returnValue)) {
//            KExcuteBlock(success,returnValue[GYNetWorkDataKey])
//            
//        }else {
//            [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"互生币支付失败") topColor:0 comfirmBlock:^{
//                
//            }];
//        }
        
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
  
}

/**
 *  获取所有订单列表
 *
 *  @param orderType 订单类型 100：系统使用年费 101：系统资源费 102：兑换互生币 103：申购工具 104：售后收费订单 105：个人补卡 106：重做卡收费订单107：定制卡样费用 108：缴纳积分预付款，迁移2.0旧数据需要,3.0没有此类型订
 *  @param dateFlag  时间条件：threeMonth(最近三月) oneYear(最近一年)
 *  @param curPage   当前页码
 *  @param pageSize  每页大小
 */
+ (void)queryAllOrderListOrderType:(NSString*)orderType
                          dateFlag:(NSString*)dateFlag
                           curPage:(NSString*)curPage
                          pageSize:(NSString*)pageSize
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure
{
    [GYGIFHUD show];
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSQueryAllOrderList) parameter:@{ @"orderType" : orderType,@"dateFlag" : dateFlag,@"curPage" : curPage,@"pageSize" : pageSize,@"hsCustId" : globalData.loginModel.entCustId } success:^(id returnValue) {
    [GYGIFHUD dismiss];
    if (kHTTPSuccessResponse(returnValue)) {
        
    
        NSMutableArray *modelArrM = [NSMutableArray array];
        
        id dicData = returnValue[GYNetWorkDataKey];
        if ([dicData isKindOfClass:[NSNull class]]) {
           KExcuteBlock(success,nil)
        }else if ([dicData isKindOfClass:[NSDictionary class]]){
            NSArray *dictArr = dicData[@"result"];
            if ([dictArr isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *d in dictArr) {
                    GYHSStoreQueryListModel *model = [GYHSStoreQueryListModel mj_objectWithKeyValues:d];
                    [modelArrM addObject:model];
                }
                KExcuteBlock(success,modelArrM)
            }
        
        }
    
    }
    } failure:^(NSError *error) {
                                                                                
                                }isIndicator:YES MaskType:kMaskViewType_Deault];
}


/**
 *  获取申购工具订单详情
 *
 *  @param orderNo 订单号
 */
+ (void)getToolBuyOrderInfoOrderNo:(NSString*)orderNo
                           success:(HTTPSuccess)success
                           failure:(HTTPFailure)failure
{
    [GYGIFHUD show];
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetToolBuyOrderInfo) parameter:@{ @"orderNo" : orderNo }  success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            
            id dic = returnValue[GYNetWorkDataKey];
            
            if ([dic isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }else if ([dic isKindOfClass:[NSDictionary class]]){
                GYHSStoreQueryDetailModel *model = [GYHSStoreQueryDetailModel mj_objectWithKeyValues:dic];
                KExcuteBlock(success,model)
            }
        }else {
        }

    } failure:^(NSError *error) {
        
    } isIndicator:YES];
}


/**
 *  取消订单
 *
 *  @param orderNo 订单号
 */
+ (void)cancelOrderByOrderNo:(NSString*)orderNo
                     success:(HTTPSuccess)success
                     failure:(HTTPFailure)failure {
    [GYGIFHUD show];
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSCancelToolOrder) parameter:@{@"orderNo":orderNo} success:^(id returnValue) {
        [GYGIFHUD dismiss];
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue[GYNetWorkDataKey]);
        }
    } failure:^(NSError *error) {
        KExcuteBlock(failure,nil);
    }isIndicator:YES];


}



@end
