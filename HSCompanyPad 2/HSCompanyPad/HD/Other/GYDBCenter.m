//
//  GYDBCenter.m
//  IMXMPPPro
//
//  Created by liangzm on 15-1-15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//



#import "GYDBCenter.h"
#import <FMDB/FMDatabaseAdditions.h>
@interface GYDBCenter()
{
}
@end

@implementation GYDBCenter

//+ (FMDatabase *)getDBFromDBFullName:(NSString *)fullName
//{
//    if (![self fileIsExists:fullName]) return nil;
//    FMDatabase *db = [[FMDatabase alloc] initWithPath:fullName];
//    if (![db open])
//    {
//        DDLogCInfo(@"数据库打开失败");
//        return nil;
//    };
//    return db;
//}

+ (BOOL)fileIsExists:(NSString *)fileFullName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileFullName];
}

+ (BOOL)createFile:(NSString *)fileFullName;
{
    NSString *directoriesPath = [self getDirectoriesPathFromFileFullName:fileFullName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![self fileIsExists:directoriesPath])//判断目录是否存在 没有就创建
    {
        if (![fileManager createDirectoryAtPath:directoriesPath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error])
        {
            DDLogCInfo(@"创建目录出错:%@ directoriesPath:%@", error, directoriesPath);
            return NO;

        }else
        {
            DDLogCInfo(@"创建目录成功：%@", directoriesPath);
        }
    }
    
    //创建文件
    if (![fileManager createFileAtPath:fileFullName contents:nil attributes:nil])
    {
        DDLogCInfo(@"创建数据库出错:%@", fileFullName);
        return NO;
    }else
    {
        DDLogCInfo(@"创建数据库成功：%@", fileFullName);
    }
    return YES;
}

//从文件路径取得文件的目录
+ (NSString *)getDirectoriesPathFromFileFullName:(NSString *)fileFullName
{
    NSString *fileName = [fileFullName lastPathComponent];//文件名
    NSRange range = [fileFullName rangeOfString:fileName options:NSBackwardsSearch];
    NSString *directoriesPath = [fileFullName substringToIndex:range.location];
    return directoriesPath;
}

+ (NSString *)getUserDBNameInDirectory:(NSString *)userName
{

    NSString *dbName = kImDBName;
    NSString *dbFullName = [NSString pathWithComponents:@[kAppDocumentDirectoryPath, [kImDirPrefix stringByAppendingString:userName], dbName]];

    return dbFullName;
}



+ (NSString *)getDefaultTableNameForMessageRecord
{
    return kDefaultTableName_tb_msg;
}

+ (NSString *)getTableNameFroMsgType:(NSInteger)msgType
{
    NSString *str;
    switch (msgType) {
        case 1:
        {
            str = kDefaultTableName_tb_list_person;
        }
            break;
        case 2:
        {
            str = kDefaultTableName_tb_list_shops;
        }
            break;
        case 3:
        {
            str = kDefaultTableName_tb_list_goods;
        }
            break;
        case 4:
        {
            str = kDefaultTableName_tb_remark;
        }
        default:
            break;
            break;
    }
    return str;
}

@end
