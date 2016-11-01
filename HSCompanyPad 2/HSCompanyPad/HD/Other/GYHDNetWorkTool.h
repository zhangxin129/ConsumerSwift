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
//1.添加快捷回复消息请求URL
- (void)addQuickReplyMsgWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
//2.更新快捷回复消息请求URL
- (void)updateQuickReplyMsgWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
//3.删除快捷回复消息请求URL
- (void)deleteQuickReplyMsgByMsgIdWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
//4.根据客户号查询快捷回复消息请求URL
- (void)queryQuickReplyMsgByCustIdWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithArray)handler;
/**
 * 查询企业下的在线客服信息
 */
- (void)queryOnlineCustomerServiceListWithEntResNo:(NSString *)entResNo RequetResult:(RequetResultWithArray)handler;

/**
 * 查询企业客服记录列表
 */
- (void)queryCustomerServiceRecordListPage:(NSInteger)page RequetResult:(RequetResultWithArray)handler;

/**
 * 查询消费者客服记录列表
 */
- (void)queryCustomerServiceRecordListByCustomerId:(NSString*)customerid RequetResult:(RequetResultWithArray)handler;

/**
 * 查询企业提示语
 */
- (void)queryCompanyGreetingRequetResult:(RequetResultWithArray)handler;


/**
 * 根据会话ID查询会话记录
 */
- (void)querySessionRecordWithSession:(NSString *)sessionId page:(NSInteger)page RequetResult:(RequetResultWithArray)handler;

@end