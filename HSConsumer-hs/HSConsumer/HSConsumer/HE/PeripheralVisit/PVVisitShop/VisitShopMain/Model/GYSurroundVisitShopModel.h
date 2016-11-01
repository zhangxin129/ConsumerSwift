//
//  GYSurroundVisitShopModel.h
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel.h"
@protocol GYSurroundVisitShopItemModel

@end

@interface GYSurroundVisitShopItemModel : JSONModel
@property (nonatomic, copy) NSString* categoryName;
@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* picAddr;

@end

@interface GYSurroundVisitShopModel : JSONModel
@property (nonatomic, strong) NSArray* beforeShopList;
@property (nonatomic, strong) NSArray<GYSurroundVisitShopItemModel>* firstCategories;
@property (nonatomic, strong) NSArray<GYSurroundVisitShopItemModel>* secondCategories;
@property (nonatomic, strong) NSArray<GYSurroundVisitShopItemModel>* thirdCategories;
@property (nonatomic, strong) NSArray<GYSurroundVisitShopItemModel>* fourthCategories;
@end
