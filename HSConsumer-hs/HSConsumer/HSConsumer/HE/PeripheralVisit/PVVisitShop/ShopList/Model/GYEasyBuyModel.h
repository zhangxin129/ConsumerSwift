//
//  GYEasyBuyModel.h
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

//商品模型
@class ShopModel;
@interface GYEasyBuyModel : NSObject
@property (nonatomic, strong) NSString* strGoodPictureURL; //商品图标URL
@property (nonatomic, strong) NSString* strGoodName; //商品名称
@property (nonatomic, strong) NSString* strGoodPoints; //商品赠送积分
@property (nonatomic, strong) NSString* strGoodPrice; //商品价格
@property (nonatomic, strong) NSString* strGoodId; //商品id
@property (nonatomic, strong) NSString* strRage; //商品id
@property (nonatomic, assign) BOOL beCash; //
@property (nonatomic, assign) BOOL beReach; //
@property (nonatomic, assign) BOOL beSell; //
@property (nonatomic, assign) BOOL beTake; //
@property (nonatomic, assign) BOOL beTicket; //

@property (nonatomic, strong) NSString* strGoodsCnt; //商品数量
@property (nonatomic, strong) NSString* strTotalPage; //商品数量currentPageIndex
@property (nonatomic, strong) NSString* strTotalRows; //商品数量
@property (nonatomic, strong) NSString* strCurrentPageIndex; //商品数量
@property (nonatomic, strong) ShopModel* shopInfo; //对应商铺信息
@property (nonatomic, strong) NSNumber* numBroweTime; //浏览商品时间
@property (nonatomic, strong) NSString* companyName; //浏览商品时间
@property (nonatomic, strong) NSString* monthlySales; //浏览商品时间 city
// add by songjk 累计销量
@property (nonatomic, strong) NSString* saleCount; //浏览商品时间 city
@property (nonatomic, strong) NSString* city;
//init methods
+ (GYEasyBuyModel*)initWithName:(NSString*)name pictureURL:(NSString*)picture;
+ (GYEasyBuyModel*)initWithName:(NSString*)name price:(NSString*)price_ pictureURL:(NSString*)picture;

@end

//商铺模型
@interface ShopModel : JSONModel
@property (nonatomic, copy) NSString* strStoreName; //店铺名称 add by songjk
@property (nonatomic, copy) NSString* strShopPictureURL; //商铺图标URL
@property (nonatomic, copy) NSString* strShopId; //商铺图标URL
@property (nonatomic, copy) NSString* strShopName; //商铺名称
@property (nonatomic, copy) NSString* strShopAddress; //商铺地址
@property (nonatomic, copy) NSString* strShopTel; //商铺电话
@property (nonatomic, copy) NSString* strTitle; // 我的关注中用到
@property (nonatomic, copy) NSString* strCompanyName; //企业名称
@property (nonatomic, copy) NSString* strResno; //企业资源号
@property (nonatomic, copy) NSString* pointsProportion; //积分比例
@property (nonatomic, copy) NSString* categoryNames; //主营类别
@property (nonatomic, copy) NSString* section; //商圈名称
@property (nonatomic, assign) BOOL isCollect; //是否收藏
@property (nonatomic, assign) BOOL isAttention; //是否关注
@property (nonatomic, assign) BOOL isShare; //是否分享

@property (nonatomic, copy) NSString* beCash; //
@property (nonatomic, copy) NSString* beReach; //
@property (nonatomic, copy) NSString* beSell; //
@property (nonatomic, copy) NSString* beTake; //
@property (nonatomic, copy) NSString* beQuan; //
@property (nonatomic, copy) NSString* beTicket; //
@property (nonatomic, copy) NSString* strLat; //经度
@property (nonatomic, copy) NSString* strLongitude; //纬度
@property (nonatomic, copy) NSString* strRate; //评分
@property (nonatomic, copy) NSString* shopDistance; //
@property (nonatomic, copy) NSString* strVshopId; //纬度
@property (nonatomic, copy) NSString* strIntroduce; //简介
@property (nonatomic, strong) NSMutableArray* marrShopImages; //店铺图片
@property (nonatomic, strong) NSMutableArray* marrAllShop; //所有店铺
@property (nonatomic, strong) NSMutableArray* marrHotGoods; //所有店铺
@property (nonatomic, copy) NSString* strScope; //经营范围
@property (nonatomic, copy) NSString* strConcernTime; //被当前用户关注时间
@property (nonatomic, copy) NSString* strResourceNumber; //被当前用户关注时间
@property (nonatomic, copy) NSString* strEvacount; //评价
@property (nonatomic, copy) NSString* strCity; //城市
@property (nonatomic, copy) NSString* strArea; //区
@property (nonatomic, copy) NSString *picURL;//搜索商铺的
@property (nonatomic, assign) BOOL befocus;//被当前用户关注时间
@property (nonatomic, copy) NSString *strShopDistance;

@property (nonatomic, copy) NSString *strID;
+ (ShopModel *)initWithName:(NSString *)name address:(NSString *)pAddress tel:(NSString *)pTel pictureURL:(NSString *)picture;
+ (ShopModel *)modelWithDictionary:(NSDictionary *)dict;

@end