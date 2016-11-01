//
//  GYGoodsDetailModel.h
//  HSConsumer
//
//  Created by 00 on 15-2-4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
/*
 *****************************************************************
   选择实体店数据模型
 *****************************************************************
 */
@interface SelShopModel : JSONModel

@property (copy, nonatomic) NSString* shopId; //值ID
@property (copy, nonatomic) NSString* addr; //地址
@property (copy, nonatomic) NSString* shopName; //店名字
@property (copy, nonatomic) NSString* tel; //店地址
@property (copy, nonatomic) NSString* distance; //距离
@property (copy, nonatomic) NSString* lat; //
@property (copy, nonatomic) NSString* longitude; //

@property (nonatomic, assign) CGFloat height;
@end

/*
 *****************************************************************
   商品详情数据模型
 *****************************************************************
 */

@interface ArrSubsModel : JSONModel

@property (copy, nonatomic) NSString* vid; //值ID
@property (copy, nonatomic) NSString* vName; //值Name

@end

@interface ArrModel : JSONModel

@property (copy, nonatomic) NSString* key; //参数key
@property (copy, nonatomic) NSString* value; //参数值

@property (copy, nonatomic) NSString* picUrl; //图文详情

@property (strong, nonatomic) NSMutableArray* arrSubs; //选择框内按钮数组
@property (copy, nonatomic) NSString* propId; //弹窗ID
@property (copy, nonatomic) NSString* propName; //弹窗名字

@end

@interface GYGoodsDetailModel : JSONModel

@property (copy, nonatomic) NSString* title; //商品标题
@property (copy, nonatomic) NSString* pv; //pv
@property (copy, nonatomic) NSString* heightPrice; //最高价格
@property (copy, nonatomic) NSString* lowPrice; //最低价格
@property (copy, nonatomic) NSString* monthlySales; //月销量
@property (copy, nonatomic) NSString* saleCount; //累计销量
@property (copy, nonatomic) NSString* evaCount; //商品评价
@property (copy, nonatomic) NSString* picDetails; //图文详情
//－－－－－－－－－－－－－－－－SKU返回数据－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
@property (copy, nonatomic) NSString* strPicList; //图文详情
@property (copy, nonatomic) NSString* strPrice; //图文详情
@property (copy, nonatomic) NSString* strPv; //图文详情
@property (copy, nonatomic) NSString* strSkuId; //图文详情
@property (copy, nonatomic) NSString* goodsNum; //商品数量
@property (copy, nonatomic) NSString* defaultShopName; //默认实体店名
@property (copy, nonatomic) NSString* defaultShopId; //默认实体店ID

//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
@property (copy, nonatomic) NSString* beFocus; //关注
@property (copy, nonatomic) NSString* categoryId; //类别ID
@property (copy, nonatomic) NSString* companyResourceNo; //企业资源号
@property (copy, nonatomic) NSString* heightAuction; //最高积分
@property (copy, nonatomic) NSString* orderUrl; //订单URl
@property (copy, nonatomic) NSString* serviceResourceNo; //服务企业号

@property (copy, nonatomic) NSString* vShopId; //店铺ID
@property (copy, nonatomic) NSString* vShopName; //店名字
@property (nonatomic, copy) NSString* strCity;
@property (copy, nonatomic) NSString* goodsID; //商品ID
@property (copy, nonatomic) NSString* goodsSkus; //商品ID

@property (nonatomic, copy) NSString* beCash;
@property (nonatomic, copy) NSString* beReach;
@property (nonatomic, copy) NSString* beSell;
@property (nonatomic, copy) NSString* beTake;
@property (nonatomic, copy) NSString* beTicket;

@property (strong, nonatomic) NSMutableArray* arrPicList; //图片数组
@property (strong, nonatomic) NSMutableArray* arrBasicParameter; //基本参数素组

@property (strong, nonatomic) NSMutableArray* arrPropList; //弹窗数组
// add by songjk
@property (copy, nonatomic) NSString *strRuleID;  //  折扣id
// add by songjk
@property (copy, nonatomic) NSString *isApplyCard;  //  是否可以申请互生卡
@property (copy, nonatomic) NSString *postage;  // 快递费
@property (copy, nonatomic) NSString *postageMsg;  // 快递信息
@property (copy, nonatomic) NSString *couponDesc;  // 抵扣券信息
@property (copy, nonatomic) NSString *lowPv;  //最低积分price
@property (copy, nonatomic) NSString *price;  //最高价格
@property (copy, nonatomic) NSString *dist;  // 距离



@property (copy, nonatomic) NSString *sku;
@end


