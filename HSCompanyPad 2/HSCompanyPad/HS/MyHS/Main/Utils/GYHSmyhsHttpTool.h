//
//  GYHSmyhsHttpTool.h
//  HSCompanyPad
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSmyhsHttpTool : NSObject
/**
 *  获取企业资格状态
 */
+ (void)GetEntStatus:(HTTPSuccess)success
             failure:(HTTPFailure)err;
//上传图片
+ (void)uploadImageWithUrl:(NSString*)url params:(NSDictionary*)params imageData:(NSData*)imageData imageName:(NSString*)name success:(HTTPSuccess)success failure:(HTTPFailure)err;
//企业绑定银行账户列表
+ (void)getCompanyBindAccountListWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  成员企业销户
 */
+ (void)createMemberQuitWithbankAcctId:(NSString*)bankAcctId
                           applyReason:(NSString*)reason
                             applyFile:(NSString*)file
                               success:(HTTPSuccess)success
                               failure:(HTTPFailure)err;
/**
 *  申请参与/停止积分活动
 */
+ (void)createPointActivityApplyReason:(NSString*)applyReason
                             oldStatus:(NSNumber*)oldStatus
                             applyType:(NSNumber*)applyType
                          bizApplyFile:(NSString*)bizApplyFile
                               success:(HTTPSuccess)success
                               failure:(HTTPFailure)err;
/**
 *  解绑银行卡
 */
+ (void)unBindBankWithAccId:(NSString*)accId success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  解绑企业绑定快捷支付卡
 */
+ (void)deleteQiuckBankWithAccId:(NSString*)accId bindingNo:(NSString*)bindingNo success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 * 绑定银行卡信息
 */
+ (void)bindBankInfoWithBankCode:(NSString*)bankCode bankName:(NSString*)bankName bankAcctNo:(NSString*)bankAcctNo countryCode:(NSString*)countryCode provinceCode:(NSString*)provinceCode cityCode:(NSString*)cityCode isDefault:(NSString*)isDefault success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  快捷支付卡列表
 */
+ (void)ListQkBanks:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  通过客户号查询企业实名认证详情
 */
+ (void)getEntRealnameAuthByCustId:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  获取实名认证信息
 *
 */
+ (void)getEntRealnameAuthByhsResNo:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  创建企业实名认证申请
 *
 */
+ (void)createEntRealNameAuthWithparamters:(NSDictionary*)paramters success:(HTTPSuccess)success failure:(HTTPFailure)err;
/**
 *  
 *  查询开户银行列表
 *
 */
+ (void)getQueryBank:(HTTPSuccess)success failure:(HTTPFailure)err;

/**
 *  下载模板
 */
+ (void)queryImageDocListWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure;

/**
 *  查询示例图片
 */
+ (void)getQueryImageDocListWithSuccess:(HTTPSuccess)success failure:(HTTPFailure)failure;
/**
 *  保存上传的开户许可证
 *
 *  @param file 上传成功后的文件
 */
+ (void)saveBankOpenLiceseWithFile:(NSString *)file success:(HTTPSuccess)success failure:(HTTPFailure)err;
@end
