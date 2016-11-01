//
//  GlobalData.m
//  company
//
//  Created by apple on 14-10-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GlobalData.h"
#import <MJExtension/MJExtension.h>
#import "GYLockView.h"

@implementation GlobalData {
    NSTimeInterval nowTimeInterval;
}
#pragma mark - 单例
static id _instace;

+ (id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone*)zone
{
    return _instace;
}

/**
 *  初始化
 *
 *  @return <#return value description#>
 */
- (instancetype)init
{
    if (self = [super init]) {
        [self setInitValues];
    };
    return self;
}

/**
 *  错误码配置文件
 *
 *  @return
 */
- (NSDictionary*)dicErrConfig
{
    if (_dicErrConfig)
        return _dicErrConfig;
    NSString* configFilePath = [[NSBundle mainBundle] pathForResource:@"GYErrorMsgConfig"
                                                               ofType:@"plist"];
    if (!configFilePath)
        return nil;
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    _dicErrConfig = dic[[GYUtils getAppLanguage]];
    return _dicErrConfig;
}

/**
 *  初始化参数
 */
- (void)setInitValues
{
    self.isLogined = NO;
    self.isHdLogined = NO;
    nowTimeInterval = 0;
}

#pragma mark - 重构
- (CompanyType)companyType
{

    return self.loginModel.entResType.integerValue;
}

- (CGFloat)scaleX
{

    if (kScreenHeight > 480) {
        return kScreenWidth / 320.0;
    }
    else {
        return 1.0;
    }
}

- (CGFloat)scaleY
{
    if (kScreenHeight > 480) {
        return kScreenHeight / 568.0;
    }
    else {
        return 1.0;
    }
}

- (NSTimeInterval)getTimeDifference:(BOOL)isCheck
{
    if (!isCheck) {
        return nowTimeInterval;
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.baidu.com/"]];
    NSHTTPURLResponse* response = nil;
    NSData* urlDate = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (urlDate && response.allHeaderFields) {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];
        //        [df setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss 'GMT'"];//Tue, 16 Jun 2015 08:01:20 GMT  Wed, 17 Jun 2015 02:21:51 GMT
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDate* onLinedate = [df dateFromString:response.allHeaderFields[@"Date"]];
        NSDate* devDate = [NSDate date];
        DDLogCError(@"线上时间:%@ 设备时间:%@", onLinedate, devDate);
        if (onLinedate && devDate) {
            nowTimeInterval = [onLinedate timeIntervalSince1970] - [devDate timeIntervalSince1970];
        }
        return nowTimeInterval;
    }
    return nowTimeInterval;
}


- (NSTimer *)timer
{
    if (!_timer) {
        if ([kGetNSUser(@"time") isEqualToNumber:@0]) {
            return nil;
        }
        if (kGetNSUser(@"time")) {
            _timer =  [NSTimer timerWithTimeInterval:[kGetNSUser(@"time") integerValue] target:self selector:@selector(show) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
    }
    return _timer;
}

- (void)show {

    [globalData.timer invalidate];
    globalData.timer = nil;
    
    if (!globalData.isLogined) {
        return;
    }
    
    if (globalData.isLocked) {
        
        return;
    }
    [GYLockShowTipView show];
}
@end


