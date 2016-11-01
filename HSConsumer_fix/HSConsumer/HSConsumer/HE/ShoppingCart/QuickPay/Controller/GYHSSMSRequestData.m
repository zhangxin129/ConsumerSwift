//
//  GYHSSMSRequestData.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/3/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSMSRequestData.h"
#import "GYNetRequest.h"
#import "GYAlertView.h"

@interface GYHSSMSRequestData () <GYNetRequestDelegate>

@property (nonatomic, copy) GYHSSMSRequestDataBlock sendSmsCodeBlock;
@property (nonatomic, strong) NSTimer* smsTimer;
@property (nonatomic, strong) UIButton* smsButton;
@property (nonatomic, assign) NSUInteger smsTimeout;

@end

@implementation GYHSSMSRequestData

#define kquerySMSCode_Tag 100

#pragma mark - public methods
- (void)clearTimer
{
    if (self.smsTimer) {
        [self.smsButton setTitle:kLocalized(@"GYHE_SC_GetSMSCode") forState:UIControlStateNormal];
        self.smsButton.enabled = YES;
        [self.smsTimer invalidate];
        self.smsTimer = nil;
    }
}

- (void)sendSMSCode:(NSString*)url
           paramDic:(NSDictionary*)paramDic
             button:(UIButton*)button
            timeOut:(NSInteger)timeout
      requestMethod:(GYRequestMethod)requestMethod
        resultBLock:(GYHSSMSRequestDataBlock)resultBlock
{
    self.smsButton = button;
    self.smsTimeout = timeout;
    self.sendSmsCodeBlock = resultBlock;

    self.smsButton.enabled = NO;

    [GYGIFHUD show];
    GYNetRequest* request = nil;
    if (requestMethod == GYRequestMethodPOST) {
        request = [[GYNetRequest alloc] initWithDelegate:self URLString:url parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    } else {
        request = [[GYNetRequest alloc] initWithDelegate:self URLString:url parameters:paramDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    }
    [request commonParams:[GYUtils netWorkCommonParams]];
    request.tag = kquerySMSCode_Tag;
    [request start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"responseObject:%@", responseObject);
    [GYGIFHUD dismiss];

    if ([GYUtils checkDictionaryInvalid:responseObject]) {
        DDLogDebug(@"This responseObject is invalid.");
        [self executeBlockWithFailed];
        return;
    }

    NSInteger returnCode = [[responseObject objectForKey:@"retCode"] integerValue];
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        [self executeBlockWithFailed];
        return;
    }

    if (netRequest.tag == kquerySMSCode_Tag) {
        [self parseSMSCode:returnCode responseObject:responseObject];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"Error:%@", [error description]);
    [GYGIFHUD dismiss];
    [self executeBlockWithFailed];
}

#pragma mark - private methods
- (void)parseSMSCode:(NSInteger)returnCode responseObject:(NSDictionary*)responseObject
{
    if (returnCode != 200) {
        DDLogDebug(@"Failed to get server data:returnCode:%ld", (long)returnCode);
        if (self.sendSmsCodeBlock) {
            [self executeBlockWithFailed];
        }
        [GYAlertView showMessage:kLocalized(@"GYHE_SC_RequestNetDataFailed")];
        return;
    }

    self.smsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeSMSTitle:) userInfo:nil repeats:YES];
    [GYUtils showToast:kLocalized(@"GYHE_SC_SMSCodeSendSuccess")];
    if (self.sendSmsCodeBlock) {
        self.sendSmsCodeBlock(YES, responseObject);
    }
}

- (void)changeSMSTitle:(NSTimer*)timer
{
    --self.smsTimeout;
    NSString* title = [NSString stringWithFormat:@"%lus", (unsigned long)self.smsTimeout];

    if (self.smsTimeout > 0) {
        [self.smsButton setTitle:title forState:UIControlStateNormal];
    }
    else {
        [self.smsButton setTitle:kLocalized(@"GYHE_SC_GetSMSCode") forState:UIControlStateNormal];
        [self.smsTimer invalidate];
        self.smsButton.enabled = YES;
        self.smsTimer = nil;
    }
}

- (void)executeBlockWithFailed
{
    if (self.sendSmsCodeBlock) {
        self.smsButton.enabled = YES;
        self.sendSmsCodeBlock(NO, nil);
        self.sendSmsCodeBlock = nil;
    }
}

@end
