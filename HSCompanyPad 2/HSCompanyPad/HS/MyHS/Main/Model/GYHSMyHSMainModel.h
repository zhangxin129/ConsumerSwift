//
//  GYHSMyHSMainModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSMyHSMainModel : JSONModel
/*!
 *    logo图片
 */
@property (nonatomic, copy) NSString* logo;
/*!
 *    绑定银行卡数量
 */
@property (nonatomic, copy) NSString* banks;
/*!
 *    绑定快捷卡数量
 */
@property (nonatomic, copy) NSString* qkBanks;
/*!
 *    企业邮箱
 */
@property (nonatomic, copy) NSString* email;
/*!
 *    年费截止日期
 */
@property (nonatomic, copy) NSString* endDate;
/*!
 *    欠缴总金额
 */
@property (nonatomic, copy) NSString* arrearAmount;
/*!
 *    实名认证状态1.已认证、0.未认证
 */
@property (nonatomic, copy) NSString* isRealnameAuth;
/*!
 *    系统开启日期
 */
@property (nonatomic, copy) NSString* openDate;
/*!
 *      1：正常    成员企业、托管企业
 *      2：预警    成员企业、托管企
 *      3：休眠    成员企业
 *      4：长眠    成员企业
 *      5：已注销     成员企业
 *      6：申请停止积分活动中    托管企业
 *      7：停止积分活动          托管企业
 *      8：注销申请中   成员企业
 */
@property (nonatomic, copy) NSString* status;
/*!
 *    服务公司联系人
 */
@property (nonatomic, copy) NSString* superContactPerson;
/*!
 *    服务公司联系电话
 */
@property (nonatomic, copy) NSString* superContactPhone;
/*!
 *    服务公司名称
 */
@property (nonatomic, copy) NSString* superEntCustName;
/*!
 *    服务公司注册地址
 */
@property (nonatomic, copy) NSString *superEntRegAddr;
/*!
 *    服务公司互生号
 */
@property (nonatomic, copy) NSString *superEntResNo;


@property (nonatomic, copy) NSString *isAuthEmail;
//开户证明图片
@property (nonatomic, copy) NSString *accountLicenseImg;
@end
