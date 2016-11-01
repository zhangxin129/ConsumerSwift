//
//  ViewModel.h
//  GYCompany
//
//  Created by cook on 15/9/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "JSONModel.h"

//定义返回请求数据的block类型
typedef void (^ReturnValueBlock)(id returnValue);
typedef void (^ErrorCodeBlock)(id errorCode);
typedef void (^FailureBlock)();

@interface ViewModel : NSObject

@property (nonatomic, copy) ReturnValueBlock returnBlock;
@property (nonatomic, copy) ErrorCodeBlock errorBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

/**
 *  设置block
 *
 *  @param returnBlock  成功回调
 *  @param errorBlock   失败回调
 *  @param failureBlock 错误回调
 */
- (void)setBlockWithReturnBlock:(ReturnValueBlock)returnBlock errorBlock:(ErrorCodeBlock)errorBlock failureBlock:(FailureBlock)failureBlock;

- (void)errorCodeWithDic:(NSDictionary*)errorDic;

- (void)netFailure;

#pragma mark - 存取模型
- (void)writeModel:(NSObject*)model toPath:(NSString*)modelName;
- (NSObject *)readFromPath:(NSString *)modelName;

@end
