//
//  GYViewControllerLog.h
//  Pods
//
//  Created by zhangqy on 16/3/28.
//
//

#import <Foundation/Foundation.h>


#if 1 // Set to 1 to enable VCLife logging
#define GYVCLifeLog(...) NSLog(__VA_ARGS__)
#else
#define GYVCLifeLog(...)
#endif

@interface GYViewControllerLog : NSObject

@end
