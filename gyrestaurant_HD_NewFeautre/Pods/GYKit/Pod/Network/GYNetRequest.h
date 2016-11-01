//
//  GYNetRequest.h
//  Pods
//
//  Created by zhangqy on 16/3/14.
//
//



#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#if 1 // Set to 1 to enable data logging
#define GYNetDataLog(...) NSLog(__VA_ARGS__)
#else
#define GYNetDataLog(...)
#endif

#if 0 // Set to 1 to enable debug logging
#define GYNetDebugLog(...) NSLog(__VA_ARGS__)
#else
#define GYNetDebugLog(...)
#endif

typedef NS_ENUM (NSUInteger, GYNetRequestMethod) {
    GYNetRequestMethodGET = 0,
    GYNetRequestMethodPOST,
    GYNetRequestMethodPUT,
    GYNetRequestMethodDELETE
};

typedef NS_ENUM (NSUInteger, GYNetRequestSerializer) {
    GYNetRequestSerializerHTTP = 0,
    GYNetRequestSerializerJSON
    
};

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

@class GYNetRequest;
@class AFSecurityPolicy;
@protocol GYNetRequestDelegate <NSObject>

@optional

- (void)netRequest:(GYNetRequest *)request didFindCachedData:(NSDictionary *)cachedData;
- (void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject;
- (void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error;
- (void)netRequest:(GYNetRequest *)request didFinishDownloadFile:(NSString *)filePath;
- (void)netRequest:(GYNetRequest *)request didMakingProgress:(NSProgress *)progress;
@end


@interface GYNetRequest : NSObject

@property (nonatomic, weak, readonly) id<GYNetRequestDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *URLString;

@property (nonatomic, copy, readonly) NSDictionary *parameters;

@property (nonatomic, assign, readonly) GYNetRequestMethod requestMethod;

@property (nonatomic, assign, readonly) GYNetRequestSerializer requestSerializer;

@property (nonatomic, copy) NSString *baseURL;

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

@property (nonatomic, copy, readonly) AFConstructingBlock constructingBlock;

@property (nonatomic, copy, readonly) NSString *downloadFilePath;

@property (nonatomic, assign, readonly) NSUInteger requestId;

@property (nonatomic, weak) NSURLSessionTask *sessionTask;

@property (nonatomic, strong) NSDictionary *responseObject;

@property (nonatomic, assign) NSUInteger currentPageIndex;

@property (nonatomic, weak) id data;

@property (nonatomic, assign) NSUInteger totalPage;

@property (nonatomic, weak) NSString *msg;

@property (nonatomic, assign) NSInteger retCode;

@property (nonatomic, weak) id rows;

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSError *netError;

@property (nonatomic, strong,readonly) NSMutableDictionary *HTTPHeaderFieldConfig;

- (instancetype)initWithDelegate:(id<GYNetRequestDelegate>)delegate URLString:(NSString *)URLString parameters:(NSDictionary *)parameters requestMethod:(GYNetRequestMethod)requestMethod requestSerializer:(GYNetRequestSerializer)requestSerializer;


- (instancetype)initWithDelegate:(id<GYNetRequestDelegate>)delegate baseURL:(NSString *)baseURL URLString:(NSString *)URLString parameters:(NSDictionary *)parameters requestMethod:(GYNetRequestMethod)requestMethod requestSerializer:(GYNetRequestSerializer)requestSerializer;

- (instancetype)initWithUploadDelegate:(id<GYNetRequestDelegate>)delegate baseURL:(NSString *)baseURL URLString:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBlock:(AFConstructingBlock)constructingBlock;

- (instancetype)initWithDownloadDelegate:(id<GYNetRequestDelegate>)delegate baseURL:(NSString *)baseURL URLString:(NSString *)URLString downloadFilePath:(NSString *)downloadFilePath;



- (void)start;

- (void)cancel;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
@end



