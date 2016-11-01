//
//  GYNetRequest.h
//  Pods
//
//  Created by zhangqy on 16/3/14.
//
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

// Set to 1 to enable debug logging
#if 0
#define GYNetDebugLog(...) NSLog(__VA_ARGS__)
#else
#define GYNetDebugLog(...)
#endif

typedef NS_ENUM(NSUInteger, GYNetRequestMethod) {
    GYNetRequestMethodGET = 0,
    GYNetRequestMethodPOST,
    GYNetRequestMethodPUT,
    GYNetRequestMethodDELETE
};

typedef NS_ENUM(NSUInteger, GYNetRequestSerializer) {
    GYNetRequestSerializerHTTP = 0,
    GYNetRequestSerializerJSON

};

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^GYNetRequestRespondBlock)(NSDictionary* responseObject, NSError* error);

@class GYNetRequest;
@class AFSecurityPolicy;
@protocol GYNetRequestDelegate <NSObject>

@optional

/**
 *    返回码为200，适用处不需要检查200
 *
 *    @param request        网络请求的信息
 *    @param responseObject 返回的JSON数据
 */
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject;

/**
 *    网络请求失败；后台返回非200的情况
 *
 *    @param request 网络请求的信息
 *    @param error -9000:网络不可用，会先toast提示；-9001：返回码校验非法
 */
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error;
- (void)netRequest:(GYNetRequest*)request didFinishDownloadFile:(NSString*)filePath;
- (void)netRequest:(GYNetRequest*)request didMakingProgress:(NSProgress*)progress;
@end

@interface GYNetRequest : NSObject

#pragma mark - public attribute
// 请求的tag值，用于根据tag值区分不同的请求
@property (nonatomic, assign) NSInteger tag;
// 设置请求的超时时间，默认15秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

// 缓存超时时间，只对GET请求；单位：秒；默认为0不适用缓存，当大于0时在该时间内的请求适用缓存，不再从后台获取
@property (nonatomic, assign) NSInteger cacheTimeInSeconds;

// 检查网络是否可用
@property (nonatomic, assign, readonly) BOOL networkReachable;

// 网络不可用时是否toast错误信息，默认显示
@property (nonatomic, assign) BOOL noShowErrorMsg;

#pragma mark - private attribute
@property (nonatomic, weak, readonly) id<GYNetRequestDelegate> delegate;
@property (nonatomic, copy) NSString* baseURL;
@property (nonatomic, copy, readonly) NSString* URLString;
@property (nonatomic, copy, readonly) NSDictionary* parameters;

@property (nonatomic, assign, readonly) GYNetRequestMethod requestMethod;
@property (nonatomic, assign, readonly) GYNetRequestSerializer requestSerializer;
@property (nonatomic, strong) AFSecurityPolicy* securityPolicy;
@property (nonatomic, copy, readonly) AFConstructingBlock constructingBlock;
@property (nonatomic, copy, readonly) GYNetRequestRespondBlock respondBlock;

@property (nonatomic, copy, readonly) NSString* downloadFilePath;
@property (nonatomic, assign, readonly) NSUInteger requestId;
@property (nonatomic, weak) NSURLSessionTask* sessionTask;
@property (nonatomic, strong) NSDictionary* responseObject;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, weak) id data;
@property (nonatomic, assign) NSUInteger totalPage;
@property (nonatomic, weak) NSString* msg;
@property (nonatomic, assign) NSInteger retCode;
@property (nonatomic, weak) id rows;
@property (nonatomic, strong) NSError* netError;
@property (nonatomic, strong, readonly) NSMutableDictionary* HTTPHeaderFieldConfig;

#pragma mark - public methods
// block 已经出来不需要弱引用
- (instancetype)initWithBlock:(NSString*)URLString
                   parameters:(NSDictionary*)parameters
                requestMethod:(GYNetRequestMethod)requestMethod
            requestSerializer:(GYNetRequestSerializer)requestSerializer
                 respondBlock:(GYNetRequestRespondBlock)respondBlock;

- (instancetype)initWithDelegate:(id<GYNetRequestDelegate>)delegate
                       URLString:(NSString*)URLString
                      parameters:(NSDictionary*)parameters
                   requestMethod:(GYNetRequestMethod)requestMethod
               requestSerializer:(GYNetRequestSerializer)requestSerializer;

- (instancetype)initWithDelegate:(id<GYNetRequestDelegate>)delegate
                         baseURL:(NSString*)baseURL
                       URLString:(NSString*)URLString
                      parameters:(NSDictionary*)parameters
                   requestMethod:(GYNetRequestMethod)requestMethod
               requestSerializer:(GYNetRequestSerializer)requestSerializer;

- (instancetype)initWithUploadDelegate:(id<GYNetRequestDelegate>)delegate
                               baseURL:(NSString*)baseURL
                             URLString:(NSString*)URLString
                            parameters:(NSDictionary*)parameters
                     constructingBlock:(AFConstructingBlock)constructingBlock;

- (instancetype)initWithDownloadDelegate:(id<GYNetRequestDelegate>)delegate
                                 baseURL:(NSString*)baseURL
                               URLString:(NSString*)URLString
                        downloadFilePath:(NSString*)downloadFilePath;

- (void)start;

- (void)cancel;

- (void)setValue:(NSString*)value forHTTPHeaderField:(NSString*)field;

// 请求头通用参数设置
- (void)commonParams:(NSDictionary*)paramDic;

@end
