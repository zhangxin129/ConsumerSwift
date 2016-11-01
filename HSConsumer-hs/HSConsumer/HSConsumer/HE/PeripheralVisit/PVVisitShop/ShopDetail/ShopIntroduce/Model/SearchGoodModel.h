//
//  SearchGoodModel.h
//  HSConsumer
//
//  Created by 00 on 15-1-21.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGoodModel : NSObject

@property (nonatomic, copy) NSString* name; //名字
@property (nonatomic, copy) NSString* uid; //id
@property (nonatomic, copy) NSString* picAddr; //图片url
@property (nonatomic, strong) NSMutableArray* arrModel; //模型数组

@property (nonatomic, copy) NSString* property ; //属性
@property (nonatomic, copy) NSString* desc; //副标题

/*搜索商品 属性*/
@property (nonatomic, copy) NSString* addr; //店铺的地址
@property (nonatomic, copy) NSString* beCash; //是否显示 现
@property (nonatomic, copy) NSString* beReach; //即
@property (nonatomic, copy) NSString* beSell; //卖
@property (nonatomic, copy) NSString* beTake; //提
@property (nonatomic, copy) NSString* beTicket; //券
@property (nonatomic, copy) NSString* goodsId; //商品ID
@property (nonatomic, copy) NSString* shoplat; //店铺的经度
@property (nonatomic, copy) NSString* shoplongitude; //店铺的纬度
@property (nonatomic, copy) NSString* shopsName; //店铺的名称
@property (nonatomic, copy) NSString* price; //商品价格
@property (nonatomic, copy) NSString* goodsPv; //商品的pv
@property (nonatomic, copy) NSString* shopId; //店铺的ID
@property (nonatomic, copy) NSString* shopTel; //店铺电话
@property (nonatomic, copy) NSString* shopUrl; //店铺的图标url
@property (nonatomic, copy) NSString* vShopId; //副标题
@property (nonatomic, copy) NSString* shopSection; //商铺section
@property (nonatomic, copy) NSString* shopDistance; //商铺section
@property (nonatomic, copy) NSString* shopRating; //商铺section
@property (nonatomic, copy) NSString* city; //城市
@property (nonatomic, copy) NSString* area; //区
@property (nonatomic, copy) NSString* moonthlySales;
@property (nonatomic, copy) NSString* companyName;
// add by songjk 累计销量
@property (nonatomic, copy) NSString *saleCount;
@property (nonatomic, copy) NSString *factoryName; // 产地
@property (nonatomic, copy) NSString *lowPv; // 最低积分
@end
