//
//  GYHSBindBankCardListDataController.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBindBankCardListDataController.h"
#import "GYNetRequest.h"
#import "GYHSCardBandModel.h"
#import "GYHSConstant.h"
#import "GYHSLoginManager.h"
#import "GYHSLoginModel.h"

@interface GYHSBindBankCardListDataController () <GYNetRequestDelegate>

@property (nonatomic, strong) GYHSBindBankCardListDCBlock resultBlock;

@end

@implementation GYHSBindBankCardListDataController

#pragma mark - public methods
- (void)queryBankList:(NSString*)userType
               custId:(NSString*)custId
          resultBlock:(GYHSBindBankCardListDCBlock)resultBlock
{
    self.resultBlock = resultBlock;

    NSDictionary* paramDic = @{ @"userType" : userType,
        @"custId" : custId };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlListBindBank parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    GYHSLoginModel* loginModel = [[GYHSLoginManager shareInstance] loginModuleObject];
    [GYGIFHUD show];
    [request setValue:loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];
    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        DDLogDebug(@"The responseObject:%@ is invalid.", responseObject);
        [self executeBlock:nil];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (returnCode != 200) {
        DDLogDebug(@"The returnCode:%ld is invalid.", (long)returnCode);
        [self executeBlock:nil];
        return;
    }

    NSArray* serverAry = responseObject[@"data"];
    if ([GYUtils checkArrayInvalid:serverAry]) {
        DDLogDebug(@"The resultAry:%@ is invalid.", serverAry);
        
        [self executeBlock:nil];
        return;
    }

    NSMutableArray* resultAry = [NSMutableArray array];
    for (NSDictionary* tempDic in serverAry) {
        GYHSCardBandModel* model = [[GYHSCardBandModel alloc] initWithDictionary:tempDic error:nil];
        [resultAry addObject:model];
    }

    [self executeBlock:resultAry];
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYGIFHUD dismiss];
    WS(weakSelf)
        [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        [weakSelf executeBlock:nil];
        }];
}

#pragma mark - private methods
- (void)executeBlock:(NSArray*)array
{
    if (self.resultBlock) {
        self.resultBlock(array);
        self.resultBlock = nil;
    }
}

@end
