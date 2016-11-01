//
//  GYEnum.h
//  GYCompany
//
//  Created by cook on 15/9/19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYCompany_GYEnum_h
#define GYCompany_GYEnum_h

//企业类型
typedef enum : NSInteger
{
    kCompanyType_None = 0,  //空
    kCompanyType_Trustcom,  //托管企业
    kCompanyType_Membercom,     //成员企业
    kCompanyType_Servicecom     //服务公司
}kCompanyType;


/**
 *  首页选择环境
 */
typedef NS_ENUM(NSInteger, EMLoginEn) {
    kLoginEn_dev = 0, //开发环境带默认账号
    kLoginEn_test,    //测试环境带默认账号
    kLoginEn_demo,    //演示环境带默认账号
    kLoginEn_pre_release,  //预生产环境
    kLoginEn_is_release     //生产环境
};

//企业及用户类

//用户角色
typedef enum : NSInteger
{
    kCompanyUserRole_SuperAdmin = 0,//超级管理员
    kCompanyUserRole_Admin,         //管理员
    kCompanyUserRole_Operator       //收银员
}CompanyUserRole;



#endif
