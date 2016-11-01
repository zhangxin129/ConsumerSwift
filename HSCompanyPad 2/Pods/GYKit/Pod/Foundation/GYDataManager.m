//
//  GYDataManager.m
//  Pods
//
//  Created by wangfd on 16/7/22.
//
//

#import "GYDataManager.h"
#import "GYKitConstant.h"


// 文件管理器声明
// #define kFileManager [NSFileManager defaultManager]

// 使用UserDefault保存数据的所有key
#define kGYDataManagerUSAllKey @"kGYDataManagerUSAllKey"

#define kGYDocument @"/GYDocument"

@implementation GYDataManager

#pragma mark - 沙盒管理
+ (NSString *)homePath{
    
    return NSHomeDirectory();
}



+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
    
    return  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)tmpPath
{
    return  NSTemporaryDirectory();
}




#pragma mark - UserDefault 管理数据
+ (void)saveDataByUserDefault:(id<NSCopying>)value
                          key:(NSString*)key
{
    if (value == nil || key == nil) {
        GYKitDebugLog(@"The value:%@ or key:%@ is nil.", value, key);
        return;
    }

    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:value];
    [userDefault setObject:data forKey:key];
    [userDefault synchronize];
    [self rememberUSKey:key isAdd:YES];
}

+ (void)saveDataByUserDefault:(id<NSCopying>)value
                          key:(NSString*)key
                       target:(id)target
            dataInvalidAction:(SEL)dataInvalidAction
{
    if (target != nil && dataInvalidAction != nil) {
        BOOL result = [target performSelector:dataInvalidAction withObject:(id)value];
        if (!result) {
            GYKitDebugLog(@"The data invalid, result:%d", result);
            return;
        }
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self saveDataByUserDefault:value key:key];
    });
}

+ (id)dataByUserDefault:(NSString*)key
{
    if (key == nil || key.length == 0) {
        GYKitDebugLog(@"The key is nil.");
        return nil;
    }

    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    id unarchiveData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return unarchiveData;
}

+ (void)deleteDataUserDefault:(NSString*)key
{
    if (key == nil || key.length == 0) {
        GYKitDebugLog(@"The key is nil.");
        return;
    }

    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];

    [self rememberUSKey:key isAdd:NO];
}

+ (void)clearUserDefaultData
{
    NSMutableArray* allKeyAry = [NSMutableArray array];
    [allKeyAry addObject:kGYDataManagerUSAllKey];

    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray* tmpAry = [userDefault objectForKey:kGYDataManagerUSAllKey];

    if ([tmpAry count] > 0) {
        [allKeyAry addObjectsFromArray:tmpAry];
    }

    GYKitDebugLog(@"%s, allKeyAry:%@", __FUNCTION__, allKeyAry);

    for (NSString* keyIndex in allKeyAry) {
        [userDefault removeObjectForKey:keyIndex];
    }

    [userDefault synchronize];
}

#pragma mark - private methods
+ (void)rememberUSKey:(NSString*)key isAdd:(BOOL)isAdd
{
    NSMutableArray* allKeyAry = [NSMutableArray array];
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSArray* tmpAry = [userDefault objectForKey:kGYDataManagerUSAllKey];

    if ([tmpAry count] > 0) {
        [allKeyAry addObjectsFromArray:tmpAry];
    }

    BOOL keyExist = NO;
    for (NSString* keyIndex in allKeyAry) {
        if ([key isEqualToString:keyIndex]) {
            keyExist = YES;
            break;
        }
    }

    if (isAdd) {
        if (!keyExist) {
            [allKeyAry addObject:key];

            [userDefault setObject:allKeyAry forKey:kGYDataManagerUSAllKey];
            [userDefault synchronize];
        }
    }
    else {
        if (keyExist) {
            [allKeyAry removeObject:key];

            [userDefault setObject:allKeyAry forKey:kGYDataManagerUSAllKey];
            [userDefault synchronize];
        }
    }

    GYKitDebugLog(@"%s, allKeyAry:%@, isAdd:%d", __FUNCTION__, allKeyAry, isAdd);
  
}







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
+ (NSString *)createDataFile:(kGYDataDocumentType) type subDir:(NSString *)subDir filename:(NSString *)fileName
{
    
    NSString *document = [self createDataDirectory:type subDir:subDir];
    if (document) {
         NSFileManager *fileManager = [NSFileManager defaultManager];
        if (fileName) document = [document stringByAppendingPathComponent:fileName];
        if(![fileManager fileExistsAtPath:document]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
            
            return [fileManager createFileAtPath:document contents:nil attributes:nil] ? document :nil;
        }
            return document;
        
    }
            return nil;
  
}




+ (NSString *)createDataDirectory:(kGYDataDocumentType) type subDir:(NSString *)subDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath =  [self appendingPathDataDirectory:type subDir:subDir];
    if(![fileManager fileExistsAtPath:filePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        return [fileManager createDirectoryAtPath:filePath  withIntermediateDirectories:YES attributes:nil error:nil] ? filePath :nil;
    }
    
    return filePath;
}



+ (BOOL)deleteDataFile:(kGYDataDocumentType) type subDir:(NSString *)subDir filename:(NSString *)fileName
{
    
    NSString *filePath = [self appendingPathDataDirectory:type subDir:subDir];
    if (fileName) filePath = [filePath stringByAppendingPathComponent:fileName];
     NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

+ (BOOL)deleteDataDirectory:(kGYDataDocumentType) type subDir:(NSString *)subDir
{
    
    return [self deleteDataFile:type subDir:subDir filename:nil];
}


+ (BOOL)overWriteDataFileFromPath:(NSString *)frompath to:(NSString *)topath
{
    
    NSFileHandle *inFile, *outFile, *oldFile;
    NSData *buffer;
    NSData *oldBuffer;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:frompath] || ![fileManager fileExistsAtPath:topath]){//如果不存在,返回no
    return NO;
    }
    
    inFile = [NSFileHandle fileHandleForReadingAtPath:frompath];
    
    oldFile = [NSFileHandle fileHandleForReadingAtPath:topath];
    
    if(inFile == nil)
    {
        GYKitDebugLog(@"Open of frompath for reading failed!");
        return NO;
    }
    
    if (oldFile == nil) {
        GYKitDebugLog(@"Open of topath for reading failed!");
        return NO;
    }

    outFile = [NSFileHandle fileHandleForUpdatingAtPath:topath];
    
    if(outFile == nil)
    {
        GYKitDebugLog(@"Open of topath for updating failed!");
        return NO;
    }
    
    [outFile truncateFileAtOffset:0];
    
    //从inFile中读取数据，并将其写入到outFile中
    buffer = [inFile readDataToEndOfFile];
    
    [outFile writeData:buffer];
    
    //关闭两个文件
    [inFile closeFile];
    [outFile closeFile];
    
    if ([self getFileSizeWithPath:topath]) {
        return YES;
    }
}

+ (unsigned long long)getFileSizeWithPath:(NSString *)path
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
   
}


+ (unsigned long long)getdirSizeWihtPath:(NSString *)path
{

    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        folderSize += [self getFileSizeWithPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (BOOL)renameFileNameWithPath:(NSString *)path newFileName:(NSString *)newFileName oldFileName:(NSString *)oldFileName
{

    return  [[NSFileManager defaultManager] moveItemAtPath:[path stringByAppendingPathComponent:oldFileName] toPath:[path stringByAppendingPathComponent:newFileName]  error:nil];

}



+ (NSString *) appendingPathDataDirectory:(kGYDataDocumentType) type subDir:(NSString *)subDir {
    NSString *filePath = nil;
    switch (type) {
        case kGYDataDocument:
            filePath = [self docPath];
            break;
        case kGYDataDocumentCaches:
            filePath = [self libCachePath];
            break;
        case kGYDataDocumentTemp:
            filePath = [self tmpPath];
            break;
            
        default:
            break;
    }
    filePath = [filePath stringByAppendingString:kGYDocument];
    if (subDir) filePath = [filePath stringByAppendingPathComponent:subDir];
    return filePath;
}



@end
