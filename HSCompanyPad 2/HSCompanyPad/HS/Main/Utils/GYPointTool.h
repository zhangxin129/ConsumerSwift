
//  GYPointTool.h
//  company

//  Created by Apple03 on 15-4-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  积分消费工具类

#import <Foundation/Foundation.h>
typedef void (^HTTPResult)(id responsObject, NSError* error);
typedef void (^modelResult)(id model);
typedef void (^resultBlock)(id responsObject, NSError* error);

@interface GYPointTool : NSObject
+ (instancetype)shareInstance;
- (void)reset;
#pragma mark - 初始化批次号和终端流水号Function

- (void)setBatchNoAndPosRunCode;
- (void)getBatchNoAndPosRunCode:(modelResult)result;
- (void)updateBatchNo:(NSString*)batchNO;
- (void)updatePosRunCode:(NSString*)posRunCode;
@end

#pragma mark - 卡信息模型

@interface GYCardInfoModel : NSObject
@property (nonatomic, copy) NSString* HSCardNum; // 渠道 互生号
@property (nonatomic, copy) NSString* CipherNum; // 暗码
+ (instancetype)shareInstance;
- (void)reset;

@end

#pragma mark - 批次号、终端流水号模型

@interface GYPOSBatchModel : NSObject

@property (nonatomic, copy) NSString* batchNo; // 批次号
@property (nonatomic, copy) NSString* posRunCode; // 终端流水号

+ (instancetype)shareInstance;
@end


