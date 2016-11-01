//
//  GYEasybuyGoodsInfoModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "JSONModel.h"

@protocol GYEasybuyGoodsinfoPropListSubsModel
@end
@protocol GYEasybuyGoodsinfoPropListModel
@end

@interface GYEasybuyGoodsinfoPropListModel : JSONModel

@property (copy, nonatomic) NSString* id;
@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray<GYEasybuyGoodsinfoPropListSubsModel>* subs;
//求GYEasybuyGoodsInfoPropListTableViewCell高度
@property (nonatomic, assign) CGFloat propListCellHeight;
- (void)getPropListCellHeightWithTitle:(NSString *)name subs:(NSArray *)subs;

@end
//----------------------------------------------
@interface GYEasybuyGoodsinfoPropListSubsModel : JSONModel

@property (copy, nonatomic) NSString* vid;
@property (copy, nonatomic) NSString* vname;
@property (nonatomic, assign)BOOL isSelected;//按钮选中

@end
//-----------------------------------------------
@interface GYEasybuyGoodsInfoModel : JSONModel

@property (strong, nonatomic) NSArray* basicParameter;
@property (assign, nonatomic) BOOL beCash;
@property (assign, nonatomic) BOOL beFocus;
@property (assign, nonatomic) BOOL beReach;
@property (assign, nonatomic) BOOL beSell;
@property (assign, nonatomic) BOOL beTake;
@property (assign, nonatomic) BOOL beTicket;

@property (copy, nonatomic) NSString* categoryId;
@property (copy, nonatomic) NSString* city;
@property (copy, nonatomic) NSString* companyResourceNo;
@property (copy, nonatomic) NSString* couponDesc;
@property (copy, nonatomic) NSNumber* evacount;
@property (copy, nonatomic) NSNumber* heightAuction;
@property (copy, nonatomic) NSString* id;
@property (copy, nonatomic) NSString* introduces;
@property (copy, nonatomic) NSNumber* isApplyCard;
@property (copy, nonatomic) NSString* itemUrl;
@property (copy, nonatomic) NSNumber* lowPrice;
@property (copy, nonatomic) NSNumber* lowPv;
@property (copy, nonatomic) NSNumber* monthlySales;
@property (copy, nonatomic) NSString* orderUrl;
@property (copy, nonatomic) NSString* picDetails;
@property (strong, nonatomic) NSArray* picList;
@property (copy, nonatomic) NSString* postage;
@property (copy, nonatomic) NSString* postageMsg;
@property (copy, nonatomic) NSNumber* price;
@property (strong, nonatomic) NSArray<GYEasybuyGoodsinfoPropListModel>* propList;
@property (copy, nonatomic) NSNumber* pv;
@property (copy, nonatomic) NSString* ruleId;
@property (copy, nonatomic) NSString* salerName;
@property (copy, nonatomic) NSNumber* salesCount;
@property (copy, nonatomic) NSString* serviceResourceNo;
@property (copy, nonatomic) NSString* shopId;
@property (copy, nonatomic) NSString* shopName;
@property (copy, nonatomic) NSString* tel;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* userId;
@property (copy, nonatomic) NSString* vShopId;
@property (copy, nonatomic) NSString* vShopName;


//求GYEasybuyGoodsInfoTableViewCell高度
@property (nonatomic, assign) CGFloat goodsInfoCellHeight;
- (void)getGoodsInfoCellHeightWithTitle:(NSString *)title beTicket:(BOOL)beTicket;


@end
