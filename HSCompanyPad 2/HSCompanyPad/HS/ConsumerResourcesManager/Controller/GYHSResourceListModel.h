//
//  GYHSResourceListModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSResourceListModel : NSObject

@property (nonatomic, copy) NSString* entResNo; //资源号
@property (nonatomic, copy) NSString* entName; //企业名称
@property (nonatomic, copy) NSString* entAddress; //企业地址
@property (nonatomic, copy) NSString* contactPerson; //联系人
@property (nonatomic, copy) NSString* contactPhone; //联系人电话
@property (nonatomic, copy) NSString* registrationDate; //注册时间
@property (nonatomic, copy) NSString* realnameAuthStatus; //实名认证状态1已认证、0未认证
@property (nonatomic, copy) NSString* involvedPointStatus; //参与积分状态 1：正常2：预警3：休眠4：长眠5：已注销6：申请停止积分活动中(不显示)7：停止积分活动8：注销申请中
@property (nonatomic, copy) NSString* enabledCardholderNumber; //用户数量
@property(nonatomic, copy)NSString *provinceNo ;
@property(nonatomic, copy)NSString *cityNo ;
@property(nonatomic, copy)NSString *countryNo ;
@property (nonatomic, copy) NSString *baseStatus;
@property (nonatomic, copy) NSString *cardStatus;
@property (nonatomic, copy) NSString *authStatus;
@property (nonatomic, copy) NSString *resNo;
@property (nonatomic, copy) NSString *updateTime;

@end
