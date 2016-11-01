//
//  GYAddressModel.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kReceiveGoodsLocationChanged @"receiveGoodsLocationChanged"
@class GYAddressHeightModel;
@interface GYAddressModel : JSONModel
@property (nonatomic, copy) NSString* mobile; //移动电话
@property (nonatomic, copy) NSString* provinceNo; //省代码
@property (nonatomic, copy) NSString* telphone; //电话
@property (nonatomic, copy) NSString* isDefault; // 是否是默认地址
@property (nonatomic, copy) NSString* postCode; //邮编
@property (nonatomic, copy) NSString* address; //详细地址
@property (nonatomic, copy) NSString* addrId; // 地址ID
@property (nonatomic, copy) NSString* area; //地区，县
@property (nonatomic, copy) NSString* countryNo; //国家代码
@property (nonatomic, copy) NSString* custId; //客户ID
@property (nonatomic, copy) NSString* cityNo; //城市代码
@property (nonatomic, copy) NSString* receiver; //收件人
@property (nonatomic, copy) NSString* detail;
@property (nonatomic, copy) NSString* beDefault;
@property (nonatomic, copy) NSString* idString;
//以下接口没传数据过来
@property (nonatomic, copy) NSString* phone; //固定电话
@property (nonatomic, copy) NSString* province; //省
@property (nonatomic, copy) NSString* city; //城市
@property (nonatomic, copy) NSString* country; //国家

@property (nonatomic, copy) NSString* fullAddress; // 省+城市+区+详细地址 //add by liangzm
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) float height;

@property (nonatomic, strong) GYAddressHeightModel *heightModel;

+ (JSONKeyMapper *)keyMapper;

- (GYAddressModel *)dataWithDic:(NSDictionary *)dic isFood:(BOOL)isFood;


@end
