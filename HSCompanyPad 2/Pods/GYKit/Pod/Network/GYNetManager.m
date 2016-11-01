//
//  GYNetManager.m
//  Pods
//
//  Created by zhangqy on 16/3/14.
//
//

#import <AFNetworking/AFNetworking.h>
#import "GYNetManager.h"
#import "GYNetCache.h"
#import "GYNetSecurity.h"
#import "GYNetValidator.h"
#import "GYNetRequest.h"
#import "GYNetLogger.h"
#import "GYKitConstant.h"

typedef void (^GYNetBeforeRequestBlock)(GYNetRequest*);
typedef void (^GYNetCacheResponseBlock)(NSDictionary*, GYNetRequest*);
typedef void (^GYNetSuccessResponseBlock)(NSURLSessionTask*, id, GYNetRequest*);
typedef void (^GYNetFailureResponseBlock)(NSURLSessionTask*, NSError*, GYNetRequest*);
typedef void (^GYNetMakeProgressBlock)(NSProgress*, GYNetRequest*);

@interface GYNetManager ()

@property (nonatomic, strong) NSMutableDictionary* requestQueue;

@property (nonatomic, copy) GYNetBeforeRequestBlock beforeRequest;

@property (nonatomic, copy) GYNetCacheResponseBlock cacheResponse;

@property (nonatomic, copy) GYNetSuccessResponseBlock successResponse;

@property (nonatomic, copy) GYNetFailureResponseBlock failureResponse;

@property (nonatomic, copy) GYNetSuccessResponseBlock finishDownload;

@property (nonatomic, copy) GYNetMakeProgressBlock progressBlock;

@property (nonatomic, strong) NSTimer* timer;

@end

@implementation GYNetManager

+ (instancetype)sharedManager
{
    static GYNetManager* _netManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netManager = [[GYNetManager alloc] init];
        _netManager.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:_netManager selector:@selector(observeRequestDelegate) userInfo:nil repeats:YES];
        [_netManager.timer setFireDate:[NSDate distantFuture]];
        _netManager.requestQueue = [[NSMutableDictionary alloc] init];
        _netManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    return _netManager;
}

- (void)startRequest:(GYNetRequest*)request
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];

    // 超时时间
    manager.requestSerializer.timeoutInterval = 15;
    if (request.timeoutInterval > 0) {
        manager.requestSerializer.timeoutInterval = request.timeoutInterval;
    }
    else if (self.timeoutInterval > 0) {
        manager.requestSerializer.timeoutInterval = self.timeoutInterval;
    }

    if (request.securityPolicy) {
        [manager setSecurityPolicy:request.securityPolicy];
    }
    else {
        [manager setSecurityPolicy:self.securityPolicy];
    }

    if (request.baseURL) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:request.baseURL]];
    }

    if (request.requestSerializer == GYNetRequestSerializerHTTP) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (request.requestSerializer == GYNetRequestSerializerJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    if (request.HTTPHeaderFieldConfig.count > 0) {
        for (NSString* key in request.HTTPHeaderFieldConfig) {
            [manager.requestSerializer setValue:request.HTTPHeaderFieldConfig[key] forHTTPHeaderField:key];
        }
    }

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString* URLString = request.URLString;
    NSDictionary* parameters = request.parameters;
    self.beforeRequest(request);
    switch (request.requestMethod) {
    case GYNetRequestMethodGET: {
        if (!request.downloadFilePath) {
            BOOL useLocalData = [self checkUseLocalData:request URLString:URLString parameters:parameters];

            if (useLocalData) {
                [GYNetCache responseObjectFromCacheURL:URLString parameters:parameters completion:^(NSDictionary* cacheDict) {
                     self.cacheResponse(cacheDict, request);
                }];
            }
            else {
                request.sessionTask = [manager GET:URLString parameters:parameters progress:^(NSProgress* _Nonnull downloadProgress) {
                    self.progressBlock(downloadProgress, request);
                } success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                    self.successResponse(task, responseObject, request);
                } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                    self.failureResponse(task, error, request);
                }];

                [self addRequest:request];
            }
        }
        else {
            NSString* filePath = request.downloadFilePath;
            NSFileManager* fileManager = [NSFileManager defaultManager];
            NSString* fileName = [filePath lastPathComponent];
            NSString* fileDirectory = [filePath stringByReplacingOccurrencesOfString:fileName withString:@""];
            if (![fileManager fileExistsAtPath:filePath]) {
                [fileManager createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSURLRequest* downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
            request.sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress* _Nonnull downloadProgress) {
                    self.progressBlock(downloadProgress, request);
            } destination:^NSURL* _Nonnull(NSURL* _Nonnull targetPath, NSURLResponse* _Nonnull response) {
                    return [NSURL fileURLWithPath:request.downloadFilePath];
            } completionHandler:^(NSURLResponse* _Nonnull response, NSURL* _Nullable filePath, NSError* _Nullable error) {
                    if (error) {
                        self.failureResponse(request.sessionTask, error, request);
                    } else {
                        self.finishDownload(request.sessionTask, filePath.absoluteString, request);
                    }
            }];

            [request.sessionTask resume];
            [self addRequest:request];
        }
    } break;
    case GYNetRequestMethodPOST: {
        if (!request.constructingBlock) {
            request.sessionTask = [manager POST:URLString parameters:parameters progress:^(NSProgress* _Nonnull uploadProgress) {
                    self.progressBlock(uploadProgress, request);
            } success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                    self.successResponse(task, responseObject, request);
            } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                    self.failureResponse(task, error, request);
            }];
        }
        else {
            request.sessionTask = [manager POST:URLString parameters:parameters constructingBodyWithBlock:request.constructingBlock progress:^(NSProgress* _Nonnull uploadProgress) {
                    self.progressBlock(uploadProgress, request);
            } success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                    self.successResponse(task, responseObject, request);
            } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                    self.failureResponse(task, error, request);
            }];
        }

        [self addRequest:request];
    } break;
    case GYNetRequestMethodPUT: {
        request.sessionTask = [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                self.successResponse(task, responseObject, request);
        } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                self.failureResponse(task, error, request);
        }];

        [self addRequest:request];
    } break;
    case GYNetRequestMethodDELETE: {
        request.sessionTask = [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
                self.successResponse(task, responseObject, request);
        } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
                self.failureResponse(task, error, request);
        }];

        [self addRequest:request];
    } break;

    default:
        break;
    }
}

- (void)cancelRequest:(GYNetRequest*)request
{
    NSURLSessionTask* task = request.sessionTask;
    if (task) {
        [task cancel];
        [GYNetLogger printCancelRequest:request];
        [self removeRequest:request];
    }
}

- (void)cancelAllRequest
{
    @synchronized(self)
    {
        for (GYNetRequest* request in _requestQueue) {

            NSURLSessionTask* task = request.sessionTask;
            if (task) {
                [task cancel];
                [GYNetLogger printCancelRequest:request];
                [self removeRequest:request];
            }
        }
    }
}

- (void)addRequest:(GYNetRequest*)request
{
    @synchronized(self)
    {
        _requestQueue[@(request.requestId)] = request;
        [GYNetLogger printAddRequest:request requestQueue:_requestQueue];
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)removeRequest:(GYNetRequest*)request
{
    @synchronized(self)
    {
        if ([_requestQueue.allValues containsObject:request]) {
            [_requestQueue removeObjectForKey:@(request.requestId)];
            [GYNetLogger printRemoveRequest:request requestQueue:_requestQueue];
        }
    }
}

- (GYNetSuccessResponseBlock)successResponse
{
    if (!_successResponse) {
        __weak typeof(self) weakSelf = self;
        _successResponse = ^(NSURLSessionTask* task, id responseObject, GYNetRequest* request) {
            id<GYNetRequestDelegate> delegate = request.delegate;
            __block GYNetRequestRespondBlock respondBlock = request.respondBlock;

#ifdef DEBUG
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            GYKitDebugLog(@"Response Header:%@", response.allHeaderFields);
#endif
            
            NSError *jError = nil;
            NSError *vError = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jError];
            [GYNetLogger printResponse:dict request:request];
            if (jError) {
                [GYNetLogger printResponseError:jError request:request];

                if (respondBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        respondBlock(nil, jError);
                        respondBlock = nil;
                    });
                }
                else {
                    if (delegate && [delegate respondsToSelector:@selector(netRequest:didFailureWithError:)]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [delegate netRequest:request didFailureWithError:jError];
                        });
                    }
                }

            } else {
                request.responseObject = dict;
                @try {
                    request.currentPageIndex = [dict[@"currentPageIndex"] integerValue];
                    request.data = dict[@"data"];
                    request.totalPage = [dict[@"totalPage"] integerValue];
                    request.msg = dict[@"msg"];
                    request.retCode = [dict[@"retCode"] integerValue];
                    request.rows = dict[@"rows"];

                    if ([request.data isKindOfClass:[NSNull class]]) {
                        request.data = nil;
                    }
                    if ([request.rows isKindOfClass:[NSNull class]]) {
                        request.rows = nil;
                    }
                }@catch (NSException *exception) {

                } @finally {

                }

                BOOL pass = [GYNetValidator verifyResponseObject:request
                                                  responseObject:dict
                                                           error:&vError];
                if (pass) {
                    
                    if (respondBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            respondBlock(dict, nil);
                            respondBlock = nil;
                        });
                    }
                    else {
                        if (delegate && [delegate respondsToSelector:@selector(netRequest:didSuccessWithData:)]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [delegate netRequest:request didSuccessWithData:dict];
                            });
                        }
                    }
                    
                    // 设置缓存时才缓存
                    if ((request.requestMethod == GYNetRequestMethodGET) &&
                        request.cacheTimeInSeconds > 0) {
                        [GYNetCache cacheResponseObject:dict URL:request.URLString parameters:request.parameters];
                    }
                    
                } else {
                    [GYNetLogger printResponseError:vError request:request];
                    
                    if (respondBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            respondBlock(dict, vError);
                            respondBlock = nil;
                        });
                    }
                    else {
                        if (delegate && [delegate respondsToSelector:@selector(netRequest:didFailureWithError:)]) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [delegate netRequest:request didFailureWithError:vError];
                            });
                        }
                    }
                }

            }
            [GYNetLogger printRequestFinished:request];
            [weakSelf removeRequest:request];

        };
    }
    return _successResponse;
}

- (GYNetFailureResponseBlock)failureResponse
{
    if (!_failureResponse) {
        __weak typeof(self) weakSelf = self;
        _failureResponse = ^(NSURLSessionTask* task, NSError* error, GYNetRequest* request) {
            request.netError = error;
            [GYNetLogger printResponseError:error request:request];
            
            id<GYNetRequestDelegate> delegate = request.delegate;
            __block GYNetRequestRespondBlock respondBlock = request.respondBlock;
            
            // 定义指定的错误码表示网络失败
            NSError *networkError = [NSError errorWithDomain:NSURLErrorDomain code:-9000
                                                    userInfo:@{ @"NSLocalizedDescription" : [NSString stringWithFormat:@"The network is not available."] }];
            
            if ([GYNetValidator checkShowErrorMsg:request error:error]) {
                [GYNetValidator showMessageNetwrokError:error];
            }
            
            if (respondBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    respondBlock(nil, networkError);
                    respondBlock = nil;
                });
            }
            else {
                if (delegate && [delegate respondsToSelector:@selector(netRequest:didFailureWithError:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate netRequest:request didFailureWithError:networkError];
                    });
                }
            }

            [GYNetLogger printRequestFailed:request];
            [weakSelf removeRequest:request];
        };
    }
    return _failureResponse;
}

- (GYNetBeforeRequestBlock)beforeRequest
{
    if (!_beforeRequest) {
        _beforeRequest = ^(GYNetRequest* request) {
            [GYNetLogger printRequest:request];
        };
    }
    return _beforeRequest;
}

- (GYNetCacheResponseBlock)cacheResponse
{
    if (!_cacheResponse) {
        _cacheResponse = ^(NSDictionary* dict, GYNetRequest* request) {
            id<GYNetRequestDelegate> delegate = request.delegate;
            __block GYNetRequestRespondBlock respondBlock = request.respondBlock;
            
            if (respondBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    respondBlock(dict, nil);
                    respondBlock = nil;
                });
            }
            else {
                if (delegate && [delegate respondsToSelector:@selector(netRequest:didSuccessWithData:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [delegate netRequest:request didSuccessWithData:dict];
                    });
                }
            }
        };
    }
    return _cacheResponse;
}

- (GYNetSuccessResponseBlock)finishDownload
{
    if (!_finishDownload) {
        __weak typeof(self) weakSelf = self;
        _finishDownload = ^(NSURLSessionTask* task, NSString* filePath, GYNetRequest* request) {
            id<GYNetRequestDelegate> delegate = request.delegate;
            if (delegate && [delegate respondsToSelector:@selector(netRequest:didFinishDownloadFile:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate netRequest:request didFinishDownloadFile:filePath];
                });

            }
            [weakSelf removeRequest:request];
        };
    }
    return _finishDownload;
}

- (GYNetMakeProgressBlock)progressBlock
{
    if (!_progressBlock) {
        _progressBlock = ^(NSProgress* progress, GYNetRequest* request) {
            id<GYNetRequestDelegate> delegate = request.delegate;
            if (delegate && [delegate respondsToSelector:@selector(netRequest:didMakingProgress:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate netRequest:request didMakingProgress:progress];
                });

            }
        };
    }
    return _progressBlock;
}

- (void)observeRequestDelegate
{
    @synchronized(self)
    {
        for (GYNetRequest* request in _requestQueue.allValues) {
            if (request.delegate == nil && request.respondBlock == nil) {

                NSURLSessionTask* task = request.sessionTask;
                if (task) {
                    [task cancel];
                    [GYNetLogger printCancelRequest:request];
                    [self removeRequest:request];
                }
            }
        }
        if (_requestQueue.count == 0) {
            [_timer setFireDate:[NSDate distantFuture]];
            [GYNetLogger printAllRequestFinished];
            return;
        }
        [GYNetLogger printRequesting];
    }
}

+ (void)uploadImage:(UIImage*)image fileName:(NSString*)fileName URL:(NSString*)URLString parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress*))uploadProgress success:(void (^)(NSURLSessionDataTask*, NSDictionary*))success failure:(void (^)(NSURLSessionDataTask*, NSError*))failure
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length/1024 > 1000) {
            data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
        }
        NSString *name = [fileName substringToIndex:[fileName rangeOfString:@"."].location];
        NSString *mimeType = [self mimeTypeForFileName:fileName];
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress* _Nonnull progress) {
        uploadProgress(progress);
    } success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        failure(task, error);
    }];
}

+ (void)uploadFileAtPath:(NSString*)filePath fileName:(NSString*)fileName URL:(NSString*)URLString parameters:(NSDictionary*)parameters progress:(void (^)(NSProgress*))uploadProgress success:(void (^)(NSURLSessionDataTask*, NSDictionary*))success failure:(void (^)(NSURLSessionDataTask*, NSError*))failure
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            return;
        }
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSString *name = [fileName substringToIndex:[fileName rangeOfString:@"."].location];
        NSString *mimeType = [self mimeTypeForFileName:fileName];
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress* _Nonnull progress) {
        uploadProgress(progress);
    } success:^(NSURLSessionDataTask* _Nonnull task, id _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
        failure(task, error);
    }];
}

+ (NSString*)mimeTypeForFileName:(NSString*)fileName
{
    if ([fileName hasSuffix:@"jpeg"] || [fileName hasSuffix:@"jpg"] || [fileName hasSuffix:@"JPEG"] || [fileName hasSuffix:@"JPG"]) {
        return @"image/jpeg";
    }
    if ([fileName hasSuffix:@"png"] || [fileName hasSuffix:@"PNG"]) {
        return @"image/png";
    }
    if ([fileName hasSuffix:@"mp3"] || [fileName hasSuffix:@"MP3"]) {
        return @"audio/mpeg";
    }
    if ([fileName hasSuffix:@"mp4"] || [fileName hasSuffix:@"MP4"]) {
        return @"video/mp4";
    }
    if ([fileName hasSuffix:@"mov"] || [fileName hasSuffix:@"MOV"]) {
        return @"video/quicktime";
    }
    return nil;
}

- (BOOL)checkUseLocalData:(GYNetRequest*)request
                URLString:(NSString*)URLString
               parameters:(NSDictionary*)parameters
{
    // 数据非法
    NSInteger cacheTime = [GYNetCache cacheFileDurationFromURL:URLString parameters:parameters];
    if (cacheTime <= 0) {
        return NO;
    }

    // 没有网络，或指定时间内
    if (!request.networkReachable || (cacheTime <= request.cacheTimeInSeconds)) {
        return YES;
    }

    return NO;
}

@end
