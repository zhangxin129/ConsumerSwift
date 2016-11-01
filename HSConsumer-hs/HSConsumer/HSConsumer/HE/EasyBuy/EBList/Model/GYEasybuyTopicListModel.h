//
//  GYEasybuyTopicListModel.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "JSONModel.h"

@interface GYEasybuyTopicListModel : JSONModel

@property (assign, nonatomic) NSString* beCash;
@property (assign, nonatomic) NSString* beReach;
@property (assign, nonatomic) NSString* beSell;
@property (assign, nonatomic) NSString* beTake;
@property (assign, nonatomic) NSString* beTicket;
@property (copy, nonatomic) NSString* city;
@property (copy, nonatomic) NSString* companyName;
@property (copy, nonatomic) NSString* id;
@property (copy, nonatomic) NSNumber* monthlySales;
@property (copy, nonatomic) NSNumber* price;
@property (copy, nonatomic) NSNumber* pv;
@property (copy, nonatomic) NSNumber* salesCount;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* url;
@property (copy, nonatomic) NSString* vShopId;

@end
