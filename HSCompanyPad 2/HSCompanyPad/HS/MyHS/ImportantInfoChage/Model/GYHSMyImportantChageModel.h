//
//  GYHSMyImportantChageModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSInteger, GYHSImportantUploadType) {
    GYHSImportantUploadTypeNone = 0,
    GYHSImportantUploadTypeImptappPic = 1 ,//业务办理申请书
    GYHSImportantUploadTypebusiLicenseImg = 2 ,//营业执照照片
    GYHSImportantUploadTypelinkAuthorizePic = 3,//联系人授权委托书
};


@class GYHSMyImportantChageModel;

@interface GYHSMyImportantChageStatusModel : JSONModel

@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSString* apprRemark;
@property (nonatomic, copy) NSString* apprDate;
@property (nonatomic, copy) NSString* isChange;
@property (nonatomic, strong) GYHSMyImportantChageModel* entity;

@end



@interface GYHSMyImportantChageModel : JSONModel

@property (nonatomic, copy) NSString* entRegCode;
@property (nonatomic, copy) NSString* busiRegCode;
@property (nonatomic, copy) NSString* entVersion;
@property (nonatomic, copy) NSString* busiRegImg;
@property (nonatomic, copy) NSString* authProxyFile;
@property (nonatomic, copy) NSString* entRegImg;
/*!
 *    联系人
 */
@property (nonatomic, copy) NSString* contactPerson;
/*!
 *    企业客户号
 */
@property (nonatomic, copy) NSString* entCustId;
/*!
 *    企业注册名
 */
@property (nonatomic, copy) NSString* entName;
/*!
 *    组织机构代码证图片
 */
@property (nonatomic, copy) NSString* orgCodeImg;

/*!
 *    企业英文名称
 */
@property (nonatomic, copy) NSString* entNameEn;
/*!
 *    组织机构代码证号
 */
@property (nonatomic, copy) NSString* orgCodeNo;
/*!
 *    纳税人识别号
 */
@property (nonatomic, copy) NSString* taxNo;
/*!
 *    企业营业执照号码
 */
@property (nonatomic, copy) NSString* busiLicenseNo;
/*!
 *    税务登记证正面扫描图片
 */
@property (nonatomic, copy) NSString* taxRegImg;

/*!
 *    法人身份证反面图片
 */
@property (nonatomic, copy) NSString* creBackImg;
/*!
 *    法人身份证正面图片
 */
@property (nonatomic, copy) NSString* creFaceImg;

/*!
 *    法人证件类型 1：身份证 2：护照:3：营业执照
 */
@property (nonatomic, copy) NSString* creType;
/*!
 *    法人证件号码
 */
@property (nonatomic, copy) NSString* creNo;
/*!
 *    联系人电话
 */
@property (nonatomic, copy) NSString* contactPhone;
/*!
 *    企业注册地址
 */
@property (nonatomic, copy) NSString* entRegAddr;
/*!
 *    企业客户类型
 */
@property (nonatomic, copy) NSString* entCustType;
/*!
 *    法定代表人姓名
 */
@property (nonatomic, copy) NSString* creName;
/*!
 *    企业互生号
 */
@property (nonatomic, copy) NSString* entResNo;
/*!
 *    营业执照照片
 */
@property (nonatomic, copy) NSString* busiLicenseImg;
/*!
 *    法定代表人手机号
 */
@property (nonatomic, copy) NSString* legalPersonPhone;

@end
