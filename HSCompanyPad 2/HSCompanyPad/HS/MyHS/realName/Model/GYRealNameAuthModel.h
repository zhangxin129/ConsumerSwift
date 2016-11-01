//
//  GYRealNameAuthModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYRealNameAuthModel : JSONModel
@property (nonatomic, copy) NSString* entCustId;//企业客户号
@property (nonatomic, copy) NSString* entResNo;//企业互生号
@property (nonatomic, copy) NSString* entName;//企业注册名
@property (nonatomic, copy) NSString* entNameEn;//企业英文名称
@property (nonatomic, copy) NSString* entCustType;//企业客户类型2 成员企业;3 托管企业;4 服务公司;5 管理公司;6 地区平台;7 总平台;8 其它地区平台52 非互生格式化企业
@property (nonatomic, copy) NSString* entRegAddr;//企业注册地址
@property (nonatomic, copy) NSString* busiLicenseNo;//企业营业执照号码
@property (nonatomic, copy) NSString* busiLicenseImg;//营业执照照片
@property (nonatomic, copy) NSString* orgCodeNo;//组织机构代码证号
@property (nonatomic, copy) NSString* orgCodeImg;//组织机构代码证图片
@property (nonatomic, copy) NSString* taxNo;//纳税人识别号
@property (nonatomic, copy) NSString* taxRegImg;//税务登记证正面扫描图片
@property (nonatomic, copy) NSString* creName;//法人代表
@property (nonatomic, copy) NSString* creType;//法人证件类型1：身份证 2：护照:3：营业执照
@property (nonatomic, copy) NSString* creNo;//法人证件号码
@property (nonatomic, copy) NSString* creFaceImg;//法人身份证正面图片
@property (nonatomic, copy) NSString* creBackImg;//法人身份证反面图片
@property (nonatomic, copy) NSString* contactPerson;//联系人
@property (nonatomic, copy) NSString* contactPhone;//联系人电话
@property (nonatomic, copy) NSString* entRegCode;//企业注册编号
@property (nonatomic, copy) NSString* entRegImg;//企业注册证书
@property (nonatomic, copy) NSString* busiRegCode;//工商登记编号
@property (nonatomic, copy) NSString* busiRegImg;//工商登记证书
@property (nonatomic, copy) NSString* authProxyFile;//联系人授权委托书
@property (nonatomic, copy) NSString* entVersion;//企业重要信息版本号

@end
