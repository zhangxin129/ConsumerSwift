//
//  GYSamplePictureManager.h
//  HSConsumer
//
//  Created by xiaoxh on 16/6/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYSamplePictureModel.h"

@interface GYSamplePictureManager : NSObject
+ (id)shareInstance;
- (NSMutableArray*)selectFromDB; //读取数据库
- (void)insertIntoDB:(GYSamplePictureModel*)model; //插入数据源中
- (void)updateDBCollect:(NSString*)key; //更新数据
- (void)cleanDB; //清空数据源
- (void)deleteDB:(NSString*)docName;
- (GYSamplePictureModel*)selectDecCode:(NSString*)docCode;

@end
