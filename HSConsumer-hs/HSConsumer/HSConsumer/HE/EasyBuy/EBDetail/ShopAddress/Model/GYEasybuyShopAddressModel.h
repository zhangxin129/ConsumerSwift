//
//  GYEasybuyShopAddressModel.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYEasybuyShopAddressModel : JSONModel

@property (nonatomic, copy) NSString* tel;
@property (nonatomic, copy) NSString* lat;
@property (nonatomic, copy) NSString* shopId;
@property (nonatomic, copy) NSString* addr;
@property (nonatomic, copy) NSString* longitude;
@property (nonatomic, copy) NSString* shopName;

@property (nonatomic,assign) CGFloat cellHeight;


-(GYEasybuyShopAddressModel *)initWithDic:(NSDictionary *)dic;

@end
