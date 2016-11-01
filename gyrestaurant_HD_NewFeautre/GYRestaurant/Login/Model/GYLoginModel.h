//
//  GYLoginModel.h
//  GYRestaurant
//
//  Created by sqm on 16/3/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  RoleListModel;
@interface GYLoginModel : NSObject
@property (nonatomic, copy) NSString *entResNo; //企业号
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *nickName;//昵称 需要返回
@property (nonatomic, strong) NSArray<RoleListModel *> *roles;//角色集合
@property (nonatomic, copy) NSString *vshopStatus;//是否开通商城
@property (nonatomic, copy) NSString *entResType;
@property (nonatomic, copy) NSString *hdDomain; //互动用户登录后缀域名 "hdimVhosts": "im.gy.com",
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopType;
@property (nonatomic, copy) NSString *vshopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *userName;//企业用户名
@property (nonatomic, copy) NSString *operName;//操作员名称
@property (nonatomic, copy) NSString *custId;//操作员客户id
@property (nonatomic, copy) NSString *entCustId;//企业客户id
@property (nonatomic, copy) NSString *entCustName;//企业名称
@property (nonatomic, copy) NSString *headPic;//头像
@property (nonatomic, copy) NSString *picUrl;//头像域名
@property (nonatomic, copy) NSString *hsecFoodPadUrl;//平板域名
@property (nonatomic, copy) NSString *hsecTfsUrl;//tfs
@property (nonatomic, copy) NSString *hdbizDomain;//互动请求好友域名
@property (nonatomic, copy) NSString *ttMsgServer; //互动域名
@property (nonatomic, copy) NSString* vshopLogo;//企业logo
@property (nonatomic, copy) NSString* vshopName;//企业名
@property (nonatomic, copy) NSString* hdimPsiServer;//拉取互动离线消息域名
@property (nonatomic, copy) NSString* hdimImgcAddr;//互动发送图片、视频、音频域名
@end
@interface GlobalAttribute : NSObject

@property (nonatomic, copy) NSString *currencyCode;              //货币代码
@property (nonatomic, copy) NSString*countryNo;//城市编码
@end
#pragma mark - 角色


@interface RoleListModel : NSObject

@property (nonatomic, copy) NSString *platformCode;
@property (nonatomic, copy) NSString *roleDesc;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *roleType;//1.全局 2.平台 3.私有
@property (nonatomic, copy) NSString *subSystemCode;

@end