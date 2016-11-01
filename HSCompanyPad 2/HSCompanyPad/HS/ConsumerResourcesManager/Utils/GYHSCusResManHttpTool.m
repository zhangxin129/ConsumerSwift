//
//  GYHSCusResManHttpTool.m
//  HSCompanyPad
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSCusResManHttpTool.h"
#import "GYNetwork.h"
#import "GYNetApiMacro.h"
#import "GYUtilsConst.h"
#import <MJExtension/MJExtension.h>
#import "GYUtils+companyPad.h"
#import "GYHSResourceListModel.h"

@implementation GYHSCusResManHttpTool

+ (void)getResourceStatistics:(HTTPSuccess)success failure:(HTTPFailure)failure
{
    
    NSDictionary *paramar = @{ @"hsResNo" : globalData.loginModel.entResNo };
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetResourceStatistics) parameter:paramar success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            KExcuteBlock(success,returnValue)
        }else {
            KExcuteBlock(failure,nil)
        }
    } failure:^(NSError *error) {
        
    }isIndicator:YES];
    
}
//消费者资源列表
+ (void)getResourceListWithBeginCard:(NSString *)beginCard EndCard:(NSString *)endCard CardStatus:(NSString *)cardStatus AuthStatus:(NSString *)authStatus CurPage:(NSString *)curPage PageSize:(NSString *)pageSize success:(HTTPSuccess)success failure:(HTTPFailure)failure{
    NSDictionary *parama = @{@"entResNo":globalData.loginModel.entResNo,@"beginCard":beginCard,@"endCard":endCard,@"cardStatus":cardStatus,@"authStatus":authStatus,@"curPage":curPage,@"pageSize":pageSize};
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetResourceList) parameter:parama success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            NSMutableArray *modelArrM = [NSMutableArray array];
            
            id arr = returnValue[GYNetWorkDataKey];
            if ([arr isKindOfClass:[NSNull class]]) {
                KExcuteBlock(failure,nil)
            }else if ([arr isKindOfClass:[NSArray class]]){
                NSArray *dictArr = returnValue[GYNetWorkDataKey];
                for (NSDictionary *dic in dictArr) {
                    GYHSResourceListModel *model = [GYHSResourceListModel mj_objectWithKeyValues:dic];
                    [modelArrM addObject:model];
                }
                KExcuteBlock(success,modelArrM)
            }
        }else{
            [GYUtils showToast:kErrorReturncodeMsg];
        }

    } failure:^(NSError *error) {
        
    }isIndicator:YES MaskType:kMaskViewType_Deault];
    

}

@end
