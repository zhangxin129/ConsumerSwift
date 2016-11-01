//
//  GYHEVisitListModel.h
//  HSConsumer
//
//  Created by kuser on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface logoModel : JSONModel
@property (copy, nonatomic) NSString *p110x110;
@property (copy, nonatomic) NSString *p200x200;
@property (copy, nonatomic) NSString *p300x300;
@property (copy, nonatomic) NSString *p400x400;
@property (copy, nonatomic) NSString *p340x340;
@property (copy, nonatomic) NSString *sourceSize;
@end

@interface servicesInfoModel : JSONModel
@property (assign, nonatomic) BOOL hasSerCoupon;
@property (assign, nonatomic) BOOL hasSerDeposit;
@property (assign, nonatomic) BOOL hasSerTakeout;
@end


@interface GYHEVisitListModel : JSONModel
@property(nonatomic, copy)NSString *vshopName;
@property(nonatomic, copy)NSString *mpNames;
@property(nonatomic, copy)NSString *addr;
@property(nonatomic, copy)NSString *locationName;
@property(nonatomic, copy)NSString *dist;
@property(nonatomic, copy)NSString *vshopId;
@property(nonatomic, strong)logoModel *logo;
@property(nonatomic, copy)NSString *custId;
@property(nonatomic, copy)NSString *resourceNo;
@property(nonatomic, strong)servicesInfoModel *servicesInfo;
@end
