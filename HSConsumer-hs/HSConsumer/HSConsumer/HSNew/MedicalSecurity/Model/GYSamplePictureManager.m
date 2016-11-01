//
//  GYSamplePictureManager.m
//  HSConsumer
//
//  Created by xiaoxh on 16/6/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSamplePictureManager.h"
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>
@implementation GYSamplePictureManager {
    FMDatabaseQueue* _queue;
}
+ (id)shareInstance
{
    static dispatch_once_t oncetoken;
    static GYSamplePictureManager* manager = nil;
    dispatch_once(&oncetoken, ^{
        manager = [[GYSamplePictureManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Sample_Picture.sqlite"];
        DDLogDebug(@"%@", path);
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
        [_queue inTransaction:^(FMDatabase* db, BOOL* rollback) {
            NSString *sql = @"create table if not exists t_Sample_Picture (id integer primary key autoincrement, docCode real UNIQUE, docName text,fileId text)";
            if (![db executeUpdate:sql]) {
                //DDLogDebug(@"create table error!");
            }
        }];
    }
    return self;
}

- (NSMutableArray*)selectFromDB
{
    __block NSMutableArray* arr = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase* db) {
        FMResultSet *set = [db executeQuery:@"select * from t_Sample_Picture"];
        while ([set next]) {
            GYSamplePictureModel *model = [[GYSamplePictureModel alloc] init];
            model.docName = [set stringForColumn:@"docName"];
            model.fileId = [set stringForColumn:@"fileId"];
            
            model.docCode = [NSString stringWithFormat:@"%zd", [set intForColumn:@"docCode"]];
            [arr addObject:model];
        }
    }];
    return arr;
}

- (void)insertIntoDB:(GYSamplePictureModel*)model
{
    [_queue inDatabase:^(FMDatabase* db) {
        if (![db executeUpdate:@"REPLACE INTO t_Sample_Picture(docCode,docName,fileId) values(?,?,?)", [NSNumber numberWithInteger:model.docCode.integerValue], model.docName, model.fileId]) {
            
        }
    }];
}
//
- (void)updateDBCollect:(NSString*)key
{
    [_queue inDatabase:^(FMDatabase* db) {
        if (![db executeUpdate:@"update t_Sample_Picture set where docCode=?", key]) {
            
        }
    }];
}
- (void)cleanDB
{
    [_queue inDatabase:^(FMDatabase* db) {
        if (![db executeUpdate:@"delete from t_Sample_Picture"]) {
            
        }
    }];
}

- (void)deleteDB:(NSString*)docName
{
    [_queue inDatabase:^(FMDatabase* db) {
        if (![db executeUpdate:@"delete from t_Sample_Picture where docName =?", docName]) {
            
        }
    }];
}

- (GYSamplePictureModel*)selectDecCode:(NSString*)docCode
{
    GYSamplePictureModel* model = [[GYSamplePictureModel alloc] init];

    [_queue inDatabase:^(FMDatabase* db) {
        FMResultSet *set = [db executeQuery:@"select * from t_Sample_Picture where docCode=?", docCode];
        while ([set next]) {
            
            model.docName = [set stringForColumn:@"docName"];
            model.fileId = [set stringForColumn:@"fileId"];
            
            model.docCode = [NSString stringWithFormat:@"%zd", [set intForColumn:@"docCode"]];
            
        }
    }];
    return model;
}

@end
