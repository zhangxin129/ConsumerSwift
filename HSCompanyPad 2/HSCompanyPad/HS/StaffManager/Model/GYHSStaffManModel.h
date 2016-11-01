//
//  GYHSStaffManModel.h
//
//  Created by apple on 16/8/11.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHSStaffManModel : NSObject

@property (nonatomic, copy) NSString* userName; //用户名
@property (nonatomic, copy) NSString* operDuty; //职务
@property (nonatomic, copy) NSString* realName; //员工姓名
@property (nonatomic, copy) NSString* bindResNoStatus; //是否绑定状态(1绑定，0未绑定，-1绑定中)
@property (nonatomic, copy) NSString* operCustId; //操作员客户号
@property (nonatomic, copy) NSString* operResNo;
@property (nonatomic, copy) NSString* entResNo;
@property (nonatomic, copy) NSString* roleName; //角色
@property (nonatomic, copy) NSString* remark;
@property (nonatomic, strong) NSArray* roleList;
@property (nonatomic, copy) NSString* loginPwd;
@property (nonatomic, strong) NSArray* relationShops; //营业点的集合
@property (nonatomic, copy) NSString *operType;//是否开启客服
/*
 *操作员状态
 *0：启用
 *1：禁用
 *2:已删除
 */
@property (nonatomic, copy) NSString* accountStatus;
@property (nonatomic, copy) NSString* roleId;
@property (nonatomic, assign) CGFloat fRoleNameHeight;
@property (nonatomic, assign) CGFloat fCellHeight;

@property (nonatomic, copy) NSString* mobile;

@end

@interface GYRelationShopsModel : NSObject
@property (nonatomic, copy) NSString* shopId; //营业点ID
@property (nonatomic, copy) NSString* shopName; //营业点名称
@property (nonatomic) BOOL isSelected; //本地标记是否被选中
@end

@interface GYRoleListModel : NSObject
@property (nonatomic, copy) NSString* entCustId;
@property (nonatomic, copy) NSString* platformCode;
@property (nonatomic, copy) NSString* roleDesc;
@property (nonatomic, copy) NSString* roleId;
@property (nonatomic, copy) NSString* roleName;
@property (nonatomic, copy) NSString* roleType;
@property (nonatomic, copy) NSString *subSystemCode;
@property (nonatomic, assign) BOOL isSelected;//本地标记是否被选中
@property (nonatomic, assign) CGFloat cellHeight;


@end
                                                