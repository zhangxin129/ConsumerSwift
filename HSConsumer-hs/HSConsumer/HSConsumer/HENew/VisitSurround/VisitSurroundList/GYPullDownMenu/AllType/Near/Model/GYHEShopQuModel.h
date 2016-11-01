//
//  GYHEShopQuModel.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYHEShopQuModel : JSONModel

@property(nonatomic, copy)NSString *areaCode;
@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *landmark;
@property(nonatomic, copy)NSString *locationName;

@end
