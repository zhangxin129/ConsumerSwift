//
//  GYHDSaleListModel.h
//  GYRestaurant
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYHDSaleListModel : NSObject
/*
 age = 20;
 ageScope = "";
 area = "";
 asc = 1;
 city = 11;
 coreName = "";
 custId = 06002110000055520160218;
 entCustId = 06002110000164063559693312;
 entResNo = 06002110000;
 enterprise = 06002110000;
 filterField = "";
 filterQuery = "<null>";
 headImage = "/opt/";
 hobby = "";
 keyword = "";
 mobile = "";
 name = "\U674e\U7487";
 nickName = 12345678944;
 operDuty = adf;
 operEmail = "";
 operName = "\U674e\U7487";
 operPhone = "";
 operator = 0555;
 operatorId = 0555;
 paginate = "<null>";
 parentEntResNo = "";
 province = 32;
 realName = "";
 resNo = "";
 roleName = "\U9001\U9910\U5458,\U5e97\U94fa\U7ba1\U7406\U5458";
 roleid = "0005,0002";
 "sale_network" = 2589424351560704;
 "sale_networkName" = "2589424351560704\U8425\U4e1a\U70b9";
 searchType = 0;
 sex = 1;
 sign = "";
 sortName = "";
 userType = 3;
 username = 0555;
 usernames = "<null>";
*/
@property(nonatomic,copy)NSString*headImage;//头像
@property(nonatomic,copy)NSString*roleName;//角色
@property(nonatomic,copy)NSString*entCustId;//企业资源号
@property(nonatomic,copy)NSString*custId;//企业custid
@property(nonatomic,copy)NSString*entResNo;//企业互生号
@property(nonatomic,copy)NSString*operDuty;//职位
@property(nonatomic,copy)NSString*operName;//操作员名称
@property(nonatomic,copy)NSString*operPhone;//电话
@property(nonatomic,copy)NSString*operatorId;//id
@property(nonatomic,copy)NSString*sale_networkName;//营业点名称
@property(nonatomic,copy)NSString*messageUnreadCount;//消息未读数量
@property(nonatomic,copy)NSString*resNo;//操作员绑定互生卡
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
