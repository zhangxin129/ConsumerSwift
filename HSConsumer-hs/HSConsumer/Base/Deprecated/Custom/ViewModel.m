//
//  ViewModel.m
//  GYCompany
//
//  Created by cook on 15/9/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel

#pragma 接收穿过来的block
- (void)setBlockWithReturnBlock:(ReturnValueBlock)returnBlock errorBlock:(ErrorCodeBlock)errorBlock failureBlock:(FailureBlock)failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}

#pragma 对ErrorCode进行处理
- (void)errorCodeWithDic:(NSDictionary*)errorDic
{

    self.errorBlock(errorDic);
}

#pragma 对网路异常进行处理
- (void)netFailure
{
    self.failureBlock();
}

#pragma mark存模型
- (void)writeModel:(NSObject*)model toPath:(NSString*)modelName
{

    [[self class] writeModel:model toPath:modelName];
}

#pragma mark读取模型
- (NSObject*)readFromPath:(NSString*)modelName
{

    return [[self class] readFromPath:modelName];
}

#pragma mark存模型
+ (void)writeModel:(NSObject*)model toPath:(NSString*)modelName
{
    //1.获取文件路径
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* path = [docPath stringByAppendingPathComponent:modelName];

    //2.将自定义的对象保存到文件中
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}

#pragma mark读取模型
+ (NSObject*)readFromPath:(NSString*)modelName
{
    //1.获取文件路径
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* path = [docPath stringByAppendingPathComponent:modelName];

    //2.从文件中读取对象
    NSObject *onject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return onject;
}

@end
