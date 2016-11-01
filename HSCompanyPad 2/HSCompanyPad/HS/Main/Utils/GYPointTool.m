//
//  GYPointTool.m
//  company
//
//  Created by Apple03 on 15-4-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  积分消费工具类

#import "GYPointTool.h"
#import <FMDB/FMDB.h>
#import <MJExtension/MJExtension.h>
#define KMaxOrdeNum 200

static GYPointTool* pointTool = nil;
@interface GYPointTool ()
@property (nonatomic, strong) FMDatabaseQueue* dbQ;
@property (nonatomic, copy) NSString* strPOSNum;
@end

@implementation GYPointTool

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pointTool = [[super allocWithZone:NULL] init];
    });
    return pointTool;
}

- (FMDatabaseQueue*)dbQ
{
    if (_dbQ == nil) {
        NSString* strDb = @"HSMCard.sqlite";
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:strDb];
        _dbQ = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _dbQ;
}

#pragma mark - 重置
// 重置
- (void)reset
{
    self.strPOSNum = @"";
}

#pragma mark - 批次号和终端流水号 用于更新设置批次号和终端流水号

/**
 *  create BatchNoAndPosRuncode Table
 */
- (void)setBatchNoAndPosRunCode
{
    [self.dbQ inTransaction:^(FMDatabase* db, BOOL* rollback) {
        [db executeUpdate:@"create table if not exists t_batch(batchNo text ,posRunCode text)"];
        [db executeUpdate:@"delete  from t_batch"];
    }];
}

- (void)getBatchNoAndPosRunCode:(modelResult)result
{
    [self.dbQ inTransaction:^(FMDatabase* db, BOOL* rollback) {
        GYPOSBatchModel* model = nil;
        FMResultSet* rs = [db executeQuery:@"select batchNo,posRunCode from t_batch "];
        model = [GYPOSBatchModel shareInstance];
        if ([rs next]) {
            model.batchNo = [rs stringForColumn:@"batchNo"];
            model.posRunCode = [rs stringForColumn:@"posRunCode"];
        } else {
            NSDate* date = [NSDate date];
            NSString* batch = [GYUtils dateToString:date dateFormat:@"ddHHmm"];
            
            [db executeUpdate:@"insert into t_batch(batchNo,posRunCode) values(?,?)", batch, @"000001"];
            model.batchNo = batch;
            model.posRunCode = @"000001";
            DDLogCError(@"%@====%@", model.batchNo, model.posRunCode);
        }
        [rs close];
        result(model);
    }];
}

/**
 *   更新批次号 传入原批次号 连接刷卡器后更新
 *
 *  @param batchNO 批次号
 */
- (void)updateBatchNo:(NSString*)batchNO
{
    NSDate* date = [NSDate date];
    NSString* batch = [GYUtils dateToString:date dateFormat:@"ddHHmm"];
    [self.dbQ inTransaction:^(FMDatabase* db, BOOL* rollback) {
        [db executeUpdate:@"update t_batch set batchNo = ?", batch];
        GYPOSBatchModel* model = [GYPOSBatchModel shareInstance];
        FMResultSet* rs = [db executeQuery:@"select batchNo,posRunCode from t_batch "];
        if ([rs next]) {
            model.batchNo = [rs stringForColumn:@"batchNo"];
            model.posRunCode = [rs stringForColumn:@"posRunCode"];
        }
        [rs close];
    }];
}

/**
 *  更新终端流水 传入原终端流水 完成订单后更新
 *
 *  @param posRunCode 终端流水号
 */
- (void)updatePosRunCode:(NSString*)posRunCode
{
    long long llposRunCode = [posRunCode longLongValue] + 1;
    if (llposRunCode > 999999) {
        llposRunCode = 1;
    }
    NSString* newposRunCode = [NSString stringWithFormat:@"%06lld", llposRunCode];
    [self.dbQ inTransaction:^(FMDatabase* db, BOOL* rollback) {
        [db executeUpdate:@"update t_batch set posRunCode = ?", newposRunCode];
        GYPOSBatchModel* model = [GYPOSBatchModel shareInstance];
        FMResultSet* rs = [db executeQuery:@"select batchNo,posRunCode from t_batch "];
        if ([rs next]) {
            model.batchNo = [rs stringForColumn:@"batchNo"];
            model.posRunCode = [rs stringForColumn:@"posRunCode"];
        }
        [rs close];
    }];
}

@end

#pragma mark - GYCardInfoModel

@implementation GYCardInfoModel

+ (instancetype)shareInstance
{
    static GYCardInfoModel* model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[super allocWithZone:NULL] init];
        model.HSCardNum = @"";
        model.CipherNum = @"";
    });
    return model;
}
- (void)reset
{
    self.HSCardNum = @"";
    self.CipherNum = @"";
}
@end

#pragma mark - GYBatchNoAndPosRunCode
@implementation GYPOSBatchModel
+ (instancetype)shareInstance
{
    static GYPOSBatchModel* model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[super allocWithZone:NULL] init];
        model.posRunCode = @"";
        model.batchNo = @"";
    });
    return model;
}

@end





