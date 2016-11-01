//
//  GYHDNetWorkTool.h
//  HSConsumer
//
//  Created by shiang on 16/1/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//  所有的http api 都写到这个方法里

#import <Foundation/Foundation.h>
#import "GYHDMessageCenter.h"

@interface GYHDNetWorkTool : NSObject
/**
 *	构建NetworkTool单例
 *
 *	@return	返回单例
 */
+ (instancetype)sharedInstance;
/**
 * 根据客户号搜索用户信息
 */
- (void)postQueryUserInfoByCustId:(NSString *)custId RequetResult:(RequetResultWithArray)handler;
/**
 * 查询企业下的所有操作员， 通过block返回
 */
- (void)postListOperByEntCustIdResult:(RequetResultWithArray)handler;

/**
 * 拉取离线消息
 */
-(void)postGetOffLinePushMessage;

/**上传数据*/
- (void)postUrlString:(NSString *)urlstring Data:(NSData *)data fileName:(NSString *)fileName RequetResult:(RequetResultWithDict)handler;
/**上传图片*/
- (void)postImageWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler;

/**上传音频*/
- (void)postAudioWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler;
/**上传视频*/
- (void)postVideoWithData:(NSData *)data RequetResult:(RequetResultWithDict)handler;
/**下载音频*/
- (void)downloadDataWithUrlString:(NSString *)urlstring filePath:(NSString *)filePath;
/**下载文件block返回*/
- (void)downloadDataWithUrlString:(NSString *)urlstring RequetResult:(RequetResultWithDict)handler;
@end
