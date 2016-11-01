//
//  GYHSMyCompanyInfoModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSMyCompanyInfoModel : JSONModel

@property (nonatomic, copy) NSString *entCustId;
@property (nonatomic, copy) NSString *operatorCustId;
@property (nonatomic, copy) NSString *busiLicenseImg;
/*!
 *    成立日期
 */
@property (nonatomic, copy) NSString *buildDate;
/*!
 *    营业执照号码
 */
@property (nonatomic, copy) NSString *busiLicenseNo;
/*!
 *    经营范围
 */
@property (nonatomic, copy) NSString *businessScope;
/*!
 *    联系电话
 */
@property (nonatomic, copy) NSString *contactPhone;
/*!
 *    法人代表
 */
@property (nonatomic, copy) NSString *creName;
/*!
 *    法人证件号码
 */
@property (nonatomic, copy) NSString *creNo;
/*!
 *    法人证件类型：1：身份证 2：护照:3：营业执照
 */
@property (nonatomic, copy) NSString *creType;
/*!
 *    营业期限
 */
@property (nonatomic, copy) NSString *endDate;
/*!
 *    企业名称
 */
@property (nonatomic, copy) NSString *entName;
/*!
 *    企业地址
 */
@property (nonatomic, copy) NSString *entRegAddr;
/*!
 *    企业性质
 */
@property (nonatomic, copy) NSString *nature;
/*!
 *    组织机构代码证号
 */
@property (nonatomic, copy) NSString *orgCodeNo;
/*!
 *    纳税人识别号
 */
@property (nonatomic, copy) NSString *taxNo;

@end
