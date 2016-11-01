//
//  GYSurroundVisitShopListModel.h
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/22.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "JSONModel.h"

@interface GYSurroundVisitShopListModel : JSONModel

@property (nonatomic, assign) BOOL beSell;
@property (nonatomic, assign) BOOL beQuan;
@property (nonatomic, copy) NSString* categoryNames;
@property (nonatomic, assign) BOOL beCash;
@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* vShopId;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* shopPic;
@property (nonatomic, assign) BOOL beTake;
@property (nonatomic, copy) NSString* pointsProportion;
@property (nonatomic, copy) NSString* companyName;
@property (nonatomic, copy) NSString* resno;
@property (nonatomic, copy) NSString* dist;
@property (nonatomic, copy) NSString* rate;
@property (nonatomic, copy) NSString* section;
@property (nonatomic, copy) NSString* addr;
@property (nonatomic, copy) NSString* tel;
@property (nonatomic, assign) BOOL beReach;

@end
