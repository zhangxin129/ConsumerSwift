//
//  GYHSVoucherModel.h
//  HSConsumer
//
//  Created by User on 16/10/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHSVoucherModel : JSONModel

@property (nonatomic, copy) NSString *titleTag;
@property (nonatomic, copy) NSString *date;
//@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *hsbTag;
@property (nonatomic, copy) NSString *hsbAmount;
@property (nonatomic, copy) NSString *pvTag;
@property (nonatomic, copy) NSString *pvNum;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *shopTag;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, copy) NSString *AmountTag;
@property (nonatomic, copy) NSString *AmountNum;
@property (nonatomic, copy) NSString *orderTag;
@property (nonatomic, copy) NSString *orderNum;

@end
