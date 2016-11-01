//
//  GYDataManager.h
//  Pods
//
//  Created by wangfd on 16/7/22.
//
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, kGYDataDocumentType) {
    kGYDataDocument,
    kGYDataDocumentCaches,
    kGYDataDocumentTemp,
};


@interface GYDataManager : NSObject

#pragma mark - 沙盒管理
+ (NSString *)homePath;     // 程序主目录，可见子目录(3个):Documents、Library、tmp
+ (NSString *)appPath;        // 程序目录，不能存任何东西
+ (NSString *)docPath;        // 文档目录，需要ITUNES同步备份的数据存这里，可存放用户数据
+ (NSString *)libPrefPath;    // 配置目录，配置文件存这里
+ (NSString *)libCachePath;    // 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;        // 临时缓存目录，APP退出后，系统可能会删除这里的内容


#pragma mark - UserDefault 管理数据
/**
 *    采用同步方式缓存数据
 *
 *    @param value 数据
 *    @param key   数据的key
 */
+ (void)saveDataByUserDefault:(id<NSCopying>)value
                          key:(NSString*)key;

/**
 *    采用异步方式缓存数据
 *
 *    @param value             数据
 *    @param key               数据的key
 *    @param target            目标对象
 *    @param dataInvalidAction 数据合法性检测的方法
 */
+ (void)saveDataByUserDefault:(id<NSCopying>)value
                          key:(NSString*)key
                       target:(id)target
            dataInvalidAction:(SEL)dataInvalidAction;

+ (id)dataByUserDefault:(NSString*)key;

+ (void)deleteDataUserDefault:(NSString*)key;

+ (void)clearUserDefaultData;

#pragma mark - NSFileManager
/**
 *  通用NSFileManager创建文件
 *
 *  @param type     文件所在的主目录
 *  @param subDir   文件所在的子目录 中间会添加GYDocument
 *  @param fileName 文件名称 包含拓展名
 *
 *  @return 文件路径 如果为nil则为创建不成功
 */
+ (NSString *)createDataFile:(kGYDataDocumentType) type subDir:(NSString *)subDir filename:(NSString *)fileName;

/**
 *  创建目录
 *
 *  @param type   目录所在的上一级目录
 *  @param subDir 子目录  中间会有GYDocument
 *
 *  @return 目录路径 如果为nil则为创建不成功
 */
+ (NSString *)createDataDirectory:(kGYDataDocumentType) type subDir:(NSString *)subDir ;
/**
 *  删除文件
 *
 *  @param type     文件所在目录
 *  @param subDir   文件所在子目录
 *  @param fileName 文件名
 *
 *  @return 是否成功
 */

+ (BOOL)deleteDataFile:(kGYDataDocumentType) type subDir:(NSString *)subDir filename:(NSString *)fileName;

/**
 *  删除目录
 *
 *  @param type   目录所在上一级主目录
 *  @param subDir 目录所在上一级子目录
 *
 *  @return 是否成功
 */
+ (BOOL)deleteDataDirectory:(kGYDataDocumentType) type subDir:(NSString *)subDir ;
/**
 *  覆盖重写文件
 *
 *  @param frompath 来源
 *  @param topath   目的地址
 *
 *  @return 是否成功
 */
+ (BOOL)overWriteDataFileFromPath:(NSString *)frompath to:(NSString *)topath;
/**
 *  计算文件大小
 *
 *  @param path 文件所在路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)getFileSizeWithPath:(NSString *)path;
/**
 *  计算文件夹大小
 *
 *  @param path 文件夹路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)getdirSizeWihtPath:(NSString *)path;
/**
 *  对文件进行重命名
 *
 *  @param path        文件所在路径
 *  @param newFileName 新名称
 *  @param oldFileName 原来名称
 *
 *  @return 是否成功
 */

+ (BOOL)renameFileNameWithPath:(NSString *)path newFileName:(NSString *)newFileName oldFileName:(NSString *)oldFileName;



@end
