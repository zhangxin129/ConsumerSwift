//
//  GYNetwork.h
//  HSCompanyPad
//
//  Created by User on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock) (id returnValue);
typedef void (^FailureBlock) (NSError * error);

#import "GYNetView.h"
#import <GYkit/GYNetRequest.h>
#import "GYNetAPiMacro.h"

@protocol GYNetworkReloadDelete <NSObject>

@optional
//点击了重载按钮,需要设置 [GYNetwork sharedInstance].delegate = self;
-(void)gyNetworkDidTapReloadBtn;

@end

@interface GYNetwork : NSObject

@property (nonatomic,weak) id<GYNetworkReloadDelete> delegate;


#pragma mark -单例方法
+ (instancetype)sharedInstance;


 #pragma mark- POST请求
/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字数
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      默认不显示loading动画
 */

+(void)POST: (NSString *) requestURLString

  parameter: (NSDictionary *) parameter

    success: (SuccessBlock) block

    failure: (FailureBlock) failureBlock;


/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字典
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      是否显示loading动画
 */
+(void)POST: (NSString *) requestURLString

  parameter: (NSDictionary *) parameter

    success: (SuccessBlock) block

    failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator;


/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字典
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      是否显示loading动画
 *  @param kMaskViewType    网络请求失败遮罩类型
 
 */
+(void)POST: (NSString *) requestURLString

  parameter: (NSDictionary *) parameter

    success: (SuccessBlock) block

    failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator MaskType:(kMaskViewType)type;

 #pragma mark- GET请求

/**
 *  普通get请求
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字数
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      默认不显示loading动画
 */
+(void)GET:(NSString *)requestURLString
 parameter:(NSDictionary *)parameter
   success:(SuccessBlock)block
   failure:(FailureBlock)failureBlock;

/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字典
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      是否显示loading动画
 */

+(void)GET: (NSString *) requestURLString

 parameter: (NSDictionary *) parameter

   success: (SuccessBlock) block

   failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator;

/**
 *
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字典
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      是否显示loading动画
 *  @param kMaskViewType    网络请求失败遮罩类型

 */

+(void)GET: (NSString *) requestURLString

 parameter: (NSDictionary *) parameter

   success: (SuccessBlock) block

   failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator MaskType:(kMaskViewType)type;

/**
 *  普通put请求
 *
 *  @param requestURLString 拼接路径
 *  @param parameter        参数字数
 *  @param block            网络正常回调
 *  @param failureBlock     网络请求失败回调
 *  @param isIndicator      默认不显示loading动画
 */

+(void)PUT:(NSString *)requestURLString
 parameter:(NSDictionary *)parameter
   success:(SuccessBlock)block
   failure:(FailureBlock)failureBlock;

+(void)PUT: (NSString *) requestURLString

 parameter: (NSDictionary *) parameter

   success: (SuccessBlock) block

   failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator;

+(void)PUT: (NSString *) requestURLString

 parameter: (NSDictionary *) parameter

   success: (SuccessBlock) block

   failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator MaskType:(kMaskViewType)type;

+(void)DELETE:(NSString *)requestURLString
 parameter:(NSDictionary *)parameter
   success:(SuccessBlock)block
   failure:(FailureBlock)failureBlock;

+(void)DELETE: (NSString *) requestURLString

 parameter: (NSDictionary *) parameter

   success: (SuccessBlock) block

   failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator;

+(void)DELETE: (NSString *) requestURLString

 parameter: (NSDictionary *) parameter

   success: (SuccessBlock) block

   failure: (FailureBlock) failureBlock isIndicator:(BOOL)isIndicator MaskType:(kMaskViewType)type;

//上传图片
+ (void)UPLOAD:(NSString*)url imageData:(NSData*)imageData imageName:(NSString*)name success:(SuccessBlock)success failure:(FailureBlock)err;

@end
