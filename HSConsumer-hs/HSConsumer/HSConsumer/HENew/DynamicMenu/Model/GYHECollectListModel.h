//
//  GYHECollectListModel.h
//  HSConsumer
//
//  Created by xiaoxh on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface pics : JSONModel
@property (nonatomic,copy)NSString *p700x700;
@property (nonatomic,copy)NSString *p200x200;
@property (nonatomic,copy)NSString *p110x110;
@property (nonatomic,copy)NSString *sourceSize;
@property (nonatomic,copy)NSString *p300x300;
@property (nonatomic,copy)NSString *p340x340;
@property (nonatomic,copy)NSString *p400x400;
@end

@protocol pics

@optional

@end

@interface servicesInfo : JSONModel
@property (nonatomic,assign)BOOL hasSerDeposit;//是否有预约服务
@property (nonatomic,assign)BOOL hasSerTakeout;//是否有外卖服务
@property (nonatomic,assign)BOOL hasSerCoupon;//是否有抵扣券服务
@end

@interface GYHECollectListModel : JSONModel

@property (nonatomic,copy)NSString *itemId;//商品ID
@property (nonatomic,copy)NSString *pvHigh;//最高积分
@property (nonatomic,copy)NSString *pvLow;//最低积分
@property (nonatomic,copy)NSString *postage;//配送费
@property (nonatomic,copy)NSString *useAmount;//抵扣券（满多少）
@property (nonatomic,copy)NSString *priceHigh;//最高价格
@property (nonatomic,copy)NSString *priceLow;//最低价格
@property (nonatomic,strong)servicesInfo *servicesInfo;//支持的服务
@property (nonatomic,copy)NSString *useNumber;//抵扣券（用多少张）
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic,strong)NSMutableArray <pics> *pics;//商品图片数组

@end
