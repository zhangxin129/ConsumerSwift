//
//  GYJSPatch.h
//  HSConsumer
//
//  Created by xiongyn on 16/6/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYJSPatch : NSObject
//检测版本更新，
//parameters = @{@"appKey":@"73F165558AD148638C06D0F77FCD76BD",@"versionCode":@"2.0.0"}
+ (void)getNewVersionWithURL:(NSString *)url parameters:(NSDictionary *)parameters;
+ (void)deleteLocaJSpatch;

@end
