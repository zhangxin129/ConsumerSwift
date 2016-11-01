//
//  GYJSPatch.m
//  HSConsumer
//
//  Created by xiongyn on 16/6/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYJSPatch.h"
#import "JPEngine.h"
#import "GYDataManager.h"
#define GYPatchVersion @"GYPatchVersion"
#define GYPatchDefaultName @"GYJSPatch.js"
#define GYPatchOldName @"old_GYJSPatch.js"
#define GYPatchName @"GYPatchName"

@interface GYJSPatch()

@property (nonatomic, copy)NSString *currentPath;
@property (nonatomic, copy)NSString *currentVersion;
@property (nonatomic, copy)NSString *currentName;

@end

@implementation GYJSPatch

+ (void)getNewVersionWithURL:(NSString *)url parameters:(NSDictionary *)parameters withFileUrl:(NSString *)fileUrl {
   
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(responseObject) {
            if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"200"]) {
                
                //检测是否有新版本补丁
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

                if([kSaftToNSString(responseObject[@"data"][@"currentPatchVersion"]) floatValue] > [kSaftToNSString([def valueForKey:GYPatchVersion]) floatValue])  {
                    
                    NSString *path = [responseObject[@"data"][@"currentPatchList"] firstObject];
                    //有新版本就更新
                    [GYJSPatch getURLJSpatch:[NSString stringWithFormat:@"%@%@",fileUrl,path] withVersion:responseObject[@"data"][@"currentPatchVersion"]];
                }else {
                    //无新版本
                    //若本地沙盒文件被删除,则请求数据，否则加载本地
                    NSFileManager *fm = [NSFileManager defaultManager];
                    if(![fm fileExistsAtPath:[GYJSPatch locaPath]]) {
                        //文件不存在，本地版本号置0
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        [def setValue:@"0" forKey:@"GYPatchVersion"];
                        [def synchronize];
                        //下载新版本
                        NSString *path = [responseObject[@"data"][@"currentPatchList"] firstObject];
                        [GYJSPatch getURLJSpatch:[NSString stringWithFormat:@"%@%@",kFilterServerBaseURL,path] withVersion:responseObject[@"data"][@"currentPatchVersion"]];
                        
                        return ;
                    }else {
                        //加载本地
                        [GYJSPatch getLocaJSpatch];
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ;
    }];
}
//获取本地js沙盒路径
+ (NSString *)locaPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:GYPatchDefaultName];
    
    return path;
}

//加载本地JSPatch
+ (void)getLocaJSpatch {
    
    NSString *path = [GYJSPatch locaPath];
    
    NSFileManager *fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:path]) {
        
        [JPEngine startEngine];
        NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [JPEngine evaluateScript:script];
    }
    
}

//加载服务器JSPatch
+ (void)getURLJSpatch:(NSString *)url withVersion:(NSString *)version {
    
    [JPEngine startEngine];
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL* URL = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask* downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress* downloadProgress) {
        
        NSLog(@"progress:%@", [downloadProgress localizedDescription]);
        
    }destination:^NSURL*(NSURL* targetPath, NSURLResponse* response) {
        NSFileManager *fm=[NSFileManager defaultManager];
        if(![fm fileExistsAtPath:[GYJSPatch locaPath]]) {
            [fm createFileAtPath:[GYJSPatch locaPath] contents:nil attributes:nil];
        }
        if([GYDataManager overWriteDataFileFromPath:[targetPath path] to:[GYJSPatch locaPath]]) {
            
            //更新本地存储版本号
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setValue:version forKey:GYPatchVersion];
            [def synchronize];
            
        }
        
        return nil;
        
    }completionHandler:^(NSURLResponse* response, NSURL* filePath, NSError* error) {
        
        [self getLocaJSpatch];
        
    }];
    [downloadTask resume];
    
}

//删除本地JSPatch
+ (void)deleteLocaJSpatch {
    NSString *path = [GYJSPatch locaPath];
    
    NSFileManager *fm=[NSFileManager defaultManager];
    if([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
}

+ (void)loadLocalJSFileWithPath:(NSString *)path {
    
    [JPEngine startEngine];
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
    
}

@end
