//
//  FDOrderConfirmModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/9/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel+LoadData.h"
#import "FDFoodFormatModel.h"

@interface FDOrderConfirmModel : JSONModel
@property (nonatomic, copy) NSString* fullOffDesc;
@property (nonatomic, copy) NSString* type; ////订单类型，1 店内，2外卖
@property (nonatomic, copy) NSString* shopId; ////营业点ID
@property (nonatomic, copy) NSString* vShopId; ////企业ID
@property (nonatomic, copy) NSString* totalAmount; ////菜品总金额
@property (nonatomic, copy) NSString* totalPv; ////菜品积分
@property (nonatomic, copy) NSMutableArray* foodArr; ///菜品列表
@property (nonatomic, copy) NSString* restaurantAddres; ///餐厅地址
@property (nonatomic, copy) NSString* restaurantName; ////餐厅名称
@property (nonatomic, copy) NSString* openingHours; //营业时间
@property (copy, nonatomic) NSString* moneyEarnest; //定金
@property (copy, nonatomic) NSString* sendPrice; //配送费
@property (copy, nonatomic) NSArray* timeresultShop2; //店内时间
@property (copy, nonatomic) NSArray* timeresultSince2; //自提时间
@property (copy, nonatomic) NSArray* timeresultTakeaway; //外卖时间
@property (copy, nonatomic) NSArray* timeresultShopNoShop; //店内时间 不在内的时间
@property (copy, nonatomic) NSArray* timeresultSinceNoShop; //自提时间 不在内的时间
@property (assign, nonatomic) BOOL supportTake; //支持自提
@property (assign, nonatomic) BOOL supportAppointment; //支持预约
@property (copy, nonatomic) NSString *fulloffPrice;//
@property(nonatomic, copy) NSString *fullPrice;
@property(nonatomic, copy) NSString *offPrice;
@end





