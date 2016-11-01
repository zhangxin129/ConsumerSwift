//
//  GYNetRequest.m
//  Pods
//
//  Created by zhangqy on 16/3/14.
//
//

#import "GYNetRequest.h"
#import "GYNetManager.h"
#import "GYNetLogger.h"
#import <objc/runtime.h>

@implementation GYNetRequest


- (instancetype)initWithDelegate:(id<GYNetRequestDelegate>)delegate baseURL:(NSString *)baseURL URLString:(NSString *)URLString parameters:(NSDictionary *)parameters requestMethod:(GYNetRequestMethod)requestMethod requestSerializer:(GYNetRequestSerializer)requestSerializer {
    if (self = [self init]) {
        _delegate = delegate;
        if (baseURL && URLString) {
            if ([baseURL hasSuffix:@"/"]) {
                baseURL = [baseURL substringToIndex:baseURL.length-1];
            }
            if ([URLString hasPrefix:@"/"]) {
                URLString = [URLString substringFromIndex:1];
            }
        }
        _baseURL = baseURL;
        _URLString = URLString;
        _parameters = parameters;
        _requestMethod = requestMethod;
        _requestSerializer = requestSerializer;
        if (!_requestMethod) {
            _requestMethod = GYNetRequestMethodGET;
        }
        if (!_requestSerializer) {
            _requestSerializer = GYNetRequestSerializerHTTP;
        }
    }
    return self;
}

- (instancetype)initWithDelegate:(id<GYNetRequestDelegate>)delegate  URLString:(NSString *)URLString parameters:(NSDictionary *)parameters requestMethod:(GYNetRequestMethod)requestMethod requestSerializer:(GYNetRequestSerializer)requestSerializer {
    return [self initWithDelegate:delegate baseURL:nil URLString:URLString parameters:parameters requestMethod:requestMethod requestSerializer:requestSerializer];
}

- (instancetype)initWithUploadDelegate:(id<GYNetRequestDelegate>)delegate baseURL:(NSString *)baseURL URLString:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBlock:(AFConstructingBlock)constructingBlock {
    if (self = [self init]) {
        _delegate = delegate;
        _baseURL = baseURL;
        _URLString = URLString;
        _parameters = parameters;
        _constructingBlock = constructingBlock;
        _requestMethod = GYNetRequestMethodPOST;
        _requestSerializer = GYNetRequestSerializerHTTP;
    }
    return self;
}

- (instancetype)initWithDownloadDelegate:(id<GYNetRequestDelegate>)delegate baseURL:(NSString *)baseURL URLString:(NSString *)URLString downloadFilePath:(NSString *)downloadFilePath {
    if (self = [self init]) {
        _delegate = delegate;
        _baseURL = baseURL;
        _URLString = URLString;
        _downloadFilePath = downloadFilePath;
        _requestMethod = GYNetRequestMethodGET;
        _requestSerializer = GYNetRequestSerializerHTTP;
    }
    return self;
}

- (instancetype)init {
    static NSUInteger rId = 0;
    if (self = [super init]) {
        _tag = -1;
        _requestId = rId;
        rId++;
        _HTTPHeaderFieldConfig = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSString *)description {
    NSMutableString *text = [NSMutableString stringWithFormat:@"<%@> \n", [self class]];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if ([name isEqualToString:@"responseObject"]) {
            continue;
        }
        [text appendFormat:@"   [%@]: %@\n", name, [self valueForKey:name]];
    }
    [text appendFormat:@"</%@>", [self class]];
    return text;
}

- (void)start {
    [[GYNetManager sharedManager] startRequest:self];
}

- (void)cancel {
    [[GYNetManager sharedManager] cancelRequest:self];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if ([value isKindOfClass:[NSString class]] && [field isKindOfClass:[NSString class]]) {
        [_HTTPHeaderFieldConfig  setValue:value forKey:field];
    }
}

- (void)dealloc {
    [GYNetLogger printRequestDealloc:self];
}

@end
