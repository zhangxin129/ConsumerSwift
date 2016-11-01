//
//  GYHEEasyBuyListModel.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHEEasyBuyListModel : JSONModel
@property (copy, nonatomic) NSString* iconImage;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* price;
@property (copy, nonatomic) NSString* pv;
@property (copy, nonatomic) NSString* companyName;
@property (copy, nonatomic) NSString* city;


@property (assign, nonatomic) NSString* beCash;
@property (assign, nonatomic) NSString* beReach;
@property (assign, nonatomic) NSString* beSell;
@property (assign, nonatomic) NSString* beTake;
@property (assign, nonatomic) NSString* beTicket;



@end
