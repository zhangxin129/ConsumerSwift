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
//ios消费者验证appkey "73F165558AD148638C06D0F77FCD76BD";
//ios企业验证appkey "D43AC790FA4D4797916E16BE143BC837";
//ios餐饮平板appkey "EFFCB3186AC64697A37F56F5928080BB";
+ (void)getNewVersionWithURL:(NSString *)url parameters:(NSDictionary *)parameters;

@end
