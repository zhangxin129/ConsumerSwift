//
//  GYHSRequestData.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSRequestData.h"
#import "GYNetRequest.h"
#import "UIDevice+YYAdd.h"
#import "GYHSConstant.h"
#import "GYHSBankListModel.h"
#import "GYHSAlternateModel.h"
#import "GYHSLoginManager.h"
#import "GYHSConstant.h"
#import "GYHSLoginModel.h"
#import "GYHSLocalInfoModel.h"
#import "GYHSProvinceModel.h"
#import "GYHSCityAddressModel.h"
#import "GYAlertView.h"
#import "NSString+GYExtension.h"
#import "GYConsumerAnimate.h"

#define kqueryBank_SaveData_Key @"kqueryBank_SaveData_Key"
#define kQueryChineseCitys_SaveData_Key @"kQueryChineseCitys_SaveData_Key"

@interface GYHSRequestData () <GYNetRequestDelegate>

@property (nonatomic, copy) GYHSRequestDataBlock bankListBlock;
@property (nonatomic, copy) GYHSRequestDataLoginBlock loginBlock;
@property (nonatomic, copy) GYHSRequestDataQueryLocalInfoBlock queryLocalInfoBlock;
@property (nonatomic, copy) GYHSRequestQueryChhineseCityBlock queryChineseCityBlock;
@property (nonatomic, copy) GYHSRequestDataSendSMSCodeBlock sendSmsCodeBlock;
@property (nonatomic, copy) GYHSRequestDataCustGlobalDataBlock custGlobalDataBlock;

@property (nonatomic, strong) NSTimer* smsTimer;
@property (nonatomic, strong) UIButton* smsButton;
@property (nonatomic, assign) NSUInteger smsTimeout;

@end

@implementation GYHSRequestData

#define kqueryBankList_Tag 100
#define ksendLoginAction_Tag 101
#define kqueryLocalInfo_Tag 102
#define kChineseCity_Tag 103
#define kquerySMSCode_Tag 104
#define kCustGlobalData_Tag 105

#pragma mark - public methods
- (void)dealloc
{
}

- (void)clearSaveData
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:kqueryBank_SaveData_Key];
    [userDefault removeObjectForKey:kQueryChineseCitys_SaveData_Key];
    [userDefault synchronize];
}

- (void)clearTimer
{
    if (self.smsTimer) {
        [self.smsTimer invalidate];
        self.smsTimer = nil;
    }
}

- (void)queryBankList:(GYHSRequestDataBlock)resultBlock
{

    self.bankListBlock = resultBlock;

    if (self.bankListBlock) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kqueryBank_SaveData_Key];
        NSArray* resultArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        if (![GYUtils checkArrayInvalid:resultArray]) {
            self.bankListBlock(resultArray);
            return;
        }
    }

    NSDictionary* paramDic = @{};

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlQueryBank parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kqueryBankList_Tag;
    [request start];
}

- (void)sendLoginAction:(NSString*)userName pwd:(NSString*)pwd isCardUser:(BOOL)isCardUser loginBlokc:(GYHSRequestDataLoginBlock)loginBlock
{
    self.loginBlock = loginBlock;
    NSString* tmpPwd = [pwd md5String16:userName];

    NSDictionary* paramDic = @{(isCardUser ? @"resNo" : @"mobile") : kSaftToNSString(userName),
        @"loginPwd" : kSaftToNSString(tmpPwd),
        @"channelType" : @"4",
        @"versionNumber" : kAppVersion,
        @"loginIP" : [[GYHSLoginManager shareInstance] userDeviceIP] };

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlCustomerLogin
                                                        parameters:paramDic
                                                     requestMethod:GYNetRequestMethodPOST
                                                 requestSerializer:GYNetRequestSerializerJSON];
    request.tag = ksendLoginAction_Tag;
    request.animateObj = [[GYConsumerAnimate alloc] init];
    [request start];
}

- (void)queryLocalInfo:(GYHSRequestDataQueryLocalInfoBlock)localInfoBlock
{
    self.queryLocalInfoBlock = localInfoBlock;

    GYNetRequest* localInfoRequest = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlGetLocalInfo parameters:@{} requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    localInfoRequest.tag = kqueryLocalInfo_Tag;
    [localInfoRequest start];
}

- (void)queryChineseCitys:(NSString*)countryNo chineseCityBlock:(GYHSRequestQueryChhineseCityBlock)chineseCityBlock
{
    self.queryChineseCityBlock = chineseCityBlock;

    if (self.queryChineseCityBlock) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kQueryChineseCitys_SaveData_Key];
        NSArray* resultArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        if (![GYUtils checkArrayInvalid:resultArray]) {
            self.queryChineseCityBlock(resultArray);
            return;
        }
    }

    NSDictionary* paramDic = @{ @"countryNo" : kSaftToNSString(countryNo) };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlAllCity parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kChineseCity_Tag;
    [request start];
}

- (void)privinceAndCityInfo:(NSString*)provinceNo
                     cityNo:(NSString*)cityNo
                resultBlock:(GYHSRequestQueryProvinceCityBlock)resultBlock
{

    GYHSLocalInfoModel* model = [[GYHSLoginManager shareInstance] localInfoModel];
    if ([GYUtils checkStringInvalid:model.countryNo]) {
        WS(weakSelf)
            [self queryLocalInfo:^(GYHSLocalInfoModel* localModel) {
            
            if ([GYUtils checkObjectInvalid:localModel]) {
                DDLogDebug(@"The localModel is nil.");
                if (resultBlock) {
                    resultBlock(nil);
                }
                return;
            }
            
            [[GYHSLoginManager shareInstance] saveLocalInfoModel:localModel];
            [weakSelf queryCityInfo:localModel.countryNo provinceNo:provinceNo cityNo:cityNo resultBlock:resultBlock];
            }];
    }
    else {
        [self queryCityInfo:model.countryNo provinceNo:provinceNo cityNo:cityNo resultBlock:resultBlock];
    }
}

- (void)sendSMSCode:(NSString*)url
           paramDic:(NSDictionary*)paramDic
             button:(UIButton*)button
            timeOut:(NSInteger)timeout
        resultBLock:(GYHSRequestDataSendSMSCodeBlock)resultBlock
{
    self.smsButton = button;
    self.smsTimeout = timeout;
    self.sendSmsCodeBlock = resultBlock;

    self.smsButton.enabled = NO;

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:url parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = kquerySMSCode_Tag;
    [request start];
}

- (void)queryCustGlobalData:(GYHSRequestDataCustGlobalDataBlock)custGlobalDataBlock
{
    self.custGlobalDataBlock = custGlobalDataBlock;

    GYNetRequest* localInfoRequest = [[GYNetRequest alloc] initWithDelegate:self URLString:kCustGlobalDataUrlString parameters:@{} requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    localInfoRequest.tag = kCustGlobalData_Tag;
    [localInfoRequest start];
}

- (void)checkVersionUpdate:(void (^)(NSString* updateLevel))updateBlock
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kCheckVersionUpdateURL parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (error) {
            DDLogDebug(@"Failed to get data check version, code:%ld, errorMsg:%@", [error code], [error localizedDescription]);
            return;
        }
        
        DDLogDebug(@"%s, Receive Data:%@", __FUNCTION__, responseObject);
        NSDictionary *serverDic = responseObject[@"data"];
        NSString *updateLevel = @"0";
        
        if (![GYUtils checkDictionaryInvalid:serverDic]) {
            updateLevel = [NSString stringWithFormat:@"%@", [serverDic valueForKey:@"tipUpdateType"]];
        }
        
        if ([GYUtils checkStringInvalid:updateLevel]) {
            updateLevel = @"0";
            DDLogDebug(@"The updateLevel:%@ is invalid.", updateLevel);
        }
        
        if (updateBlock) {
            updateBlock(updateLevel);
        }
    }];

    request.noShowErrorMsg = YES;
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"responseObject:%@", responseObject);

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        DDLogDebug(@"This responseObject is invalid.");
        [self executeBlockWithFailed];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];

    if (netRequest.tag == kqueryBankList_Tag) {
        [self parseBankList:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == ksendLoginAction_Tag) {
        [self parseLoginResult:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kqueryLocalInfo_Tag) {
        [self parseLocalInfoResult:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kChineseCity_Tag) {
        [self parseChineseCityResult:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kquerySMSCode_Tag) {
        [self parseSMSCode:returnCode responseObject:responseObject];
    }
    else if (netRequest.tag == kCustGlobalData_Tag) {
        [self parseCustGlobalData:returnCode responseObject:responseObject];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"Error:%@", [error localizedDescription]);

    if (netRequest.tag == ksendLoginAction_Tag) {
        NSString* msg = [self showLoginErrorMsg:netRequest.responseObject];
        if (![GYUtils checkStringInvalid:msg]) {
            [GYAlertView showMessage:msg];
            [self executeBlockWithFailed];
            return;
        }
    }

    [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
        [self executeBlockWithFailed];
    }];
}

#pragma mark - private methods
- (void)parseBankList:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [self executeBlockWithFailed];
        return;
    }

    NSArray* serverAry = responseObject[@"data"];
    if ([GYUtils checkArrayInvalid:serverAry]) {
        DDLogDebug(@"The serverDic is nil.");
        return;
    }

    NSMutableArray* resultArray = [NSMutableArray array];
    for (NSDictionary* tempDic in serverAry) {

        if ([GYUtils checkDictionaryInvalid:tempDic]) {
            continue;
        }

        GYHSBankListModel* model = [[GYHSBankListModel alloc] initWithDictionary:tempDic error:nil];
        [resultArray addObject:model];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:resultArray];
        [userDefault setObject:data forKey:kqueryBank_SaveData_Key];
        [userDefault synchronize];
    });

    if (self.bankListBlock) {
        self.bankListBlock(resultArray);
    }
}

- (void)parseLoginResult:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        NSString* msg = [self showLoginErrorMsg:responseObject];
        if ([GYUtils checkStringInvalid:msg]) {
            msg = kErrorMsg;
        }

        [GYAlertView showMessage:msg];

        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [self executeBlockWithFailed];
        return;
    }

    if (self.loginBlock) {
        GYHSLoginModel* module = [[GYHSLoginModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
        self.loginBlock(module);
        self.loginBlock = nil;
    }
}

- (void)parseLocalInfoResult:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [self executeBlockWithFailed];
        return;
    }

    if (self.queryLocalInfoBlock) {
        GYHSLocalInfoModel* localInfoModel = [[GYHSLocalInfoModel alloc] initWithDictionary:responseObject[@"data"] error:nil];

        if (self.queryLocalInfoBlock) {
            self.queryLocalInfoBlock(localInfoModel);
            self.queryLocalInfoBlock = nil;
        }
    }
}

- (void)parseChineseCityResult:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [self executeBlockWithFailed];
        return;
    }

    NSArray* serverAry = responseObject[@"data"];
    if ([GYUtils checkArrayInvalid:serverAry]) {
        DDLogDebug(@"The serverDic is nil.");
        [self executeBlockWithFailed];
        return;
    }

    NSMutableArray* resultArray = [NSMutableArray array];
    for (NSDictionary* tempDic in serverAry) {

        if ([GYUtils checkDictionaryInvalid:tempDic]) {
            continue;
        }

        NSMutableArray* cityArray = [NSMutableArray array];
        for (NSDictionary* dic in tempDic[@"citys"]) {
            GYHSCityAddressModel* cityModel = [[GYHSCityAddressModel alloc] initWithDictionary:dic error:nil];
            [cityArray addObject:cityModel];
        }

        GYHSProvinceModel* privinceModel = [[GYHSProvinceModel alloc] initWithDictionary:tempDic[@"province"] error:nil];
        [resultArray addObject:@{ @"province" : privinceModel,
            @"citys" : cityArray }];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:resultArray];
        [userDefault setObject:data forKey:kQueryChineseCitys_SaveData_Key];
        [userDefault synchronize];
    });

    if (self.queryChineseCityBlock) {
        self.queryChineseCityBlock(resultArray);
        self.queryChineseCityBlock = nil;
    }
}

- (void)queryCityInfo:(NSString*)countryNO
           provinceNo:(NSString*)provinceNo
               cityNo:(NSString*)cityNo
          resultBlock:(GYHSRequestQueryProvinceCityBlock)resultBlock
{

    [self queryChineseCitys:countryNO chineseCityBlock:^(NSArray* resultAry) {
        if ([GYUtils checkArrayInvalid:resultAry]) {
            DDLogDebug(@"Failed to run queryChineseCitys, the resultAry is nil.");
            
            if (resultBlock) {
                resultBlock(nil);
            }
            return;
        }
 
        NSString *province = @"";
        NSString *city = @"";
        
        if (![GYUtils checkArrayInvalid:resultAry]) {
            for (NSDictionary *dic in resultAry) {
                GYHSProvinceModel *privinceMod = [dic objectForKey:@"province"];
                
                if ([provinceNo isEqualToString:privinceMod.provinceNo]) {
                    province = privinceMod.provinceName;
                    NSArray *tmpCitysAry = [dic objectForKey:@"citys"];
                    
                    for (GYHSCityAddressModel *cityIndex in tmpCitysAry) {
                        if ([cityNo isEqualToString:cityIndex.cityNo]) {
                            city = cityIndex.cityName;
                            break;
                        }
                    }
                }
                
                if (![GYUtils checkStringInvalid:city]) {
                    break;
                }
            }
        }
        
        if (resultBlock) {
            NSDictionary *restutDic = @{@"province" : province,
                                        @"city" : city};
            resultBlock(restutDic);
        }
    }];
}

- (void)parseSMSCode:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        [GYAlertView showMessage:kErrorMsg];

        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [self executeBlockWithFailed];
        return;
    }

    self.smsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeSMSTitle:) userInfo:nil repeats:YES];

    [GYUtils showMessage:kLocalized(@"GYHS_Login_Validationed_Please_Find")];
    if (self.sendSmsCodeBlock) {
        self.sendSmsCodeBlock(YES);
    }
}

- (void)changeSMSTitle:(NSTimer*)timer
{
    --self.smsTimeout;
    NSString* title = nil;
    if (self.isPhoneBand) {
        title = [NSString stringWithFormat:@"%lu秒后重发", (unsigned long)self.smsTimeout];
    }
    else {
        title = [NSString stringWithFormat:@"%lus", (unsigned long)self.smsTimeout];
    }

    if (self.smsTimeout > 0) {
        [self.smsButton setTitle:title forState:UIControlStateNormal];
    }
    else {
        if (self.isPhoneBand) {
            [self.smsButton setTitle:kLocalized(@"发送验证码") forState:UIControlStateNormal];
        }
        else {
            [self.smsButton setTitle:kLocalized(@"GYHS_Login_Get_Verification_Code") forState:UIControlStateNormal];
        }
        [self.smsTimer invalidate];
        self.smsButton.enabled = YES;
        self.smsTimer = nil;
    }
}

- (void)parseCustGlobalData:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        [GYUtils showToast:kErrorMsg];
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [self executeBlockWithFailed];
        return;
    }

    NSDictionary* serverDic = responseObject[@"data"];
    if ([GYUtils checkDictionaryInvalid:serverDic]) {
        DDLogDebug(@"The serverDic:%@ is invalid.", serverDic);
        return;
    }

    GYHSCustGlobalDataModel* custGlobalDataModel = [[GYHSCustGlobalDataModel alloc] initWithDictionary:serverDic error:nil];
    // 客户端本地保存
    custGlobalDataModel.integralTransferToHsbRate = @"1";

    if (self.custGlobalDataBlock) {
        self.custGlobalDataBlock(custGlobalDataModel);
        self.custGlobalDataBlock = nil;
    }
}

- (void)executeBlockWithFailed
{
    if (self.bankListBlock) {
        self.bankListBlock(nil);
        self.bankListBlock = nil;
    }

    if (self.loginBlock) {
        self.loginBlock(nil);
        self.loginBlock = nil;
    }

    if (self.queryLocalInfoBlock) {
        self.queryLocalInfoBlock(nil);
        self.queryLocalInfoBlock = nil;
    }

    if (self.queryChineseCityBlock) {
        self.queryChineseCityBlock(nil);
        self.queryChineseCityBlock = nil;
    }

    if (self.sendSmsCodeBlock) {
        self.smsButton.enabled = YES;
        self.sendSmsCodeBlock(NO);
        self.sendSmsCodeBlock = nil;
    }

    if (self.custGlobalDataBlock) {
        self.custGlobalDataBlock(nil);
        self.custGlobalDataBlock = nil;
    }
}

- (NSString*)showLoginErrorMsg:(NSDictionary*)responseDic
{
    NSString* msg = nil;
    NSString* retCode = kSaftToNSString(responseDic[@"retCode"]);

    if ([GYUtils checkStringInvalid:retCode]) {
        return msg;
    }

    NSArray* errorAry = @[ @"160104", @"160467", @"160108", @"160359" ];

    if ([errorAry containsObject:retCode]) {
        msg = kSaftToNSString(responseDic[@"msg"]);
    }

    return msg;
}

@end
