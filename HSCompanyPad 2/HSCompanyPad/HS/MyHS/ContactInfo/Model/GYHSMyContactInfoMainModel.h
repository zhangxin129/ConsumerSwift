//
//  GYHSMyContactInfoMainModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSMyContactInfoMainModel : JSONModel

@property (nonatomic, copy) NSString *entCustId;
@property (nonatomic, copy) NSString *entResNo;
@property (nonatomic, copy) NSString *operatorCustId;
/*!
 *    授权委托书
 */
@property (nonatomic, copy) NSString *authProxyFile;

/*!
 *    联系电话
 */
@property (nonatomic, copy) NSString *contactPhone;
/*!
 *    邮编
 */
@property (nonatomic, copy) NSString *postCode;
/*!
 *    邮箱是否验证 1:是 0：否
 */
@property (nonatomic, copy) NSString *isAuthEmail;
/*!
 *    安全邮箱
 */
@property (nonatomic, copy) NSString *email;
/*!
 *    帮扶协议文件附件
 */
@property (nonatomic, copy) NSString *helpAgreement;
/*!
 *    联系地址
 */
@property (nonatomic, copy) NSString *contactAddr;
/*!
 *    联系人
 */
@property (nonatomic, copy) NSString *contactName;
/*!
 *    法定代表人手机号
 */
@property (nonatomic, copy) NSString *legalPersonPhone;
/*!
 *    法定代表人姓名
 */
@property (nonatomic, copy) NSString *creName;

@end
