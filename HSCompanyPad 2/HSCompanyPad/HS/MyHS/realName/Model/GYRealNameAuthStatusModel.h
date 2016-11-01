//
//  GYRealNameAuthStatusModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYRealNameAuthStatusModel : JSONModel
@property (nonatomic, copy) NSString* applyId;//申请编号,由BS生成
@property (nonatomic, copy) NSString* entResNo;//企业互生号
@property (nonatomic, copy) NSString* entCustId;//企业客户号
@property (nonatomic, copy) NSString* custType;//企业客户类型2:成员3:托管4:服务
@property (nonatomic, copy) NSString* entCustName;//企业名称
@property (nonatomic, copy) NSString* entCustNameEn;//企业英文名称
@property (nonatomic, copy) NSString* countryNo;//企业所在国家代码
@property (nonatomic, copy) NSString* provinceNo;//企业所在省代码
@property (nonatomic, copy) NSString* cityNo;//企业所在城市代码
@property (nonatomic, copy) NSString* entAddr;//企业地址
@property (nonatomic, copy) NSString* linkman;//联系人姓名
@property (nonatomic, copy) NSString* mobile;//联系人手机
@property (nonatomic, copy) NSString* legalName;//法人代表姓名
@property (nonatomic, copy) NSString* legalCreType;//法人代表证件类型1：身份证:IDC、2：护照:PS
@property (nonatomic, copy) NSString* legalCreNo;//法人代表证件号码
@property (nonatomic, copy) NSString* licenseNo;//营业执照号
@property (nonatomic, copy) NSString* orgNo;//组织机构代码证号
@property (nonatomic, copy) NSString* taxNo;//纳税人识别号
@property (nonatomic, copy) NSString* lrcFacePic;//法人代表证件正面图路径
@property (nonatomic, copy) NSString* lrcBackPic;//法人代表证件反面图路径
@property (nonatomic, copy) NSString* licensePic;//营业执照扫描件
@property (nonatomic, copy) NSString* orgPic;//组织机构代码证扫描件
@property (nonatomic, copy) NSString* taxPic;//税务登记证扫描件
@property (nonatomic, copy) NSString* status;//状态（0：为未审批W 1：为地区平台初审通过1Y 2：为地区平台复审通过Y 3：为初审/审批未通过N）
@property (nonatomic, copy) NSString* apprContent;//审批内容
@property (nonatomic, copy) NSString* apprDate;//审批时间
@property (nonatomic, copy) NSString* createdDate;//创建日期
@property (nonatomic, copy) NSString* updateDate;//修改日期
@property (nonatomic, copy) NSString* optCustId;//操作员客户号
@property (nonatomic, copy) NSString* optName;//操作员名字
@property (nonatomic, copy) NSString* optEntName;//操作员所属公司名称/操作员名字

@end
