//
//  GYAuthorityCenter.h
//  company
//
//  Created by sqm on 16/1/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#ifndef GYAuthorityCenter_h
#define GYAuthorityCenter_h

#define kSYSTEM_ADMINISTRATOR [GYLoginHttpTool translationRole:BUSINESS_TRUSTEESHIP_SYSTEM_ADMINISTRATOR_ID] || [GYLoginHttpTool translationRole:MEMBER_ENTERPRISE_SYSTEM_ADMINISTRATOR_ID] || [GYLoginHttpTool translationRole:SERVICE_COMPANY_SYSTEM_ADMINISTRATOR_ID] //系统管理员
#define kNOT_SYSTEM_ADMINISTRATOR ![GYLoginHttpTool translationRole:BUSINESS_TRUSTEESHIP_SYSTEM_ADMINISTRATOR_ID] && ![GYLoginHttpTool translationRole:MEMBER_ENTERPRISE_SYSTEM_ADMINISTRATOR_ID] && ![GYLoginHttpTool translationRole:SERVICE_COMPANY_SYSTEM_ADMINISTRATOR_ID] //不是系统管理员

#define kSTORE_MANAGER [GYLoginHttpTool translationRole:BUSINESS_TRUSTEESHIP_STORE_MANAGER_ID] || [GYLoginHttpTool translationRole:MEMBER_ENTERPRISE_STORE_MANAGER_ID] //店铺管理员

#define kCASHIER [GYLoginHttpTool translationRole:BUSINESS_TRUSTEESHIP_CASHIER_ID] || [GYLoginHttpTool translationRole:MEMBER_ENTERPRISE_CASHIER_ID] //收银员

#define kWAITER [GYLoginHttpTool translationRole:BUSINESS_TRUSTEESHIP_WAITER_ID] || [GYLoginHttpTool translationRole:MEMBER_ENTERPRISE_WAITER_ID] //服务员

#define kSTAFFER [GYLoginHttpTool translationRole:BUSINESS_TRUSTEESHIP_STAFFER_ID] || [GYLoginHttpTool translationRole:MEMBER_ENTERPRISE_STAFFER_ID] //送餐员

/**托管企业--托管企业系统管理员角色id 301**/
NSString* const BUSINESS_TRUSTEESHIP_SYSTEM_ADMINISTRATOR_ID = @"301";
/**托管企业--店铺管理员角色id 302*/
NSString* const BUSINESS_TRUSTEESHIP_STORE_MANAGER_ID = @"302";
/**托管企业--收银员角色id 303*/
NSString* const BUSINESS_TRUSTEESHIP_CASHIER_ID = @"303";
/**托管企业--服务员角色id 304*/
NSString* const BUSINESS_TRUSTEESHIP_WAITER_ID = @"304";
/**托管企业--送餐员角色id 305*/
NSString* const BUSINESS_TRUSTEESHIP_STAFFER_ID = @"305";

/**成员企业--成员企业系统管理员角色id 201*/
NSString* const MEMBER_ENTERPRISE_SYSTEM_ADMINISTRATOR_ID = @"201";
/**成员企业--店铺管理员角色id 202*/
NSString* const MEMBER_ENTERPRISE_STORE_MANAGER_ID = @"202";
/**成员企业--收银员角色id 203*/
NSString* const MEMBER_ENTERPRISE_CASHIER_ID = @"203";
/**成员企业--服务员角色id 204*/
NSString* const MEMBER_ENTERPRISE_WAITER_ID = @"204";
/**成员企业--送餐员角色id 205*/
NSString* const MEMBER_ENTERPRISE_STAFFER_ID = @"205";

/**服务公司--系统管理员角色id 401*/
NSString* const SERVICE_COMPANY_SYSTEM_ADMINISTRATOR_ID = @"401";
/**服务公司--复核员角色id 402*/
NSString* const SERVICE_COMPANY_SYSTEM_RECHECK_ID = @"402";
/**服务公司--申报管理员角色id 403*/
NSString* const SERVICE_COMPANY_SYSTEM_APP_ID = @"403";

/*互商餐饮订单类型,1：店内，2：外卖，3：自提,@"":全部*/
NSString* const FOOD_ORDERS_ALLS = @"";
NSString* const FOOD_ORDERS_SHOP = @"1";
NSString* const FOOD_ORDERS_TAKEAWAY = @"2";
NSString* const FOOD_ORDERS_SINCE = @"3";

/*互商餐饮请求订单状态,未确认（1，8，-3），待送餐（2），待就餐（2，9），待自提（2），待结账（6，7），送餐中（3，11），取消待确认（10）今天（101），一个月（102）全部（）*/
NSString *const FOOD_ORDERSTATUS_NOCONFIRM = @"1,8,-3";
NSString *const FOOD_ORDERSTATUS_WAITROOM = @"2";
NSString *const FOOD_ORDERSTATUS_TREATEAT = @"2,9";
NSString *const FOOD_ORDERSTATUS_MENTION = @"2";
NSString *const FOOD_ORDERSTATUS_CHECK = @"6,7";
NSString *const FOOD_ORDERSTATUS_ROOMING = @"3,11";
NSString *const FOOD_ORDERSTATUS_CANCEL = @"10";
NSString *const FOOD_ORDERSTATUS_TODAY = @"101";
NSString *const FOOD_ORDERSTATUS_MONTH = @"102";
NSString *const FOOD_ORDERSTATUS_ALL = @"";


#endif /* GYAuthorityCenter_h */

