//
//  GYHEUtil.h
//  HSConsumer
//
//  Created by xiongyn on 16/7/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHEUtil : NSObject

+ (void)alertViewParseNetWork:(NSDictionary*)serverDic;

+ (void)showLocationServiceInfo:(void (^)())cancleBlock;
@end
