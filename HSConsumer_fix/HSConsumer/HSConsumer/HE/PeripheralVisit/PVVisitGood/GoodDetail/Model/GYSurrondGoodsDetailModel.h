//
//  GYSurrondGoodsDetailModel.h
//  HSConsumer
//
//  Created by apple on 15-3-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYSurrondGoodsDetailModel : NSObject

@property (nonatomic, copy) NSString* addr; //店铺的地址
@property (nonatomic, copy) NSString* beCash; //是否显示 现
@property (nonatomic, copy) NSString* beReach; //即
@property (nonatomic, copy) NSString* beSell; //卖
@property (nonatomic, copy) NSString* beTake; //提
@property (nonatomic, copy) NSString* beTicket; //券
@property (nonatomic, copy) NSString* beFocus; // 是否已经收藏 bug用bool接收有问题
@property (nonatomic, copy) NSString* companyResourceNo; //企业资源号
@property (nonatomic, copy) NSString* evacount; //评论数
@property (nonatomic, copy) NSString* introduces; //商品简介
@property (nonatomic, copy) NSString* itemName; //商品名称
@property (nonatomic, copy) NSString* goodsId; //商品ID
@property (nonatomic, copy) NSString* picDetails; //商品ID
@property (nonatomic, copy) NSString* lat; //店铺的经度
@property (nonatomic, copy) NSString* longitude; //店铺的纬度
@property (nonatomic, copy) NSString* shopsName; //店铺的名称
@property (nonatomic, copy) NSString* price; //商品价格
@property (nonatomic, copy) NSString* goodsPv; //商品的pv
@property (nonatomic, copy) NSString* rating; //星星
@property (nonatomic, copy) NSString* serviceResourceNo; //服务资源号
@property (nonatomic, copy) NSString* shopId; //店铺的ID
@property (nonatomic, copy) NSString* shopName; //店铺的ID
@property (nonatomic, copy) NSString* shopTel; //店铺电话
@property (nonatomic, copy) NSString* city; //城市
@property (nonatomic, copy) NSString* area; //区
@property (nonatomic, strong) NSMutableArray* propList; //商品的SKU
@property (nonatomic, copy) NSMutableArray* shopUrl; //店铺的图标url
@property (nonatomic, copy) NSString* vShopId; //商城ID
@property (nonatomic, copy) NSString* vShopName; //商城NAMEmonthlySales

@property (nonatomic, copy) NSString* monthlySales; //月销量
@property (nonatomic, copy) NSString* saleCount; //累计销量
@property (nonatomic, copy) NSString* shopDistance; //

// add by songjk
@property (nonatomic, copy) NSString* isApplyCard; // 是否申请互生卡
@property (nonatomic, copy) NSString *postage;//累计销量
@property (nonatomic, copy) NSString *postageMsg;//
@property (copy, nonatomic) NSString *lowPv;  //最低积分price
@property (copy, nonatomic) NSString *bigPrice;  //最高价格
@property (copy, nonatomic) NSString *lowPrice;  //最低价格
@end
