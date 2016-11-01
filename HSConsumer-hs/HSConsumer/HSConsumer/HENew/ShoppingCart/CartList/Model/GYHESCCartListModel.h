//
//  GYHESCCartListModel.h
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHESCCartListModel : JSONModel
@property (nonatomic, copy) NSString* cartId; //购物车id
@property (nonatomic, copy) NSString* categoryId; //类目id
@property (nonatomic, copy) NSString* companyResourceNo; //企业资源号
@property (nonatomic, copy) NSString* count; //商品数量
@property (nonatomic, copy) NSString<Optional>* couponDesc; //消费抵扣券描述信息
@property (nonatomic, copy) NSString* heightAuction; //最高积分
@property (nonatomic, copy) NSString* id; //商品的id
@property (nonatomic, copy) NSString* isApplyCard; //是否可申请互生卡
@property (nonatomic, copy) NSString* price; //商品的价格
@property (nonatomic, copy) NSString* pv; //商品的pv
@property (nonatomic, copy) NSString<Optional>* ruleId; //
@property (nonatomic, copy) NSString* serviceResourceNo; //服务资源号
@property (nonatomic, copy) NSString* shopId; //营业点id
@property (nonatomic, copy) NSString* shopName; //营业点名称
@property (nonatomic, copy) NSString* sku; //sku
@property (nonatomic, copy) NSString* skuId; //skuid
@property (nonatomic, copy) NSString* title; //商品的名称
@property (nonatomic, copy) NSString* url; //商品图片url
@property (nonatomic, copy) NSString* vShopId; //商城id
@property (nonatomic, copy) NSString* vShopName; //商城名称

@property (nonatomic, assign) BOOL isSelect;//是否被选中
@property (nonatomic, assign) BOOL isShowMore;//是否显示更多

@end
