//
//  GYNetwork.m
//  HSCompanyPad
//
//  Created by User on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
//#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "GYLoginEn.h"
#import "GYGIFHUD.h"
#import "GYBaseViewController.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "GYLoginHttpTool.h"
#import "GYProgressPopUpView.h"
#import "GYUploadPhotoProgressView.h"
#define kTempSelf [GYNetwork new]
#define kNetErrorTag 9999
// 为解决互动页面进入状态吗判断闪退问题 add jianglc
#define kHTTPSafeSuccessResponse(responsObject) [[NSString stringWithFormat:@"%@", responsObject[@"retCode"]] isEqualToString:@"200"]
@interface GYNetwork ()

@property (nonatomic, strong) NSMutableArray* requestArray; //请求失败类数组
@property (strong, nonatomic) NSDictionary* dicErrConfig; //错误码配置文件

@end

@implementation GYNetwork {

    SuccessBlock _successBlock;
    FailureBlock _failBlock;
}

+ (void)initialize
{
    [super initialize];
    [self startMonitoring];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - 单例
static id _instace;

//不可实现以下方法，会导致请求覆盖，无法发送多路请求
/*
+ (id)allocWithZone:(struct _NSZone*)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
        
    });
    return _instace;
}

- (id)copyWithZone:(NSZone*)zone
{
    return _instace;
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray new];
    }
    return self;
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[GYNetwork alloc] init];

    });
    return _instace;
}

+ (void)startMonitoring
{
    AFNetworkReachabilityManager* manager = [AFNetworkReachabilityManager sharedManager];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DDLogCInfo(@"未识别的网络");
                globalData.isOnNet = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DDLogCInfo(@"没有网络!!");
                globalData.isOnNet = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DDLogCInfo(@"2G,3G,4G...的网络");
                globalData.isOnNet = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DDLogCInfo(@"wifi的网络");
                globalData.isOnNet = YES;
                
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

#pragma mark -Request Method
/**
 *  普通get请求
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字数
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      默认不显示loading动画
 */
+ (void)GET:(NSString*)requestURLString
    parameter:(NSDictionary*)parameter
      success:(SuccessBlock)block
      failure:(FailureBlock)failureBlock
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP parameter:parameter success:block failure:failureBlock isIndicator:NO MaskType:kMaskViewType_None];
}

/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字典
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      是否显示loading动画
 */

+ (void)GET:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:kMaskViewType_None];
}

+ (void)GET:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
       MaskType:(kMaskViewType)type
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:type];
}

/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字数
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      默认不显示loading动画
 */

+ (void)POST:(NSString*)requestURLString

    parameter:(NSDictionary*)parameter

      success:(SuccessBlock)block

      failure:(FailureBlock)failureBlock
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:NO MaskType:kMaskViewType_None];
}

/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字典
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      是否显示loading动画
 */
+ (void)POST:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:kMaskViewType_None];
}

+ (void)POST:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
       MaskType:(kMaskViewType)type
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:type];
}

+ (void)PUT:(NSString*)requestURLString
    parameter:(NSDictionary*)parameter
      success:(SuccessBlock)block
      failure:(FailureBlock)failureBlock
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:NO MaskType:kMaskViewType_None];
}

+ (void)PUT:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:kMaskViewType_None];
}

+ (void)PUT:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
       MaskType:(kMaskViewType)type
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:type];
}

+ (void)DELETE:(NSString*)requestURLString
     parameter:(NSDictionary*)parameter
       success:(SuccessBlock)block
       failure:(FailureBlock)failureBlock
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerHTTP parameter:parameter success:block failure:failureBlock isIndicator:NO MaskType:kMaskViewType_None];
}

+ (void)DELETE:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:kMaskViewType_None];
}

+ (void)DELETE:(NSString*)requestURLString

      parameter:(NSDictionary*)parameter

        success:(SuccessBlock)block

        failure:(FailureBlock)failureBlock
    isIndicator:(BOOL)isIndicator
       MaskType:(kMaskViewType)type
{

    [kTempSelf baseReqeuest:requestURLString RequestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON parameter:parameter success:block failure:failureBlock isIndicator:isIndicator MaskType:type];
}


//上传图片
+ (void)UPLOAD:(NSString*)url imageData:(NSData*)imageData imageName:(NSString*)name success:(SuccessBlock)success failure:(FailureBlock)err
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (globalData.loginModel.token.length > 0) {
        [manager.requestSerializer setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    }
    [GYUploadPhotoProgressView show];
    [GYUploadPhotoProgressView didProgress:0];
    
    [manager POST:url
       parameters:nil   constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
           [formData appendPartWithFileData:imageData name:@"image" fileName:name mimeType:@"image/jpeg"];
           
       }  progress:^(NSProgress* _Nonnull uploadProgress) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [GYUploadPhotoProgressView didProgress:uploadProgress.fractionCompleted];
           });
       }
          success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
              [GYUploadPhotoProgressView dismiss];
              if (kHTTPSuccessResponse(responseObject)) {
                  [GYUtils showToast:@"上传成功！"];
                  KExcuteBlock(success, responseObject);
              } else {
                  [GYUtils showToast:@"上传失败！"];
              }
              
          }
          failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
              [GYUploadPhotoProgressView dismiss];
              [GYUtils showToast:@"网络错误"];
              
          }];
}



#pragma mark - Base Request
//为什么不使用单例调用该方法，因为单例block会被置空，下次可能无法调用-by jianglincen
- (GYNetwork*)baseReqeuest:(NSString*)requestURLString RequestMethod:(GYNetRequestMethod)requestMethod requestSerializer:(GYNetRequestSerializer)requestSerializer

                 parameter:(NSDictionary*)parameter

                   success:(SuccessBlock)block

                   failure:(FailureBlock)failureBlock
               isIndicator:(BOOL)isIndicator
                  MaskType:(kMaskViewType)type
{

    _successBlock = block;
    _failBlock = failureBlock;

    __block NSString* tempRequestString = requestURLString;

    __block GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:requestURLString parameters:parameter requestMethod:requestMethod requestSerializer:requestSerializer respondBlock:^(NSDictionary* responseObject, NSError* error) {
    
        if (isIndicator) {
            [GYGIFHUD dismiss];
        }
        if (error.code==-9000) {
            //网络不可用
            DDLogInfo(@"request= %@",request);
            if (type==kMaskViewType_Deault && !globalData.isOnNet) {
                //,先加载自定义视图显示
                [self showNetErrorViewWithType:type];
            }
            if (_failBlock) {
                _failBlock(error);
                _failBlock = nil;
            }
        }
        else{
            //网络连接正常反常
            [self removeNetErrorView];
            //校验key是否失效
            if( ![self isVerifiedKeys:responseObject]) return ;
            //非200状态码，从GYErrorMsgConfig.plist匹配code弹出提示框
            if (!kHTTPSafeSuccessResponse(responseObject)) {
             NSString *showString =[self showToastWithResponseObject:responseObject RequestStr:tempRequestString];
                if (showString.length > 0) {
                    [GYUtils showToast:showString];
                }
                
            }
            if (_successBlock) {
                _successBlock(responseObject);
                _successBlock = nil;
            }
            
        }

    }];
    if (isIndicator) {
        [GYGIFHUD show];
    }
    if (globalData.loginModel.token.length > 0) {
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [request setValue:GYChannelType forHTTPHeaderField:@"channelType"];
    }

    [request start];

    return self;
}

#pragma mark - other Method
- (void)showNetErrorViewWithType:(kMaskViewType)type
{

    UIViewController* curViewController = [GYBaseViewController getCurrentVC];

    GYNetView* firstView = [curViewController.view viewWithTag:kNetErrorTag];

    if (firstView) {
        //如果之前加载过，先移除
        [firstView removeFromSuperview];
    }

    GYNetView* netView = [[GYNetView alloc] initWithMaskType:type];

    netView.tag = kNetErrorTag;

    [netView.reloadBtn addTarget:self action:@selector(reloadRequest) forControlEvents:UIControlEventTouchUpInside];

    [curViewController.view addSubview:netView];

    [netView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)removeNetErrorView
{

    //如果重复加载同一请求，需要将遮罩视图移除
    UIViewController* curViewController = [GYBaseViewController getCurrentVC];

    GYNetView* firstView = [curViewController.view viewWithTag:kNetErrorTag];

    if (firstView) {
        //如果之前加载过，先移除
        [firstView removeFromSuperview];
    }
}




/**
 *  这个方法会处理网络错误的错误提示信息  先会将不在配置文件中的先额外进行处理，之后再从配置文件中进行读取
 *
 *  @param responseObject <#responseObject description#>
 *  @param string         <#string description#>
 *
 *  @return <#return value description#>
 */
- (NSString*)showToastWithResponseObject:(NSDictionary*)responseObject RequestStr:(NSString*)string
{

    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        //非json格式返回
        return @"";
    }
    //注意此处要使用格式化字符串的方法
    NSString* codeStr = [NSString stringWithFormat:@"%@", responseObject[GYNetWorkCodeKey]];

    NSInteger code = [codeStr integerValue];
    //登录自定义提示
    if ((code == 160102 || code == 160355 || code == 160350 || code == 160101 || code == 100000 || code == 160413 || code == 160371 || code == 160457 || code == 160464) &&  [string rangeOfString:GYHSOperatorLogin].location != NSNotFound) {
        //
        return [GYNetwork loginDic][codeStr];
    }
    //登录状态码显示请求返回msg
    else if ((code == 160108 && [string rangeOfString:GYHSOperatorLogin].location != NSNotFound) || code == 16035 || code == 160104 || code == 10467) {

        return responseObject[@"msg"];
    }

    else if (code == 160146 || code == 160412 || code == 160370) {

        return kLocalized(@"登录失败,请重新登录");
    }

    else if (code == 160102 && ( [string rangeOfString:GYHSResetLoginPwdBySecurity].location != NSNotFound ||  [string rangeOfString:GYHSResetLoginPwdByMobile].location != NSNotFound)) {
        ////重置登录密码(手机方式),重置登录密码 (密保问题验证)
        return kLocalized(@"用户状态异常");
    }
    //查询消费者剩余的代兑金额,通过请求字符串判断是否是哪一类请求
    else if (code == 201 && [string rangeOfString:GYHSAccountBalanceDetail].location != NSNotFound) {
        //
        return kLocalized(@"查询每日剩余兑换互生币数量失败");
    }
    //易联支付的提示语
    else if (code == 201 && [string rangeOfString:GYCommonYiPay].location != NSNotFound) {
        //
        return kLocalized(@"提交失败");
    }else if (code == 160102 && [string rangeOfString:GYPOSCheckResNoStatus].location != NSNotFound ){
    
    return kLocalized(@"您输入的互生卡号并不存在，请核对后重新输入");
    
    }
    //消费积分需要冲正的借口不能有提示语
    else if (code == 201 && ([string rangeOfString:GYPOSBack].location != NSNotFound || [string rangeOfString:GYPOSV3Point].location != NSNotFound || [string rangeOfString:GYPOSPrePoint].location != NSNotFound || [string rangeOfString:GYPOSCancel].location != NSNotFound || [string rangeOfString:GYPOSEarnestSettle].location != NSNotFound)) {
        //
        return @"";
    }
    
    //其它无须处理的提示语
    else if (code == 201 ) {
        return kLocalized(@"服务器繁忙，请稍后重试!");
    }
    

    //    else if ((code==50086&&[string rangeOfString:@"快捷支付"].location!=NSNotFound)||(code==50086&&[string rangeOfString:@"缴纳年费"].location!=NSNotFound)){
    //        //等同于200 retcode
    //        return kLocalized(@"提交成功");
    //
    //    }此判断还是放外层较好

    //停止积分／参与积分活动的额外处理
    else if (code == 206 && [string rangeOfString:GYHSCreatePointActivity].location != NSNotFound) {
        //
        return kLocalized(@"此业务不能重复提交!");
    }
    

    else if (code == 160108 && [string rangeOfString:GYHSUpdateLoginPwd].location != NSNotFound) {
        //修改登录密码
        return kLocalized(@"原登录密码错误，请重新输入");
    }else if (   code == 160411 || code == 160467) {
    
        return responseObject[@"msg"];
    
    }else if (code == 160360) {
//    "msg" : "1,5,交易密码错误, 传入密码[bae5e3208a3c700e3db642b6631e95b9],密码密文[14c0d7bcb19157668f025265e3be730df6ea39c227307009720947aad2ef7ba2],entCustId[0603212000020160416],userType[4] userName[06032120000]"
        NSString *msg =responseObject[@"msg"];
        NSArray<NSString *> *arrMsg = [msg componentsSeparatedByString:@","];
        if (arrMsg.count > 6) {
            NSInteger count = arrMsg[1].integerValue - arrMsg.firstObject.integerValue;
            return [NSString stringWithFormat:@"交易密码验证失败，您今天还剩%ld次尝试机会",(long)count];
        }else {
        return @"交易密码验证失败";
        
        }
        
        
    
    }

    NSDictionary* errorDic = [GYNetwork sharedInstance].dicErrConfig;
    NSString* value = errorDic[codeStr];

    return value;
}

+ (NSDictionary*)loginDic
{

    return @{
        @"160102" : kLocalized(@"登录用户状态非正常或不存在"),
        @"160355" : kLocalized(@"登录失败,请重新登录"),
        @"160350" : kLocalized(@"登录企业已经注销"),
        @"160101" : kLocalized(@"登录失败,稍后登录"),
        @"100000" : kLocalized(@"卡号或密码错误"),
        @"160413" : kLocalized(@"验证码不正确"),
        @"160371" : kLocalized(@"登录失败,请重新登录"),
        @"160457" : kLocalized(@"登录失败,企业系统已关闭"),
        @"160464" : kLocalized(@"登录失败,企业系统处于长眠状态"),
    };
}

#pragma mark tap Action
//外层决定是否响应重载请求
- (void)reloadRequest
{
    if ([GYNetwork sharedInstance].delegate && [[GYNetwork sharedInstance].delegate respondsToSelector:@selector(gyNetworkDidTapReloadBtn)]) {
    
        [[GYNetwork sharedInstance].delegate gyNetworkDidTapReloadBtn];
    }
}
/**
 *  判断key是否失效
 *
 */
- (BOOL)isVerifiedKeys:(NSDictionary*)dic
{
    BOOL isVerified = YES;
    if (dic[GYNetWorkCodeKey] &&
        ([kSaftToNSString(dic[GYNetWorkCodeKey]) isEqualToString:@"210"] ||
         [kSaftToNSString(dic[GYNetWorkCodeKey]) isEqualToString:@"208"] ||
         [kSaftToNSString(dic[GYNetWorkCodeKey]) isEqualToString:@"215"] ||
         [kSaftToNSString(dic[GYNetWorkCodeKey]) isEqualToString:@"810"] )) //互商key失效
    {
        [GYLoginHttpTool relogin];
        
        return NO;
    }
       return isVerified;
}



#pragma mark - 懒加载
//根据语言环境获取错误提示字典
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

@end
