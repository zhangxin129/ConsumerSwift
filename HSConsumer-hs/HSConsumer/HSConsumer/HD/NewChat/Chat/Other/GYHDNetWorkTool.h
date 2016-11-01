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
 * 获得好友基本信息， 通过block返回
 */
- (void)getFriendListRequetResult:(RequetResultWithDict)handler;

/**
 * 绑定企业账号
 */
- (void)bindCompanyWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**上传数据*/
- (void)postUrlString:(NSString*)urlstring Data:(NSData*)data fileName:(NSString*)fileName RequetResult:(RequetResultWithDict)handler;
/**上传头像*/
- (void)postHeaderWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler;
/**上传图片*/
- (void)postImageWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler;

/**上传音频*/
- (void)postAudioWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler;
/**上传视频*/
- (void)postVideoWithData:(NSData*)data RequetResult:(RequetResultWithDict)handler;
/**下载音频*/
- (void)downloadDataWithUrlString:(NSString*)urlstring filePath:(NSString*)filePath;
/**下载文件block返回*/
- (void)downloadDataWithUrlString:(NSString*)urlstring RequetResult:(RequetResultWithDict)handler;
/**搜索好友*/
//- (void)searchFriendWithString:(NSString *)string Page:(NSString *)page RequetResult:(RequetResultWithDict)handler;
/**搜索好友*/
- (void)searchFriendWithDict:(NSDictionary*)dict Page:(NSString*)page RequetResult:(RequetResultWithDict)handler;
/**商品分类*/
- (void)loadTopicFromNetworkRequetResult:(RequetResultWithDict)handler;
/**查询好友分组*/
- (void)getFriendTeamRequetResult:(RequetResultWithDict)handler;
/**创建好友分组*/
- (void)createFriendTeamWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**删除分组*/
- (void)deleteFriendTeamID:(NSString*)teamID RequetResult:(RequetResultWithDict)handler;
/**移动好友分组*/
- (void)MovieFriendWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**移动好友到多个分组*/
- (void)MovieFriendtoTagWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**编辑好友分组*/
- (void)updateFriendTeamWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**根据CustID查看好友信息*/
- (void)searchFriendWithCustId:(NSString*)custID RequetResult:(RequetResultWithDict)handler;

- (void)EasyBuyGetMyConcernShopUrlRequetResult:(RequetResultWithArray)handler;
/**上传自己信息*/
- (void)updateNetworkInfoWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**好友*/
- (void)deleteFriendWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;

- (void)queryWhoAddMeListRequetResult:(RequetResultWithDict)handler;
/**根据关键字搜索企业*/
- (void)searchCompanyWithString:(NSString*)string currentPage:(NSString*)currentPage RequetResult:(RequetResultWithDict)handler;
/**根据城市搜索企业*/
- (void)searchCompanyWithcity:(NSString*)city currentPage:(NSString*)currentPage RequetResult:(RequetResultWithDict)handler;

/**关注企业*/
- (void)ConcernShopUrlWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**取消关注*/
- (void)CancelConcernShopUrlWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**更新好友昵称*/
- (void)updateFriendNickNameWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
/**获取离线消息*/
-(void)postOffLinePushMessageRequetResult:(RequetResultWithArray)handler;
- (void)deleteRedundantFriendVerifyDataWithDict:(NSDictionary*)dict RequetResult:(RequetResultWithDict)handler;
/**个人设置*/
-(void)updatePrivacyWithString:(NSString *)string RequetResult:(RequetResultWithDict)handler;
/**查询个人设置*/
- (void)searchPrivacyRequetResult:(RequetResultWithDict)handler;
- (void)searchCompanyTypeRequetResult:(RequetResultWithDict)handler;
/**获取周边企业*/
- (void)getTopicListWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
- (void)GetFoodMainPageUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
- (void)EasyBuySearchShopUrlWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
/**搜索用户*/
- (void)getConsumerOrCompanyInfoWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
/**查询企业信息*/
- (void)GetVShopShortlyInfoUrlWithResourcesNo:(NSString *)string RequetResult:(RequetResultWithDict)handler;
/**根据手机号查找好友*/
- (void)getUserByPhoneContactsWithDict:(NSDictionary *)dict RequetResult:(RequetResultWithDict)handler;
@end
/**
 * 成服务器上获得某个好友的详细信息
 */
//- (void)getFriendDetailWithAccountID:(NSString *)accountID RequetResult:(RequetResultWithDict)handler;